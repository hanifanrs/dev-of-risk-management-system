# Import Packages
library(dplyr)
library(DBI)
library(lubridate)
library(ggplot2)
library(zoo)

# Check data type
str(daimler)
str(deutschebank)

# Drop unused columns (Erster,Hoch,Tief,Stuecke,Volumen)
daimler <- daimler[-c(1:2,4:6,8:9)]
deutschebank <- deutschebank[-c(1:2,4:6,8:9)]

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

deutschebank_anzahl <- subset(anzahl, anzahl$Aktien_id == 2)
deutschebank_anzahl <- deutschebank_anzahl %>% arrange_all(desc)


# Calculate the Value of Portfolio
daimler_wert <- daimler$Schlusskurs * daimler_anzahl$Anzahl
deutschebank_wert <- deutschebank$Schlusskurs * deutschebank_anzahl$Anzahl
portfolio_r <- daimler_wert+deutschebank_wert

# Calculate the weight of portfolio
daimler_gewicht <- daimler_wert/portfolio_r
deutschebank_gewicht <- deutschebank_wert/portfolio_r

# Calculate the returns of portfolio
portfolio_rendite <- 
  (daimler_gewicht*daimler_rendite) +
  (deutschebank_gewicht*deutschebank_rendite)

uebersicht <- data.frame(datum = daimler$Datum,
                         daimler_anzahl = daimler_anzahl$Anzahl,
                         deutschebank_anzahl = deutschebank_anzahl$Anzahl,
                         daimler_tagespreis = daimler$Schlusskurs,
                         deutschebank_tagespreis = deutschebank$Schlusskurs,
                         daimler_rendite = daimler_rendite,
                         deutschebank_rendite = deutschebank_rendite,
                         daimler_wert,
                         deutschebank_wert,
                         portfolio_r,
                         portfolio_rendite)

# Find the third worst value each 250 days
thirdworst <- head(1--(rollapply(uebersicht$portfolio_rendite, width = 250,function(x) sort(x)[3])),250)

# Limit the data to according days
uebersicht <-head(uebersicht,250)

# Calculate the Value at Risk
valueatrisk <- uebersicht$portfolio_r*thirdworst
uebersicht$valueatrisk <- valueatrisk

# Calculate the Value at Risk percent
valueatrisk_prozent <- -((valueatrisk - uebersicht$portfolio_r)/valueatrisk)
uebersicht$valueatrisk_prozent <- valueatrisk_prozent

# Plotting the Value at Risk  
ggplot(uebersicht, aes(x = datum, y = portfolio_rendite)) + 
  theme_minimal()+
  geom_line(linewidth=0.8) + 
  geom_line(aes(y=valueatrisk_prozent, color = "Value at Risk"), linetype = "dashed")+
  ggtitle("Value At Risk") + 
  xlab("Datum") + 
  ylab("Prozentuale Veränderung")+  
  scale_color_manual(values = c("Value at Risk" = "red")) +
  scale_linetype_manual(values = c("Value at Risk" = "dashed"))

# Format to save in my SQL
uebersicht_dbs <- uebersicht[order(uebersicht$datum, decreasing = FALSE),]

# Append the calculated VaR and Wert
portfolio$Value_at_risk[263:nrow(portfolio)]<- uebersicht_dbs$valueatrisk
portfolio$Wert[263:nrow(portfolio)] <- uebersicht_dbs$portfolio_r

# Converted to correct Datatype
portfolio$Datum <- as.Date(portfolio$Datum, "%Y-%m-%d")

# Write table in SQL
dbSendQuery(rms_dbs, "DELETE FROM fonds;")

dbSendQuery(rms_dbs, "DELETE FROM portfolio;")
dbWriteTable(rms_dbs, "portfolio", portfolio, append=TRUE, row.names=FALSE)

dbWriteTable(rms_dbs, "fonds", fonds, append=TRUE, row.names=FALSE)

dbDisconnect(rms_dbs)
