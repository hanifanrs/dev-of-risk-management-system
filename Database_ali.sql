use merc;

drop table if exists portfolio;
drop table if exists fonds;
drop table if exists snapshot;
drop table if exists aktien;
drop table if exists tagespreis;


drop view if exists ausgabe;

create table Fonds (
ID  Integer  Primary Key,
ISIN  Char(30)  Not null,
Name  Char(30)  Not null,
Währung  Char(30)  Not null
); 

create table Portfolio (
ID  Integer,
Anzahl_Aktien  Integer  Not null,
Datum   date  not null,
Wert_Portfolio  Integer  Not Null,

Constraint FK_Portfolio_Fonds FOREIGN KEY (ID) REFERENCES Fonds(ID)		
						ON DELETE CASCADE ON UPDATE CASCADE
);

create table snapshot(
anzahl   integer   not null, 
aktien   Char(30)  not  null
);

create table aktien(
name char(30),
ISIN Char(30),
Branche Char(30),
Land Char(30)
);

create table Tagespreis(
Aktien_ID Integer Primary Key,
Datum date,
Erster Integer,
Hoch Integer,
Tief Integer,
Schlusskurs Integer,
Stuecke Integer,
Volumen Integer
); 

insert into fonds
Values (123, 'allianz', 'DE12345678910', 'EUR');
insert into fonds
Values (456, 'DWS', 'DE6592356017', 'EUR');
insert into fonds
Values (789, 'unifonds', 'DE0987654321', 'EUR');

insert into portfolio
Values (123,5,'2022-11-22',10);
insert into portfolio 
Values (456,7,'2022-11-23',8);
insert into portfolio 
Values (789,15,'2022-11-24',6);
 

CREATE VIEW Ausgabe
AS SELECT anzahl_aktien as 'Aktienmenge', wert_portfolio as 'Portfoliowert'  from portfolio;






 
