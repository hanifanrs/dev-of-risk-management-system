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

# Number of today's shares
daimler_anzahl_heute <- dbGetQuery(rms_dbs,"SELECT s.Anzahl FROM Portfolio p
INNER JOIN Snapshot s ON s.Snapshot_id = p.Snapshot_id
INNER JOIN Tagespreis t ON t.Aktien_id = s.Aktien_id AND t.Datum = p.Datum
WHERE t.Datum = '2022-12-30' AND p.Snapshot_id = 257 AND t.Aktien_id = 1;")
daimler_anzahl_heute <- as.matrix(daimler_anzahl_heute)

deutschebank_anzahl_heute <- dbGetQuery(rms_dbs,"SELECT s.Anzahl FROM Portfolio p
INNER JOIN Snapshot s ON s.Snapshot_id = p.Snapshot_id
INNER JOIN Tagespreis t ON t.Aktien_id = s.Aktien_id AND t.Datum = p.Datum
WHERE t.Datum = '2022-12-30' AND p.Snapshot_id = 257 AND t.Aktien_id = 2;")
deutschebank_anzahl_heute <- as.matrix(deutschebank_anzahl_heute)

# Calculate the Value at Risk
daimler_var <- t(daimler_anzahl_heute %*% daimler$Schlusskurs)
daimler_var[1,] <- 0
deutschebank_var <- t(deutschebank_anzahl_heute %*% deutschebank$Schlusskurs)
deutschebank_var[1,] <- 0
var_berechnen <- daimler_var+deutschebank_var
var_berechnen <- sort(var_berechnen, decreasing = TRUE)

# Calculate the Value of Portfolio
wert_berechnen <- dbGetQuery(rms_dbs, 
"SELECT SUM(s.Anzahl * t.Schlusskurs) AS Wert
FROM Portfolio p
INNER JOIN Snapshot s ON s.Snapshot_id = p.Snapshot_id
INNER JOIN Tagespreis t ON t.Aktien_id = s.Aktien_id AND t.Datum = p.Datum
GROUP BY s.Snapshot_id;")
wert_berechnen <- as.numeric(wert_berechnen$Wert)

# Append the calculated VaR and Wert
portfolio$Value_at_risk <- var_berechnen
portfolio$Wert <- wert_berechnen

# Additional
#portfolio <- portfolio %>% arrange_all(desc)
portfolio$Datum <- as.Date(portfolio$Datum, "%Y-%m-%d")

# Write table in SQL
dbSendQuery(rms_dbs, "DELETE FROM fonds;")

dbSendQuery(rms_dbs, "DELETE FROM portfolio;")
dbWriteTable(rms_dbs, "portfolio", portfolio, append=TRUE, row.names=FALSE)

dbWriteTable(rms_dbs, "fonds", fonds, append=TRUE, row.names=FALSE)

dbDisconnect(rms_dbs)
