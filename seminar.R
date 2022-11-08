#Datei einlesen

library(readxl)
read.csv
mercedes$Schlusskurs

mercedes<-read.csv(file="mercedes.csv",sep=";",dec=",")
mercedes$Schlusskurs

#Datei type einlesen

str(mercedes)



#Converted to correct Datatype

library(data.frame)
is.dataframe(mercedes$schlusskurs)
mercedes$Stuecke <- as.numeric(gsub(".", "", mercedes$Stuecke, fixed = TRUE))
mercedes$Volumen <- as.numeric(gsub(".", "", mercedes$Volumen, fixed = TRUE))
mercedes$Datum <- as.Date(mercedes$Datum, "%Y-%m-%d")

mercedes$Schlusskurs <- as.numeric(gsub(".", "", mercedes$Schlusskurs, fixed = TRUE))

print(mercedes$schlusskurs)



#library zum datei verbinden

library(odbc)
library(DBI)
library(RODBC)
library(RMySQL)

#R UND MYSQL verbinden
mysqlconnection<- dbConnect(RMySQL::MySQL(),
                            dbname  ="dbank",
                            host    ='127.0.0.1',
                            port    =3306,
                            user    ='root',
                            password='jesus2015')

vconnection<-dbConnect(RMySQL::MySQL(),
                       dbname  ="vortrag",
                       host    ="127.0.0.1",
                       port    =3306,
                       user    ="root",
                       password="jesus2015")
print(vconnection)

#datei aus mysql lesen

dm=dbGetQuery(vconnection,"select Schlusskurs from vortrag.mercedes_benz_daimler")

db=dbGetQuery(vconnection, "SELECT schlusskurs from vortrag.wkn_514000_historic")

print(dm)

#datei einordnen
library(data.table)
mercedes$schlusskurs
df <- df[order(df$mercedes.Schlusskurs),]
df <- df[order(df$mercedes.Schlusskurs),]
print(df)


#confidence intervall berechenen

library(quantmod)
library(performanceAnalytics)


library(dplyr)
library(jsonlite)
library(zoo)

install.packages("Rmisc")
library(Rmisc)

CI(mercedes$Schlusskurs, ci=0.95)


CI(mercedes$Schlusskurs, ci=0.99)

#confidence intervall in einer Zeitreihe von 15 ZUFFÄLIGEN 15 Tagen

index_s <- sample(1:nrow(mercedes), 15)
print(index_s)

#rendite mit ln  berechnen

n <- length(mercedes$Schlusskurs)
logreturn <- log(mercedes$Schlusskurs[-1]/mercedes$Schlusskurs[-n])

logreturn <- log(mercedes$Schlusskurs[-1]/mercedes$Schlusskurs[-n])

logereturn.df <- data.frame(logreturn)
print(logereturn.df)


#subset von tagen data

mercedes_ss <- mercedes[index_s, ]
CI(mercedes_ss$Schlusskurs, ci=0.95)

#confidence intervall in einer Zeitreihe von ZUFFÄLIGEN 250 Tagen


index_l <- sample(1:nrow(mercedes), 250)
print(index_l)#price historical

mercedes_ls <- mercedes[index_l, ]

CI(mercedes_ls$Schlusskurs, ci=0.95)

library(base.rms)

## Query mercedes price history(Aktien)
head(mercedes_ls$schlusskurs)


## ORDER NEW mercedes close prices

mercedes2 <- base::data.frame(Date = zoo::index(mercedes_ls), zoo::coredata(mercedes_ls)) # Convert to a data frame because dplyr::mutate() cannot be applies to an 'xts' object and keep index as date column
mercedes3<- base::data.frame(Schlusskurs3= zoo::index(mercedes_ls), zoo::coredata(mercedes_ls)) # Convert to a data frame because dplyr::mutate() cannot be applies to an 'xts' object and keep index as date column
dplyr::arrange(dplyr::desc(mercedes3))# Sort dates by descending order to ensure we calculate percent change correctly
  

library(quantilteGradeR)

#quantile brechnen
x=logereturn.df1

quantile(x, probs = seq(0, 1, 0.25), na.rm = FALSE)
quote <- quantmod::getQuote("x")$Last
print(quote)

## Apply current quote to historical percent changes

n1 <- length(mercedes_ls$Schlusskurs)


#warum hat mein n1 250 werte aber logreteurndf1 257
logreturn1 <- log(mercedes_ls$Schlusskurs[-1]/mercedes$Schlusskurs[-n1])

logereturn1 <- data.frame(logreturn1)


print(mercedes_ls$Schlusskurs)
 # Times 10 because we own 10 shares in our portfolio
