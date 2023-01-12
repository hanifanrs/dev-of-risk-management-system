CREATE DATABASE IF NOT EXISTS RMS_DBS;
USE RMS_DBS;

# Es werden eventuell noch existierende Tabellen geloescht
DROP TABLE IF EXISTS Fonds;
DROP TABLE IF EXISTS Portfolio;
DROP TABLE IF EXISTS Snapshot;
DROP TABLE IF EXISTS Tagespreis;
DROP TABLE IF EXISTS Aktien;

# Anlegen der Tabellen:
SET @@GLOBAL.local_infile = 1;

CREATE TABLE Aktien (
    Aktien_id 				INT NOT NULL AUTO_INCREMENT,
    Name 					VARCHAR(60),
    ISIN 					VARCHAR(12) NOT NULL UNIQUE,
    WKN						VARCHAR(6) NOT NULL UNIQUE,
    Branche					VARCHAR(30),
    Land					VARCHAR(60),					
    PRIMARY KEY (Aktien_id)
);

CREATE TABLE Tagespreis (
	Tagespreis_id			INT AUTO_INCREMENT,
    Aktien_id 				INT NOT NULL,
    Datum 					DATE,
    Erster 					DECIMAL(10,2),
    Hoch 					DECIMAL(10,2),
    Tief 					DECIMAL(10,2),
    Schlusskurs 			DECIMAL(10,2),
    Stuecke 				INT,
    Volumen 				BIGINT,
    PRIMARY KEY (Tagespreis_id),
	Constraint FK_Aktien_id FOREIGN KEY (Aktien_id) REFERENCES Aktien(Aktien_id)
								ON DELETE NO ACTION ON UPDATE NO ACTION,
	Constraint Tagespreis_unique UNIQUE (Aktien_id, Datum)
);

CREATE TABLE Snapshot (
    Snapshot_id 			INT NOT NULL,
    Anzahl 					INT NOT NULL,
    Aktien_id 				INT NOT NULL,
    PRIMARY KEY (Snapshot_id, Aktien_id),
	Constraint FK_Aktien_id2 FOREIGN KEY (Aktien_id) REFERENCES Aktien(Aktien_id)
								ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE Portfolio (
    Portfolio_id 			INT NOT NULL,
    Datum 					DATE NOT NULL,
    Snapshot_id 			INT NOT NULL,
    Value_at_risk 			DECIMAL(10,2),
    Wert 					DECIMAL(10,2),
    PRIMARY KEY (Portfolio_id, Snapshot_id),
	Constraint FK_Snapshot_id FOREIGN KEY (Snapshot_id) REFERENCES Snapshot(Snapshot_id)
								ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE Fonds (
    Fonds_id 				INT NOT NULL AUTO_INCREMENT,
    Name 					VARCHAR(60),
    ISIN 					VARCHAR(12) NOT NULL UNIQUE,
    Portfolio_id 			INT NOT NULL,
    PRIMARY KEY (Fonds_id),
    Constraint FK_Portfolio_id FOREIGN KEY (Portfolio_id) REFERENCES Portfolio(Portfolio_id)
								ON DELETE NO ACTION ON UPDATE NO ACTION
);

# Jetzt werden die Tabellen mit Inhalt versorgt

INSERT INTO Aktien (Name, ISIN, WKN, Branche, Land)
VALUES 
('Mercedes-Benz Group', 'DE0007100000', '710000', 'Automobilhersteller', 'Deutschland'),
('Deutsche Bank', 'DE0005140008', '514000', 'Universalbanken', 'Deutschland');

# Daten aus dem Ergebnis von csv_manipulation.py laden

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Tagespreis_1.csv'
INTO TABLE Tagespreis
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(Aktien_id,Datum,Erster,Hoch,Tief,Schlusskurs,Stuecke,Volumen)
SET Tagespreis_id = NULL;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Tagespreis_2.csv'
INTO TABLE Tagespreis
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(Aktien_id,Datum,Erster,Hoch,Tief,Schlusskurs,Stuecke,Volumen)
SET Tagespreis_id = NULL;
