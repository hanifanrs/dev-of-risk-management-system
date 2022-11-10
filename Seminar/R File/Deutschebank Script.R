# Set working directory (depends on where you save the file)
setwd()

# Import File
deutschebank <-read.csv(file="File/Deutsche Bank.csv",header=TRUE,sep=";",dec = ",")
deutschebank

# Check data type
str(deutschebank)

# Converted to correct Datatype
deutschebank$Stuecke <- as.numeric(gsub(".", "", deutschebank$Stuecke, fixed = TRUE))
deutschebank$Volumen <- as.numeric(gsub(".", "", deutschebank$Volumen, fixed = TRUE))
deutschebank$Datum <- as.Date(deutschebank$Datum, "%Y-%m-%d")

# Calculating logarithmic returns
n_dbk <- length(deutschebank$Schlusskurs)
logreturn_dbk <- log(deutschebank$Schlusskurs[-1]/deutschebank$Schlusskurs[-n_dbk])


# Convert the returns to Data Frame to better view
logreturndf_dbk <- data.frame(logreturn_dbk)
sortedlog_dbk <- data.frame(logreturndf_dbk[order(logreturn_dbk),]) %>% 
  rename(logreturns = 1)

# Calculate the portfolio (assume that we have 1000 shares in one portfolio)
lastprice_dbk <- head(deutschebank$Schlusskurs, n=1)
shares_dbk <- 1000
portfoliovalue_dbk <- lastprice_dbk*shares_dbk
minimum_dbk <- min(sortedlog_dbk)
maximum_dbk <- max(sortedlog_dbk)

# Plot the sorted return
library(tidyverse)
ggplot(sortedlog_dbk, aes(x = logreturns)) +
  geom_freqpoly() +
  labs(title = "Daily price changes")

# fifth percentile (Confidence Interval = 95%)
var95_dbk <- unname(quantile(sortedlog_dbk$logreturns, c(.05)))
worstcase_ninetyfive_dbk <- var95_dbk*portfoliovalue_dbk

# first percentile (Confidence Interval = 99%)
var99_dbk <- unname(quantile(sortedlog_dbk$logreturns, c(.01)))
worstcase_ninetynine_dbk <- var99_dbk*portfoliovalue_dbk

# Compare to package in CRAN
#install.packages("PerformanceAnalytics")
library(PerformanceAnalytics)
VaR(logreturn_dbk, p = 0.95, method = "historical")
VaR(logreturn_dbk, p = 0.99, method = "historical")
