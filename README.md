#library zum datei verbinden
library(DBI)
library(RMySQL)

setwd("C/Users/viany/Downloads")


#library zum datei verbinden
library(DBI)
library(RMySQL)

#R UND MYSQL verbinden
vconnection<-dbConnect(RMySQL::MySQL(),
                       dbname  ="vortrag",
                       host    ="127.0.0.1",
                       port    =3306,
                       user    ="root",
                       password="jesus2015")
print(vconnection)

#datei aus mysql lesen

mercedes=dbGetQuery(vconnection,"select* from vortrag.mercedes_benz_daimler")
deutsche=dbGetQuery(vconnection,"select* from vortrag.wkn_514000_historic")

# Check data type
str(mercedes)
str(deutsche)

# Converted to correct Datatype mercedes
mercedes$Datum <- as.Date(mercedes$Datum, "%Y-%m-%d")
mercedes$Schlusskurs <- as.numeric(gsub(",", ".", mercedes$Schlusskurs))

# Converted to correct Datatype dbank
deutsche$Schlusskurs <- as.numeric(gsub(",", ".", deutsche$Schlusskurs))
deutsche$Datum <- as.Date(deutsche$Datum, "%Y-%m-%d")


# Calculating logarithmic returns mercedes
n2 <- length(mercedes$Schlusskurs)
logreturn2 <- log(mercedes$Schlusskurs[-1]/mercedes$Schlusskurs[-n2])

print(logreturn2)

#Calculating logarithmic returns deutsche bank
n3 <- length(deutsche$Schlusskurs)
logreturn3 <- log(deutsche$Schlusskurs[-1]/deutsche$Schlusskurs[-n3])

# Convert the returns to Data Frame to better view mercedes
rendite_mer <- data.frame(logreturn2)
sortedlog_mer <- data.frame(rendite_mer[order(logreturn2),])

# Convert the returns to Data Frame to better view deutsche bank
rendite_db <- data.frame(logreturn3)
sortedlog_dbk <- data.frame(rendite_db[order(logreturn3),])

# GEwicht portfolio. 600.000€ = mbg , 400.000€ = dbk)
  
  total_kapital <- 1000000
  kapital_mer <- 600000
  kapital_dbk <- total_kapital-kapital_mer 
  
  # Calculate the € Returns
  rendite_merE <- logreturn2*kapital_mer
  rendite_dbkE <- logreturn3*kapital_dbk
  
  portfoliovalue_mer <- data.frame(rendite_merE)
  portfoliovalue_dbk <- data.frame(rendite_dbkE)
  
#calculate total value of portfolio
  portfoliovalue <- data.frame(rendite_merE+rendite_dbkE)
  print(portfoliovalue)
  
# Confidence Interval 
  var99 <-quantile(rendite_merE+rendite_dbkE, c(.01))
  var95 <-quantile(rendite_merE+rendite_dbkE, c(.05))
  
  library(base.rms)
  
# Confidence Interval 
  var99 <-quantile(rendite_merE+rendite_dbkE, c(.01))
  var95 <-quantile(rendite_merE+rendite_dbkE, c(.05))
  
  #portfolio
  portfolio <- data.frame(
    datum = c(mercedes$Datum[-1]),
    rendite_prozent_mer = c(sortedlog_mer),
    rendite_prozent_dbk = c(sortedlog_dbk),
    rendite_euro_mer = c(logreturn2),
    rendite_euro_dbk = c(logreturn3),
    portfolio = c(portfoliovalue))  

  valueatrisk <- data.frame(
    var_99 = c(var99),
    var_95 = c(var95))
  
  
  plot(valueatrisk)
  
