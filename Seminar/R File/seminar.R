mercedes_1<-Ad getSymbols("mercesdes_1",auto.assign = F))
seminar.Rend<-na.omit(ROC(mercedes_1, type="discrete"))

VaR(mercedes.Rend, p=0,95, method="historical")
VaR(mercesdes.Rend, p=0.99, method="historical")

deutsche_bank1<-Ad(getSymbols("deutsche_bank1",auto.assign = F))
deutsche_bank1.Rend<-na.omit(ROC(mercedes_1, type="discrete"))

VaR(deutsche_bank_1.Rend, p=0,95, method="historical")
VaR(deutsche_bank1.Rend, p=0.99, method="historical")

Aktien<-c("mercedes_1","deutsche_bank_1" );

db=dbGetQuery(mysqlconnection,"select Schlusskurs from deutsche_bank")
select
VAR(db)