## Apply current quote to historical percent changes
mercedes_ls$VaR <-mercedes_ls$logereturn1 * quote * 10 # Times 10 because we











## Get current mercedes quote
quote <- quantmod::getQuote("mercedes_ls")$Last
quote<- quantile(logereturn.df)
quantile(lo, probs = seq(0, 1, 0.25), na.rm = FALSE)

#preis aktien mercedes
mercedes <- quantmod::getSymbols("mercedes", from = base::as.Date("2021-12-09"), to = base::as.Date("2022-01-25"), auto.assign = F)


#rendite mit ln  berechnen

n <- length(mercedes$Schlusskurs)
logreturn <- log(mercedes$Schlusskurs[-1]/mercedes$Schlusskurs[-n])

logreturn <- log(mercedes$Schlusskurs[-1]/mercedes$Schlusskurs[-n])

logereturn.df <- data.frame(logreturn)
print(logereturn.df)



## Get current mercedes quote
quote <- quantmod::getQuote("mercedes")$Last


## Apply current quote to historical percent changes
mercedes$VaR <- mercedes$Pct_change * quote * 10 # Times 10 because we own 10 shares in our portfolio






















#datei anordnen
library(data.table)
mercedes$schlusskurs
order(mercedes$schlusskurs)


#in data.table konvertieren

dt <- as.data.table(schlusskurs)
df <- df[order(df$mercedes.Schlusskurs),]
print(df)
mercedes$schlusskurs


##spaltennamen
mercedes$Sepal.Length





df <- data.frame(mercedes$Schlusskurs)
df= select(schlusskurs)

dt.sub <- mercedes[,list(mercedes$schlusskurs)]
# Bisherigen Data Frame sortieren
order(df$mercedes)
# Neuen Data Frame erstellen und diesen sortieren
df2 <- df[order(df$mercedes$schlusskurs),]
decreasing = FALSE
partial = NULL   # Vector indices for partial sorting
na.last = TRUE
method = c("auto", "shell", "quick", "radix")


sort.list(mercedes$schlusskurs , # Atomic vector
          decreasing = FALSE,
          partial = NULL,    # Vector indices for partial sorting
          na.last = TRUE,
          method = c("auto", "shell", "quick", "radix"))


read.csv
mercedes$Schlusskurs

mercedes<-read.csv(file="mercedes.csv",sep=";",dec=",")
mercedes$Schlusskurs

str(mercedes)
# Converted to correct Datatype
mercedes$Stuecke <- as.numeric(gsub(".", "", mercedes$Stuecke, fixed = TRUE))
mercedes$Volumen <- as.numeric(gsub(".", "", mercedes$Volumen, fixed = TRUE))
mercedes$Datum <- as.Date(mercedes$Datum, "%Y-%m-%d")
log

plot(mercedes$Schlusskurs)
plot(mercedes$Schlusskurs,type="l")

library(readxl)

dbGetQuery(mysqlconnection,"select * from mercedes")


mysqlconnection<- dbConnect(RMySQL::MySQL(),
                            dbname  ="dbank",
                            host    ='127.0.0.1',
                            port    =3306,
                            user    ='root',
                            password='jesus2015')

vconnection<-dbConnect(RMySQL::MySQL(),
                            dbname  ="vortrag",
                            host    ="127.0.0.1",
                            port    =3306,
                            user    ="root",
                            password="jesus2015")

#Datei aus r leseb

=dbGetQuery(vconnection,"select Schlusskurs from mercedes_benz_daimler")
VaR(mercedes.Rend, p=0,95, method="historical")

library(quantmod)
library(performanceAnalytics)

mercedes<-Ad(getSymbols("mercesdes",auto.assign = F))

library(dplyr)
library(jsonlite)
library(quantmod)
library(zoo)

## Query mercedes price history
mercedes_benz_daimler <- quantmod::getSymbols("mercedes_benz_daimler", from = base::as.Date("2021-11-4"), to = base::as.Date("2022-11-4"), auto.assign = F)

## Calculate percent change on mercedes close prices
 mercedes_benz_daimler <- base::data.frame(Date = zoo::index(mercedez), zoo::coredata(tsla)) %>% # Convert to a data frame because dplyr::mutate() cannot be applies to an 'xts' object and keep index as date column
  dplyr::arrange(dplyr::desc(Date)) %>% # Sort dates by descending order to ensure we calculate percent change correctly
  dplyr::mutate(Pct_change = (mercedes.Close / dplyr::lead(mercedes.Close)) - 1) # Calculate percent change

## Get current mercedes quote
quote <- quantmod::getQuote("mercedes")$Last


## Apply current quote to historical percent changes
mercedes$VaR <- mercedes$Pct_change * quote * 10 # Times 10 because we own 10 shares in our portfolio

