use merc;

drop table if exists fonds;
drop table if exists portfolio;


create table Fonds (
ID  Integer  Primary Key,
Name  Char(30)  Not null,
ISIN  Char(30)  Not null,
Währung  Integer  Not null
); 

create table Portfolio (
ID  Integer  Primary Key,
Anzahl_Aktien  Integer  Not null,
Datum   date  not null,
Wert_Portfolio  Integer  Not Null
);
 
