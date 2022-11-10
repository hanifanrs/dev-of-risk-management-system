# Set working directory (depends on where you save the file)
setwd()

# Import File
daimler<-read.csv(file="File/Daimler.csv",header=TRUE,sep=";",dec = ",")
daimler

# Check data type
str(daimler)

# Converted to correct Datatype
daimler$Stuecke <- as.numeric(gsub(".", "", daimler$Stuecke, fixed = TRUE))
daimler$Volumen <- as.numeric(gsub(".", "", daimler$Volumen, fixed = TRUE))
daimler$Datum <- as.Date(daimler$Datum, "%Y-%m-%d")

# Drop unused columns (Erster,Hoch,Tief,Stuecke,Volumen)
daimler <- daimler[-c(2:4,6:7)]

# Calculating logarithmic returns
n_mbg <- length(daimler$Schlusskurs)
logreturn_mbg <- log(daimler$Schlusskurs[-1]/daimler$Schlusskurs[-n_mbg])


# Convert the returns to Data Frame to better view
logreturndf_mbg <- data.frame(logreturn_mbg)
sortedlog_mbg <- data.frame(logreturndf_mbg[order(logreturn_mbg),]) %>% 
  rename(logreturns = 1)

# Calculate the portfolio (assume that we have 1000 shares in one portfolio)
lastprice_mbg <- head(daimler$Schlusskurs, n=1)
shares_mbg <- 1000
portfoliovalue_mbg <- lastprice_mbg*shares_mbg
minimum_mbg <- min(sortedlog_mbg)
maximum_mbg <- max(sortedlog_mbg)

# Plot the sorted return
library(tidyverse)
ggplot(sortedlog_mbg, aes(x = logreturns)) +
  geom_freqpoly() +
  labs(title = "Daily price changes")

# fifth percentile (Confidence Interval = 95%)
var95_mbg <- unname(quantile(sortedlog_mbg$logreturns, c(.05)))
worstcase_ninetyfive_mbg <- var95_mbg*portfoliovalue_mbg

# first percentile (Confidence Interval = 99%)
var99_mbg <- unname(quantile(sortedlog_mbg$logreturns, c(.01)))
worstcase_ninetynine_mbg <- var99_mbg*portfoliovalue_mbg

# Compare to package in CRAN
#install.packages("PerformanceAnalytics")
library(PerformanceAnalytics)
VaR(logreturn_mbg, p = 0.95, method = "historical")
VaR(logreturn_mbg, p = 0.99, method = "historical")

# Compare the Value at Risk
zusammenfassung <- data.frame(
  stock = c("Daimler", "Deutsche Bank"),
  portfolio_value = c(portfoliovalue_mbg, portfoliovalue_dbk),
  value_at_risk = c(var99_mbg,var99_dbk ),
  worst_case = c(worstcase_ninetynine_mbg,worstcase_ninetynine_dbk ))

