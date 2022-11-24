#dbk = Deutsche Bank AG
#mbg = Mercedes-Benz Group AG
library(dplyr)

# Import File
daimler<-read.csv(file="File/Daimler.csv",header=TRUE,sep=";",dec = ",")
daimler

deutschebank <-read.csv(file="File/Deutsche Bank.csv",header=TRUE,sep=";",dec = ",")
deutschebank

# Check data type
str(daimler)
str(deutschebank)

# Converted to correct Datatype
daimler$Stuecke <- as.numeric(gsub(".", "", daimler$Stuecke, fixed = TRUE))
daimler$Volumen <- as.numeric(gsub(".", "", daimler$Volumen, fixed = TRUE))
daimler$Datum <- as.Date(daimler$Datum, "%Y-%m-%d")

deutschebank$Stuecke <- as.numeric(gsub(".", "", deutschebank$Stuecke, fixed = TRUE))
deutschebank$Volumen <- as.numeric(gsub(".", "", deutschebank$Volumen, fixed = TRUE))
deutschebank$Datum <- as.Date(deutschebank$Datum, "%Y-%m-%d")

# Drop unused columns (Erster,Hoch,Tief,Stuecke,Volumen)
daimler <- daimler[-c(2:4,6:7)]
deutschebank <- deutschebank[-c(2:4,6:7)]

# Sort dates
daimler <- daimler[order(daimler$Datum),]
deutschebank <- deutschebank[order(deutschebank$Datum),]

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

portfolio <- data.frame(
  datum = c(daimler$Datum[-1]),
  rendite_prozent_mbg = c(logreturn_mbg),
  rendite_prozent_dbk = c(logreturn_dbk),
  rendite_euro_mbg = c(returns_mbg),
  rendite_euro_dbk = c(returns_dbk),
  portfolio = c(portfoliovalue))
  
valueatrisk <- data.frame(
  var_99 = c(var99),
  var_95 = c(var95))
