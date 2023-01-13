#dbk = Deutsche Bank AG
#mbg = Mercedes-Benz Group AG
library(dplyr)
library(DBI)

# Check data type
str(daimler)
str(deutschebank)

# Drop unused columns (Erster,Hoch,Tief,Stuecke,Volumen)
daimler <- daimler[-c(1:2,4:6,8:9)]
deutschebank <- deutschebank[-c(1:2,4:6,8:9)]

# Calculating logarithmic returns (Rendite Prozent)
n_mbg <- length(daimler$Schlusskurs)
logreturn_mbg <- log(daimler$Schlusskurs[-1]/daimler$Schlusskurs[-n_mbg])

n_dbk <- length(deutschebank$Schlusskurs)
logreturn_dbk <- log(deutschebank$Schlusskurs[-1]/deutschebank$Schlusskurs[-n_dbk])

# Convert the returns to Data Frame to better view
logreturndf_mbg <- data.frame(logreturn_mbg)
sortedlog_mbg <- data.frame(logreturndf_mbg[order(logreturn_mbg),]) %>% 
  rename(rendite_mbg = 1)

logreturndf_dbk <- data.frame(logreturn_dbk)
sortedlog_dbk <- data.frame(logreturndf_dbk[order(logreturn_dbk),]) %>% 
  rename(rendite_dbk = 1)

# Calculate the weight of portfolio (assume that we have 1.000.000€ capital 
# in one portfolio. 600.000€ = mbg , 400.000€ = dbk)

total_kapital <- 1000000
kapital_mbg <- 600000
kapital_dbk <- total_kapital-kapital_mbg 


# Calculate the € Returns (Rendite Euro)
returns_mbg <- logreturn_mbg*kapital_mbg
returns_dbk <- logreturn_dbk*kapital_dbk

portfoliovalue_mbg <- data.frame(returns_mbg)
portfoliovalue_dbk <- data.frame(returns_dbk)

#calculate total value of portfolio
portfoliovalue <- data.frame(returns_mbg+returns_dbk)%>% 
  rename(portfoliovalues = 1)

# first percentile (Confidence Interval = 99%)
var99 <- unname(quantile(portfoliovalue$portfoliovalues, c(.01)))

# fifth percentile (Confidence Interval = 95%)
var95 <- unname(quantile(portfoliovalue$portfoliovalues, c(.05)))

portfolio_r <- data.frame(
  datum = c(daimler$Datum[-1]),
  rendite_prozent_mbg = c(logreturn_mbg),
  rendite_prozent_dbk = c(logreturn_dbk),
  rendite_euro_mbg = c(returns_mbg),
  rendite_euro_dbk = c(returns_dbk),
  portfolio = c(portfoliovalue))
  
valueatrisk <- data.frame(
  var_99 = c(var99),
  var_95 = c(var95))

df <- data.frame(Portfolio_id = 1, 
                 Datum = "2023-01-05", 
                 Snapshot_id = 2, 
                 Value_at_risk = var99,
                 Wert = total_kapital+var99,
                 stringsAsFactors = FALSE)

wert_berechnen <- dbGetQuery(rms_dbs, 
"SELECT p.Portfolio_id, p.Datum, p.Snapshot_id, p.Value_at_risk, SUM(s.Anzahl * t.Schlusskurs) AS Wert
FROM Portfolio p
INNER JOIN Snapshot s ON s.Snapshot_id = p.Snapshot_id
INNER JOIN Tagespreis t ON t.Aktien_id = s.Aktien_id AND t.Datum = p.Datum
GROUP BY Snapshot_id;")

#wert_berechnen$Value_at_risk[1:2] <- c(10000,123123)

# Converted to correct Datatype
df$Datum <- as.Date(df$Datum, "%Y-%m-%d")
df$Portfolio_id <- as.integer(df$Portfolio_id)
df$Snapshot_id <- as.integer(df$Snapshot_id)

portfolio <- rbind(portfolio, df)

# Write table in SQL

DBI::dbWriteTable(rms_dbs, "portfolio", df, append=TRUE, row.names=FALSE)

dbDisconnect(rms_dbs)
