# dev-of-risk-management-system
Seminar Development of a Risk Management System
# Set working directory (depends on where you save the file)

setwd("C/Users/viany/Downloads")

# Import File
#deutsche bank
deutsche<-read.csv(file="deutsche bank.csv",sep=";",dec=",")
plot(deutsche$Schlusskurs,type="l")

#mercedes
mercedes<-read.csv(file="mercedes.csv",sep=";",dec=",")
mercedes$Schlusskurs
plot(mercedes$Schlusskurs,type="l")

# Check data type
str(mercedes)
str(deutsche)

# Converted to correct Datatype mercedes
mercedes$Stuecke <- as.numeric(gsub(".", "", mercedes$Stuecke, fixed = TRUE))
mercedes$Volumen <- as.numeric(gsub(".", "", mercedes$Volumen, fixed = TRUE))
mercedes$Datum <- as.Date(mercedes$Datum, "%Y-%m-%d")

# Converted to correct Datatype dbank
deutsche$Stuecke <- as.numeric(gsub(".", "", deutsche$Stuecke, fixed = TRUE))
deutsche$Datum <- as.Date(deutsche$Datum, "%Y-%m-%d")
deutsche$Volumen <- as.numeric(gsub(".", "", deutsche$Volumen, fixed = TRUE))

# Drop unused columns (Erster,Hoch,Tief,Stuecke,Volumen)
mercedes1 <- mercedes[-c(2:4,6:7)]

# Drop unused columns (Erster,Hoch,Tief,Stuecke,Volumen)
deutsche1<- deutsche[-c(2:4,6:7)]


# Calculating logarithmic returns mercedes
n2 <- length(mercedes$Schlusskurs)
logreturn2 <- log(mercedes$Schlusskurs[-1]/mercedes$Schlusskurs[-n2])


#Calculating logarithmic returns deutsche bank
n3 <- length(deutsche$Schlusskurs)
logreturn3 <- log(deutsche$Schlusskurs[-1]/deutsche$Schlusskurs[-n3])

# Convert the returns to Data Frame to better view mercedes
logreturndf_mer <- data.frame(logreturn2)
sortedlog_mer <- data.frame(logreturndf_mer[order(logreturn2),])
  rename(rendite_mer = 1)

# Convert the returns to Data Frame to better view deutsche bank
logreturndf_dbk <- data.frame(logreturn3)
sortedlog_dbk <- data.frame(logreturndf_dbk[order(logreturn3),])
  rename(rendite_dbk = 1)


# Calculate the weight of portfolio (assume that we have 1.000.000€ capital 
# in one portfolio. 600.000€ = mbg , 400.000€ = dbk)
  
  total_kapital <- 1000000
  kapital_mer <- 600000
  kapital_dbk <- total_kapital-kapital_mer 
  
  # Calculate the € Returns
  returns_mer <- logreturn2*kapital_mer
  returns_dbk <- logreturn3*kapital_dbk
  
  portfoliovalue_mer <- data.frame(returns_mer)
  portfoliovalue_dbk <- data.frame(returns_dbk)
  
#calculate total value of portfolio
  portfoliovalue <- data.frame(returns_mer+returns_dbk)
  print(portfoliovalue)
    rename(portfoliovalues = 1)
  
# first percentile (Confidence Interval = 99%)
  var99 <- unname(quantile(portfoliovalue, c(.01)))
  var95 <- unname(quantile(portfoliovalue$portfoliovalues, c(.05)))
  
  
  index_l <- sample(1:nrow(portfoliovalue), 250)
  print(index_l)#price historical
  
  mercedes_ls <- mercedes[index_l, ]
  
  CI(mercedes_ls$portfoliovalue, ci=0.95)
  CI(mydata$Sepal.Length, ci=0.95)
  
  library(base.rms)
  
  ## Query mercedes price history(Aktien)
  head(mercedes_ls$schlusskurs)
  
  
# fifth percentile (Confidence Interval = 95%)
  var95 <- unname(quantile(portfoliovalue$portfoliovalues, c(.05)))
  
  portfolio <- data.frame(
    datum = c(mercedes1$Datum[-1]),
    rendite_prozent_mer = c(sortedlog_mer),
    rendite_prozent_dbk = c(sortedlog_dbk),
    rendite_euro_mer = c(logreturn2),
    rendite_euro_dbk = c(logreturn3),
    portfolio = c(portfoliovalue))  

  sortedlog_mer <- data.frame(logreturndf_mer[order(logreturn2),])
    rename(rendite_mer = 1)
    
    logreturndf_mer <- data.frame(logreturn2)
    sortedlog_mer <- data.frame(logreturndf_mer[order(logreturn2),])
    
  
  logreturndf_dbk <- data.frame(logreturn3)
  sortedlog_dbk <- data.frame(logreturndf_dbk[order(logreturn3),]) %>% 
    rename(rendite_dbk = 1)
  
