use merc;


DROP TABLE IF EXISTS Fonds;
DROP TABLE IF EXISTS Portfolio;
DROP TABLE IF EXISTS Snapshot;
DROP TABLE IF EXISTS Tagespreis;
DROP TABLE IF EXISTS Aktien;
DROP TABLE IF EXISTS Valueatrisk;

SET sql_safe_updates=0;
Update mercedes set Schlusskurs = replace(Schlusskurs, ".", ",");
Update deutschebank set Schlusskurs = replace(Schlusskurs, ".", ",");

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
    PRIMARY KEY (Snapshot_id),
	Constraint FK_Aktien_id2 FOREIGN KEY (Aktien_id) REFERENCES Aktien(Aktien_id)
								ON DELETE NO ACTION ON UPDATE NO ACTION
);
CREATE TABLE Portfolio (
    Portfolio_id 			INT NOT NULL,
    Datum 					DATE NOT NULL,
    Snapshot_id 			INT NOT NULL,
    Value_at_risk 			DECIMAL(10,2),
    Wert 					DECIMAL(10,2),
    PRIMARY KEY (Portfolio_id),
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

CREATE TABLE ValueAtRisk (
Wert INT 
);

INSERT INTO Aktien (Name, ISIN, WKN, Branche, Land)
VALUES 
('Mercedes-Benz Group', 'DE0007100000', '710000', 'Automobilhersteller', 'Deutschland'),
('Deutsche Bank', 'DE0005140008', '514000', 'Universalbanken', 'Deutschland');

INSERT INTO Tagespreis (Aktien_id,Datum, Erster, Hoch, Tief, Schlusskurs, Stuecke, Volumen)
VALUES
('1',Date '2022-12-16', '8.8', '9.1', '9.01', '9.12', '10120345', '98976078'),
('2',Date '2022-12-20', '9.1', '9.3', '8.79', '8.98', '1009789', '92441896');

INSERT INTO Snapshot (Snapshot_id, Anzahl, Aktien_id)
VALUES
('123', '10','1'),
('456','5', '2');

INSERT INTO Portfolio (Portfolio_id, Datum, Snapshot_id, Value_at_risk, Wert)
VALUES
('1', Date '2022-12-16', '123', '748', '4546'),
('2', Date '2022-12-20', '456', '946', '6234');

INSERT INTO Fonds (Name, ISIN, Portfolio_id)
VALUES
('Uniglobal', 'DE000DB7HWY7', '1' ),
('Hausinvest', 'DE000DZ21632', '2');






 
