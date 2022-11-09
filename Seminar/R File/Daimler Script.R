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
n <- length(daimler$Schlusskurs)
logreturn <- log(daimler$Schlusskurs[-1]/daimler$Schlusskurs[-n])


# Convert the returns to Data Frame to better view
logreturn.df <- data.frame(logreturn)
sortedlog <- data.frame(logreturn.df[order(logreturn),]) %>% 
  rename(logreturns = 1)

# Calculate the portfolio (assume that we have 1000 shares in one portfolio)
lastprice <- head(daimler$Schlusskurs, n=1)
shares <- 1000
portfoliovalue <- lastprice*shares
minimum <- min(sortedlog)
maximum <- max(sortedlog)

# Plot the sorted return
library(tidyverse)
ggplot(sortedlog, aes(x = logreturns)) +
  geom_freqpoly() +
  labs(title = "Daily price changes")

# fifth percentile (Confidence Interval = 95%)
var95 <- unname(quantile(sortedlog$logreturns, c(.05)))
worstcase_ninetyfive <- var95*portfoliovalue

# first percentile (Confidence Interval = 99%)
var99 <- unname(quantile(sortedlog$logreturns, c(.01)))
worstcase_ninetynine <- var99*portfoliovalue

# Compare to package in CRAN
install.packages("PerformanceAnalytics")
library(PerformanceAnalytics)
VaR(logreturn, p = 0.95, method = "historical")
VaR(logreturn, p = 0.99, method = "historical")
