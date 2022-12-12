CREATE DATABASE IF NOT EXISTS RMS_DBS;
USE RMS_DBS;

# Es werden eventuell noch existierende Tabellen geloescht
DROP TABLE IF EXISTS Fonds;
DROP TABLE IF EXISTS Portfolio;
DROP TABLE IF EXISTS Snapshot;
DROP TABLE IF EXISTS Tagespreis;
DROP TABLE IF EXISTS Aktien;

# Anlegen der Tabellen:

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
    Tagespreis_id 			INT NOT NULL AUTO_INCREMENT,
    Aktien_id 				INT NOT NULL,
    Datum 					DATE NOT NULL,
    Erster 					DECIMAL(10,2) NOT NULL,
    Hoch 					DECIMAL(10,2) NOT NULL,
    Tief 					DECIMAL(10,2) NOT NULL,
    Schlusskurs 			DECIMAL(10,2) NOT NULL,
    Stuecke 				INT NOT NULL,
    Volumen 				INT NOT NULL,
    PRIMARY KEY (Tagespreis_id),
	Constraint FK_Aktien_id FOREIGN KEY (Aktien_id) REFERENCES Aktien(Aktien_id)
								ON DELETE NO ACTION ON UPDATE NO ACTION
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