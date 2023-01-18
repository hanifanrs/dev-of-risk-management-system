#dbk = Deutsche Bank AG
#mbg = Mercedes-Benz Group AG
library(dplyr)
library(DBI)
library(lubridate)

# Check data type
str(daimler)
str(deutschebank)

# Drop unused columns (Erster,Hoch,Tief,Stuecke,Volumen)
daimler <- daimler[-c(1:2,4:6,8:9)]
deutschebank <- deutschebank[-c(1:2,4:6,8:9)]

# Filter to 2022 year only
daimler <- subset(daimler, year(daimler$Datum) == 2022)
deutschebank <- subset(deutschebank, year(deutschebank$Datum) == 2022)

# Sort descending
daimler <- daimler %>% arrange_all(desc)
deutschebank <- deutschebank %>% arrange_all(desc)

# Calculating logarithmic returns (Rendite Prozent)
n_mbg <- length(daimler$Schlusskurs)
daimler_rendite <- log(daimler$Schlusskurs[-1]/daimler$Schlusskurs[-n_mbg])
daimler_rendite <- append(daimler_rendite, 0)

n_dbk <- length(deutschebank$Schlusskurs)
deutschebank_rendite <- log(deutschebank$Schlusskurs[-1]/deutschebank$Schlusskurs[-n_dbk])
deutschebank_rendite <- append(deutschebank_rendite, 0)

# Number of shares
anzahl <- dbGetQuery(rms_dbs,
"SELECT p.Datum, s.Anzahl, t.Aktien_id
FROM Portfolio p
INNER JOIN Snapshot s ON s.Snapshot_id = p.Snapshot_id
INNER JOIN Tagespreis t ON t.Aktien_id = s.Aktien_id AND t.Datum = p.Datum;")

daimler_anzahl <- subset(anzahl, anzahl$Aktien_id == 1)
daimler_anzahl <- daimler_anzahl %>% arrange_all(desc)
daimler_anzahl_heute <- daimler_anzahl[1,2]
daimler_anzahl_heute <- as.matrix(daimler_anzahl_heute)

deutschebank_anzahl <- subset(anzahl, anzahl$Aktien_id == 2)
deutschebank_anzahl <- deutschebank_anzahl %>% arrange_all(desc)
deutschebank_anzahl_heute <- deutschebank_anzahl[1,2]
deutschebank_anzahl_heute <- as.matrix(deutschebank_anzahl_heute)

# Wert
daimler_wert <- daimler$Schlusskurs * daimler_anzahl$Anzahl
deutschebank_wert <- deutschebank$Schlusskurs * deutschebank_anzahl$Anzahl

# Calculate the Value of Portfolio
portfolio_r <- daimler_wert+deutschebank_wert

# Calculate the what would have been the portfolio value yesterday
daimler_portfolio_gestern <- t(daimler_anzahl_heute %*% daimler$Schlusskurs)
daimler_portfolio_gestern[1,] <- 0
deutschebank_portfolio_gestern <- t(deutschebank_anzahl_heute %*% deutschebank$Schlusskurs)
deutschebank_portfolio_gestern[1,] <- 0
portfolio_gestern <- daimler_portfolio_gestern+deutschebank_portfolio_gestern

#portfolio_gestern <- sort(portfolio_gestern, decreasing = TRUE)


uebersicht <- data.frame(datum = daimler$Datum,
                         daimler_anzahl = daimler_anzahl$Anzahl,
                         deutschebank_anzahl = deutschebank_anzahl$Anzahl,
                         daimler_tagespreis = daimler$Schlusskurs,
                         deutschebank_tagespreis = deutschebank$Schlusskurs,
                         daimler_rendite = daimler_rendite,
                         deutschebank_rendite = deutschebank_rendite,
                         daimler_wert,
                         deutschebank_wert,
                         portfolio_r)


# Append the calculated VaR and Wert
#portfolio$Value_at_risk <- var_berechnen
#portfolio$Wert <- 

# Additional
#portfolio <- portfolio %>% arrange_all(desc)
portfolio$Datum <- as.Date(portfolio$Datum, "%Y-%m-%d")

# Write table in SQL
dbSendQuery(rms_dbs, "DELETE FROM fonds;")

dbSendQuery(rms_dbs, "DELETE FROM portfolio;")
dbWriteTable(rms_dbs, "portfolio", portfolio, append=TRUE, row.names=FALSE)

dbWriteTable(rms_dbs, "fonds", fonds, append=TRUE, row.names=FALSE)

dbDisconnect(rms_dbs)
