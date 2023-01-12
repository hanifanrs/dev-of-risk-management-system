# Import Packages
library(RMySQL)
library(rstudioapi)

# Connect to the MySQL database rms_dbs
rms_dbs <- dbConnect(RMySQL::MySQL(), 
                     dbname = "rms_dbs", 
                     host = "localhost", 
                     port = 3306,
                     user = rstudioapi::askForPassword("Database user"),
                     password = rstudioapi::askForPassword("Database password"))
                     
# Get table names
tables <- dbListTables

# Display structure of tables
str(tables)

# Import the all table from rms_dbs
aktien <- dbReadTable(rms_dbs, "aktien")
tagespreis <- dbReadTable(rms_dbs, "tagespreis")
snapshot <- dbReadTable(rms_dbs, "snapshot")
portfolio <- dbReadTable(rms_dbs, "portfolio")
fonds <- dbReadTable(rms_dbs, "fonds") 

# Converted to correct Datatype
tagespreis$Datum <- as.Date(tagespreis$Datum, "%Y-%m-%d")

# Import Data from Queries 
daimler <- dbGetQuery(rms_dbs, "SELECT * FROM rms_dbs.tagespreis WHERE Aktien_id 
                      = '1' AND Datum BETWEEN '2016-01-01' AND '2022-12-31';")
daimler

deutschebank <- dbGetQuery(rms_dbs, "SELECT * FROM rms_dbs.tagespreis WHERE Aktien_id 
                      = '2' AND Datum BETWEEN '2016-01-01' AND '2022-12-31';")
deutschebank
