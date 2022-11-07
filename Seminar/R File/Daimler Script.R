# Set working directory
setwd()

# Import File
daimler<-read.csv(file="File/Daimler.csv",header=TRUE,sep=";",dec = ",")
daimler

str(daimler)

# Converted to correct Datatype
daimler$Stuecke <- as.numeric(gsub(".", "", daimler$Stuecke, fixed = TRUE))
daimler$Volumen <- as.numeric(gsub(".", "", daimler$Volumen, fixed = TRUE))
daimler$Datum <- as.Date(daimler$Datum, "%Y-%m-%d")


# Calculating logarithmic returns
n <- length(daimler$Schlusskurs)
logreturn <- log(daimler$Schlusskurs[-1]/daimler$Schlusskurs[-n])

# Convert to Data Frame
logereturn.df <- data.frame(logreturn)

sortedlog <- data.frame(logereturn.df[order(logreturn),])
