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
    Stuecke 				BIGINT,
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

INSERT INTO Snapshot (Snapshot_id, Anzahl, Aktien_id)
VALUES 
(1, 20, 1), (1, 13, 2), (2, 27, 1), (2, 15, 2), (3, 22, 1), (3, 12, 2), (4, 17, 1), (4, 25, 2), (5, 19, 1), (5, 10, 2), (6, 14, 1), (6, 28, 2), (7, 30, 1), (7, 20, 2), (8, 29, 1), (8, 16, 2), (9, 24, 1), (9, 11, 2), 
(10, 18, 1), (10, 26, 2), (11, 15, 1), (11, 23, 2), (12, 21, 1), (12, 9, 2), (13, 28, 1), (13, 17, 2), (14, 12, 1), (14, 30, 2), (15, 19, 1), (15, 8, 2), (16, 25, 1), (16, 14, 2), (17, 27, 1), (17, 13, 2), (18, 22, 1), 
(18, 10, 2), (19, 16, 1), (19, 24, 2), (20, 11, 1), (20, 29, 2), (21, 18, 1), (21, 26, 2), (22, 23, 1), (22, 9, 2), (23, 21, 1), (23, 7, 2), (24, 15, 1), (24, 28, 2), (25, 10, 1), (25, 30, 2), (26, 20, 1), (26, 16, 2), 
(27, 14, 1), (27, 27, 2), (28, 12, 1), (28, 24, 2), (29, 11, 1), (29, 29, 2), (30, 17, 1), (30, 25, 2), (31, 19, 1), (31, 8, 2), (32, 26, 1), (32, 15, 2), (33, 22, 1), (33, 13, 2), (34, 28, 1), (34, 21, 2), (35, 9, 1), 
(35, 30, 2), (36, 18, 1), (36, 27, 2), (37, 16, 1), (37, 23, 2), (38, 14, 1), (38, 24, 2), (39, 10, 1), (39, 28, 2), (40, 25, 1), (40, 11, 2), (41, 20, 1), (41, 29, 2), (42, 17, 1), (42, 26, 2), (43, 13, 1), (43, 22, 2), 
(44, 12, 1), (44, 30, 2), (45, 19, 1), (45, 7, 2), (46, 24, 1), (46, 16, 2), (47, 27, 1), (47, 14, 2), (48, 9, 1), (48, 29, 2), (49, 15, 1), (49, 25, 2), (50, 11, 1), (50, 20, 2), (51, 24, 1), (51, 18, 2), (52, 20, 1), 
(52, 25, 2), (53, 17, 1), (53, 28, 2), (54, 27, 1), (54, 22, 2), (55, 29, 1), (55, 19, 2), (56, 24, 1), (56, 18, 2), (57, 20, 1), (57, 25, 2), (58, 17, 1), (58, 28, 2), (59, 27, 1), (59, 22, 2), (60, 29, 1), (60, 19, 2), 
(61, 24, 1), (61, 18, 2), (62, 20, 1), (62, 25, 2), (63, 17, 1), (63, 28, 2), (64, 27, 1), (64, 22, 2), (65, 29, 1), (65, 19, 2), (66, 24, 1), (66, 18, 2), (67, 20, 1), (67, 25, 2), (68, 17, 1), (68, 28, 2), (69, 27, 1), 
(69, 22, 2), (70, 29, 1), (70, 19, 2), (71, 24, 1), (71, 18, 2), (72, 20, 1), (72, 25, 2), (73, 17, 1), (73, 28, 2), (74, 27, 1), (74, 22, 2), (75, 29, 1), (75, 19, 2), (76, 24, 1), (76, 18, 2), (77, 20, 1), (77, 25, 2), 
(78, 17, 1), (78, 28, 2), (79, 27, 1), (79, 22, 2), (80, 29, 1), (80, 19, 2), (81, 24, 1), (81, 18, 2), (82, 20, 1), (82, 25, 2), (83, 17, 1), (83, 28, 2), (84, 27, 1), (84, 22, 2), (85, 29, 1), (85, 19, 2), (86, 24, 1), 
(86, 18, 2), (87, 20, 1), (87, 25, 2), (88, 17, 1), (88, 28, 2), (89, 27, 1), (89, 22, 2), (90, 29, 1), (90, 19, 2), (91, 24, 1), (91, 18, 2), (92, 20, 1), (92, 25, 2), (93, 17, 1), (93, 28, 2), (94, 27, 1), (94, 22, 2), 
(95, 29, 1), (95, 19, 2), (96, 24, 1), (96, 18, 2), (97, 20, 1), (97, 25, 2), (98, 17, 1), (98, 28, 2), (99, 27, 1), (99, 22, 2), (100, 29, 1), (100, 19, 2), (101, 24, 1), (101, 18, 2), (102, 20, 1), (102, 25, 2), 
(103, 17, 1), (103, 28, 2), (104, 27, 1), (104, 22, 2), (105, 29, 1), (105, 19, 2), (106, 24, 1), (106, 18, 2), (107, 20, 1), (107, 25, 2), (108, 17, 1), (108, 28, 2), (109, 27, 1), (109, 22, 2), (110, 29, 1), 
(110, 19, 2), (111, 24, 1), (111, 18, 2), (112, 20, 1), (112, 25, 2), (113, 17, 1), (113, 28, 2), (114, 27, 1), (114, 22, 2), (115, 29, 1), (115, 19, 2), (116, 24, 1), (116, 18, 2), (117, 20, 1), (117, 25, 2), 
(118, 17, 1), (118, 28, 2), (119, 27, 1), (119, 22, 2), (120, 29, 1), (120, 19, 2), (121, 24, 1), (121, 18, 2), (122, 20, 1), (122, 25, 2), (123, 17, 1), (123, 28, 2), (124, 27, 1), (124, 22, 2), (125, 29, 1), 
(125, 19, 2), (126, 24, 1), (126, 18, 2), (127, 20, 1), (127, 25, 2), (128, 17, 1), (128, 28, 2), (129, 27, 1), (129, 22, 2), (130, 29, 1), (130, 19, 2), (131, 24, 1), (131, 18, 2), (132, 20, 1), (132, 25, 2), 
(133, 17, 1), (133, 28, 2), (134, 27, 1), (134, 22, 2), (135, 29, 1), (135, 19, 2), (136, 24, 1), (136, 18, 2), (137, 20, 1), (137, 25, 2), (138, 17, 1), (138, 28, 2), (139, 27, 1), (139, 22, 2), (140, 29, 1), 
(140, 19, 2), (141, 24, 1), (141, 18, 2), (142, 20, 1), (142, 25, 2), (143, 17, 1), (143, 28, 2), (144, 27, 1), (144, 22, 2), (145, 29, 1), (145, 19, 2), (146, 24, 1), (146, 18, 2), (147, 20, 1), (147, 25, 2), 
(148, 17, 1), (148, 28, 2), (149, 27, 1), (149, 22, 2), (150, 29, 1), (150, 19, 2), (151, 24, 1), (151, 18, 2), (152, 20, 1), (152, 25, 2), (153, 17, 1), (153, 28, 2), (154, 27, 1), (154, 22, 2), (155, 29, 1), 
(155, 19, 2), (156, 24, 1), (156, 18, 2), (157, 20, 1), (157, 25, 2), (158, 17, 1), (158, 28, 2), (159, 27, 1), (159, 22, 2), (160, 29, 1), (160, 19, 2), (161, 24, 1), (161, 18, 2), (162, 20, 1), (162, 25, 2), 
(163, 17, 1), (163, 28, 2), (164, 27, 1), (164, 22, 2), (165, 29, 1), (165, 19, 2), (166, 24, 1), (166, 18, 2), (167, 20, 1), (167, 25, 2), (168, 17, 1), (168, 28, 2), (169, 27, 1), (169, 22, 2), (170, 29, 1), 
(170, 19, 2), (171, 24, 1), (171, 18, 2), (172, 20, 1), (172, 25, 2), (173, 17, 1), (173, 28, 2), (174, 27, 1), (174, 22, 2), (175, 29, 1), (175, 19, 2), (176, 24, 1), (176, 18, 2), (177, 20, 1), (177, 25, 2), 
(178, 17, 1), (178, 28, 2), (179, 27, 1), (179, 22, 2), (180, 29, 1), (180, 19, 2), (181, 24, 1), (181, 18, 2), (182, 20, 1), (182, 25, 2), (183, 17, 1), (183, 28, 2), (184, 27, 1), (184, 22, 2), (185, 29, 1), 
(185, 19, 2), (186, 24, 1), (186, 18, 2), (187, 20, 1), (187, 25, 2), (188, 17, 1), (188, 28, 2), (189, 27, 1), (189, 22, 2), (190, 29, 1), (190, 19, 2), (191, 24, 1), (191, 18, 2), (192, 20, 1), (192, 25, 2), 
(193, 17, 1), (193, 28, 2), (194, 27, 1), (194, 22, 2), (195, 29, 1), (195, 19, 2), (196, 24, 1), (196, 18, 2), (197, 20, 1), (197, 25, 2), (198, 17, 1), (198, 28, 2), (199, 27, 1), (199, 22, 2), (200, 29, 1), 
(200, 19, 2), (201, 24, 1), (201, 18, 2), (202, 20, 1), (202, 25, 2), (203, 17, 1), (203, 28, 2), (204, 27, 1), (204, 22, 2), (205, 29, 1), (205, 19, 2), (206, 24, 1), (206, 18, 2), (207, 20, 1), (207, 25, 2), 
(208, 17, 1), (208, 28, 2), (209, 27, 1), (209, 22, 2), (210, 29, 1), (210, 19, 2), (211, 24, 1), (211, 18, 2), (212, 22, 1), (212, 16, 2), (213, 15, 1), (213, 20, 2), (214, 25, 1), (214, 19, 2), (215, 12, 1), 
(215, 11, 2), (216, 10, 1), (216, 6, 2), (217, 20, 1), (217, 15, 2), (218, 25, 1), (218, 20, 2), (219, 12, 1), (219, 29, 2), (220, 7, 1), (220, 25, 2), (221, 13, 1), (221, 28, 2), (222, 15, 1), (222, 24, 2), 
(223, 11, 1), (223, 4, 2), (224, 10, 1), (224, 19, 2), (225, 14, 1), (225, 21, 2), (226, 11, 1), (226, 25, 2), (227, 1, 1), (227, 28, 2), (228, 3, 1), (228, 22, 2), (229, 16, 1), (229, 12, 2), (230, 6, 1), 
(230, 10, 2), (231, 21, 1), (231, 16, 2), (232, 28, 1), (232, 5, 2), (233, 14, 1), (233, 15, 2), (234, 8, 1), (234, 20, 2), (235, 17, 1), (235, 9, 2), (236, 10, 1), (236, 22, 2), (237, 18, 1), (237, 19, 2), 
(238, 24, 1), (238, 23, 2), (239, 13, 1), (239, 3, 2), (240, 7, 1), (240, 18, 2), (241, 4, 1), (241, 26, 2), (242, 27, 1), (242, 17, 2), (243, 20, 1), (243, 2, 2), (244, 23, 1), (244, 8, 2), (245, 6, 1), 
(245, 14, 2), (246, 22, 1), (246, 24, 2), (247, 9, 1), (247, 29, 2), (248, 4, 1), (248, 28, 2), (249, 27, 1), (249, 21, 2), (250, 16, 1), (250, 7, 2), (251, 26, 1), (251, 5, 2), (252, 15, 1), (252, 12, 2), 
(253, 25, 1), (253, 13, 2), (254, 17, 1), (254, 11, 2), (255, 3, 1), (255, 1, 2), (256, 19, 1), (256, 23, 2), (257, 10, 1), (257, 20, 2),  (258, 27, 1),(258, 18, 2), (259, 14, 1), (259, 20, 2), (260, 29, 1),
(260, 21, 2), (261, 12, 1), (261, 17, 2),(262, 29, 1),  (262, 25, 2),  (263, 27, 1),  (263, 24, 2),  (264, 10, 1),  (264, 25, 2),  (265, 24, 1),  (265, 15, 2),  (266, 13, 1),  (266, 30, 2), (267, 19, 1), 
(267, 28, 2),  (268, 30, 1),  (268, 30, 2),  (269, 14, 1),  (269, 21, 2),  (270, 19, 1),  (270, 21, 2),  (271, 12, 1),  (271, 17, 2),  (272, 15, 1),  (272, 28, 2),  (273, 22, 1),  (273, 16, 2),  
(274, 26, 1),  (274, 25, 2),  (275, 29, 1),  (275, 12, 2),  (276, 12, 1),  (276, 29, 2),  (277, 17, 1),  (277, 22, 2),  (278, 20, 1),  (278, 15, 2),  (279, 10, 1),  (279, 24, 2),  (280, 17, 1),  (280, 20, 2),  
(281, 21, 1),  (281, 15, 2),  (282, 22, 1),  (282, 30, 2),  (283, 17, 1),  (283, 10, 2),  (284, 20, 1),  (284, 21, 2),  (285, 27, 1),  (285, 19, 2),  (286, 16, 1),  (286, 30, 2),  (287, 18, 1),  (287, 29, 2),  
(288, 16, 1),  (288, 28, 2),  (289, 10, 1),  (289, 21, 2),  (290, 13, 1),  (290, 12, 2),  (291, 18, 1),  (291, 22, 2),  (292, 30, 1),  (292, 20, 2),  (293, 13, 1),  (293, 20, 2),  (294, 24, 1),  (294, 28, 2),  
(295, 19, 1),  (295, 27, 2),  (296, 11, 1),  (296, 24, 2),  (297, 13, 1),  (297, 15, 2),  (298, 14, 1),  (298, 22, 2),  (299, 29, 1),  (299, 12, 2),  (300, 14, 1),  (300, 20, 2),  (301, 12, 1),  (301, 29, 2),  
(302, 18, 1),  (302, 26, 2),  (303, 29, 1),  (303, 26, 2),  (304, 19, 1),  (304, 16, 2),  (305, 12, 1),  (305, 22, 2),  (306, 20, 1),  (306, 11, 2),  (307, 29, 1),  (307, 24, 2),  (308, 14, 1),  (308, 21, 2),  
(309, 24, 1),  (309, 26, 2),  (310, 12, 1),  (310, 16, 2),  (311, 25, 1),  (311, 21, 2),  (312, 20, 1),  (312, 30, 2),  (313, 30, 1),  (313, 16, 2),  (314, 22, 1),  (314, 12, 2),  (315, 11, 1),  (315, 18, 2),  
(316, 27, 1),  (316, 10, 2),  (317, 25, 1),  (317, 19, 2),  (318, 15, 1),  (318, 23, 2),  (319, 12, 1),  (319, 25, 2),  (320, 29, 1),  (320, 18, 2),  (321, 29, 1),  (321, 28, 2),  (322, 24, 1),  (322, 23, 2),  
(323, 18, 1),  (323, 29, 2),  (324, 29, 1),  (324, 17, 2),  (325, 17, 1),  (325, 21, 2),  (326, 27, 1),  (326, 29, 2),  (327, 28, 1),  (327, 28, 2),  (328, 12, 1),  (328, 26, 2),  (329, 11, 1),  (329, 24, 2),  
(330, 22, 1),  (330, 24, 2),  (331, 29, 1),  (331, 23, 2),  (332, 30, 1),  (332, 19, 2),  (333, 16, 1),  (333, 26, 2),  (334, 12, 1),  (334, 30, 2),  (335, 18, 1),  (335, 30, 2),  (336, 30, 1),  (336, 21, 2),  
(337, 18, 1),  (337, 20, 2),  (338, 29, 1),  (338, 30, 2),  (339, 30, 1),  (339, 16, 2),  (340, 29, 1),  (340, 13, 2),  (341, 17, 1),  (341, 11, 2),  (342, 11, 1),  (342, 24, 2),  (343, 14, 1),  (343, 17, 2),  
(344, 19, 1),  (344, 23, 2),  (345, 17, 1),  (345, 27, 2),  (346, 26, 1),  (346, 10, 2),  (347, 28, 1),  (347, 25, 2),  (348, 17, 1),  (348, 20, 2),  (349, 19, 1),  (349, 23, 2),  (350, 12, 1),  (350, 15, 2),  
(351, 26, 1),  (351, 16, 2),  (352, 26, 1),  (352, 30, 2),  (353, 13, 1),  (353, 24, 2),  (354, 30, 1),  (354, 30, 2),  (355, 15, 1),  (355, 23, 2),  (356, 25, 1),  (356, 16, 2),  (357, 20, 1),  (357, 24, 2),  
(358, 20, 1),  (358, 18, 2),  (359, 17, 1),  (359, 28, 2),  (360, 10, 1),  (360, 19, 2),  (361, 29, 1),  (361, 26, 2),  (362, 19, 1),  (362, 20, 2),  (363, 22, 1),  (363, 24, 2),  (364, 26, 1),  (364, 23, 2),  
(365, 22, 1),  (365, 16, 2),  (366, 16, 1),  (366, 12, 2),  (367, 22, 1),  (367, 17, 2),  (368, 11, 1),  (368, 17, 2),  (369, 19, 1),  (369, 11, 2),  (370, 30, 1),  (370, 30, 2),  (371, 11, 1),  (371, 15, 2),  
(372, 16, 1),  (372, 16, 2),  (373, 27, 1),  (373, 27, 2),  (374, 18, 1),  (374, 24, 2),  (375, 28, 1),  (375, 13, 2),  (376, 16, 1),  (376, 27, 2),  (377, 10, 1),  (377, 30, 2),  (378, 27, 1),  (378, 18, 2),  
(379, 18, 1),  (379, 26, 2),  (380, 23, 1),  (380, 17, 2),  (381, 18, 1),  (381, 10, 2),  (382, 25, 1),  (382, 26, 2),  (383, 19, 1),  (383, 30, 2),  (384, 17, 1),  (384, 27, 2),  (385, 25, 1),  (385, 19, 2),  
(386, 17, 1),  (386, 11, 2),  (387, 13, 1),  (387, 25, 2),  (388, 25, 1),  (388, 23, 2),  (389, 29, 1),  (389, 15, 2),  (390, 19, 1),  (390, 18, 2),  (391, 23, 1),  (391, 27, 2),  (392, 24, 1),  (392, 25, 2),  
(393, 30, 1),  (393, 15, 2),  (394, 10, 1),  (394, 17, 2),  (395, 25, 1),  (395, 12, 2),  (396, 12, 1),  (396, 16, 2),  (397, 13, 1),  (397, 17, 2),  (398, 13, 1),  (398, 18, 2),  (399, 16, 1),  (399, 22, 2),  
(400, 28, 1),  (400, 21, 2),  (401, 25, 1),  (401, 26, 2),  (402, 17, 1),  (402, 23, 2),  (403, 13, 1),  (403, 15, 2),  (404, 26, 1),  (404, 19, 2),  (405, 12, 1),  (405, 12, 2),  (406, 14, 1),  (406, 27, 2),  
(407, 26, 1),  (407, 29, 2),  (408, 20, 1),  (408, 23, 2),  (409, 25, 1),  (409, 22, 2),  (410, 25, 1),  (410, 24, 2),  (411, 17, 1),  (411, 24, 2),  (412, 23, 1),  (412, 18, 2),  (413, 27, 1),  (413, 10, 2),  
(414, 23, 1),  (414, 11, 2),  (415, 20, 1),  (415, 29, 2),  (416, 23, 1),  (416, 14, 2),  (417, 15, 1),  (417, 12, 2),  (418, 22, 1),  (418, 21, 2),  (419, 15, 1),  (419, 13, 2),  (420, 22, 1),  (420, 19, 2),  
(421, 25, 1),  (421, 28, 2),  (422, 21, 1),  (422, 21, 2),  (423, 30, 1),  (423, 24, 2),  (424, 10, 1),  (424, 30, 2),  (425, 13, 1),  (425, 16, 2),  (426, 14, 1),  (426, 13, 2),  (427, 15, 1),  (427, 27, 2),  
(428, 25, 1),  (428, 28, 2),  (429, 20, 1),  (429, 17, 2),  (430, 26, 1),  (430, 26, 2),  (431, 21, 1),  (431, 27, 2),  (432, 25, 1),  (432, 30, 2),  (433, 25, 1),  (433, 20, 2),  (434, 30, 1),  (434, 26, 2),  
(435, 16, 1),  (435, 19, 2),  (436, 10, 1),  (436, 21, 2),  (437, 30, 1),  (437, 12, 2),  (438, 15, 1),  (438, 14, 2),  (439, 14, 1),  (439, 18, 2),  (440, 26, 1),  (440, 23, 2),  (441, 22, 1),  (441, 25, 2),  
(442, 10, 1),  (442, 29, 2),  (443, 22, 1),  (443, 17, 2),  (444, 18, 1),  (444, 26, 2),  (445, 13, 1),  (445, 27, 2),  (446, 21, 1),  (446, 14, 2),  (447, 23, 1),  (447, 29, 2),  (448, 18, 1),  (448, 13, 2),  
(449, 15, 1),  (449, 26, 2),  (450, 11, 1),  (450, 24, 2),  (451, 23, 1),  (451, 13, 2),  (452, 13, 1),  (452, 26, 2),  (453, 12, 1),  (453, 15, 2),  (454, 22, 1),  (454, 29, 2),  (455, 10, 1),  (455, 30, 2),  
(456, 14, 1),  (456, 22, 2),  (457, 25, 1),  (457, 28, 2),  (458, 26, 1),  (458, 30, 2),  (459, 21, 1),  (459, 14, 2),  (460, 11, 1),  (460, 30, 2),  (461, 24, 1),  (461, 21, 2),  (462, 20, 1),  (462, 10, 2),  
(463, 20, 1),  (463, 25, 2),  (464, 13, 1),  (464, 15, 2),  (465, 12, 1),  (465, 13, 2),  (466, 23, 1),  (466, 19, 2),  (467, 23, 1),  (467, 13, 2),  (468, 29, 1),  (468, 10, 2),  (469, 23, 1),  (469, 21, 2),  
(470, 15, 1),  (470, 11, 2),  (471, 10, 1),  (471, 14, 2),  (472, 14, 1),  (472, 29, 2),  (473, 26, 1),  (473, 23, 2),  (474, 13, 1),  (474, 23, 2),  (475, 20, 1),  (475, 28, 2),  (476, 21, 1),  (476, 20, 2),  
(477, 12, 1),  (477, 23, 2),  (478, 28, 1),  (478, 18, 2),  (479, 27, 1),  (479, 25, 2),  (480, 24, 1),  (480, 27, 2),  (481, 29, 1),  (481, 22, 2),  (482, 26, 1),  (482, 25, 2),  (483, 21, 1),  (483, 15, 2),  
(484, 22, 1),  (484, 26, 2),  (485, 25, 1),  (485, 28, 2),  (486, 15, 1),  (486, 22, 2),  (487, 29, 1),  (487, 13, 2),  (488, 18, 1),  (488, 19, 2),  (489, 19, 1),  (489, 25, 2),  (490, 27, 1),  (490, 11, 2),  
(491, 12, 1),  (491, 16, 2),  (492, 13, 1),  (492, 13, 2),  (493, 18, 1),  (493, 10, 2),  (494, 28, 1),  (494, 25, 2),  (495, 25, 1),  (495, 24, 2),  (496, 24, 1),  (496, 16, 2),  (497, 21, 1),  (497, 16, 2),  
(498, 10, 1),  (498, 17, 2),  (499, 28, 1),  (499, 15, 2),  (500, 21, 1),  (500, 19, 2),  (501, 20, 1),  (501, 20, 2),  (502, 23, 1),  (502, 20, 2),  (503, 12, 1),  (503, 14, 2),  (504, 21, 1),  (504, 20, 2),  
(505, 23, 1),  (505, 24, 2),  (506, 16, 1),  (506, 19, 2),  (507, 12, 1),  (507, 17, 2),  (508, 25, 1),  (508, 27, 2),  (509, 23, 1),  (509, 29, 2),  (510, 18, 1),  (510, 26, 2),  (511, 29, 1),  (511, 28, 2),  
(512, 21, 1),  (512, 22, 2);

INSERT INTO Portfolio (Portfolio_id, Datum, Snapshot_id)
VALUES
  (1, '2021-01-04', 1),
  (1, '2021-01-05', 2),
  (1, '2021-01-06', 3),
  (1, '2021-01-07', 4),
  (1, '2021-01-08', 5),
  (1, '2021-01-11', 6),
  (1, '2021-01-12', 7),
  (1, '2021-01-13', 8),
  (1, '2021-01-14', 9),
  (1, '2021-01-15', 10),
  (1, '2021-01-18', 11),
  (1, '2021-01-19', 12),
  (1, '2021-01-20', 13),
  (1, '2021-01-21', 14),
  (1, '2021-01-22', 15),
  (1, '2021-01-25', 16),
  (1, '2021-01-26', 17),
  (1, '2021-01-27', 18),
  (1, '2021-01-28', 19),
  (1, '2021-01-29', 20),
  (1, '2021-02-01', 21),
  (1, '2021-02-02', 22),
  (1, '2021-02-03', 23),
  (1, '2021-02-04', 24),
  (1, '2021-02-05', 25),
  (1, '2021-02-08', 26),
  (1, '2021-02-09', 27),
  (1, '2021-02-10', 28),
  (1, '2021-02-11', 29),
  (1, '2021-02-12', 30),
  (1, '2021-02-15', 31),
  (1, '2021-02-16', 32),
  (1, '2021-02-17', 33),
  (1, '2021-02-18', 34),
  (1, '2021-02-19', 35),
  (1, '2021-02-22', 36),
  (1, '2021-02-23', 37),
  (1, '2021-02-24', 38),
  (1, '2021-02-25', 39),
  (1, '2021-02-26', 40),
  (1, '2021-03-01', 41),
  (1, '2021-03-02', 42),
  (1, '2021-03-03', 43),
  (1, '2021-03-04', 44),
  (1, '2021-03-05', 45),
  (1, '2021-03-08', 46),
  (1, '2021-03-09', 47),
  (1, '2021-03-10', 48),
  (1, '2021-03-11', 49),
  (1, '2021-03-12', 50),
  (1, '2021-03-15', 51),
  (1, '2021-03-16', 52),
  (1, '2021-03-17', 53),
  (1, '2021-03-18', 54),
  (1, '2021-03-19', 55),
  (1, '2021-03-22', 56),
  (1, '2021-03-23', 57),
  (1, '2021-03-24', 58),
  (1, '2021-03-25', 59),
  (1, '2021-03-26', 60),
  (1, '2021-03-29', 61),
  (1, '2021-03-30', 62),
  (1, '2021-03-31', 63),
  (1, '2021-04-01', 64),
  (1, '2021-04-06', 65),
  (1, '2021-04-07', 66),
  (1, '2021-04-08', 67),
  (1, '2021-04-09', 68),
  (1, '2021-04-12', 69),
  (1, '2021-04-13', 70),
  (1, '2021-04-14', 71),
  (1, '2021-04-15', 72),
  (1, '2021-04-16', 73),
  (1, '2021-04-19', 74),
  (1, '2021-04-20', 75),
  (1, '2021-04-21', 76),
  (1, '2021-04-22', 77),
  (1, '2021-04-23', 78),
  (1, '2021-04-26', 79),
  (1, '2021-04-27', 80),
  (1, '2021-04-28', 81),
  (1, '2021-04-29', 82),
  (1, '2021-04-30', 83),
  (1, '2021-05-03', 84),
  (1, '2021-05-04', 85),
  (1, '2021-05-05', 86),
  (1, '2021-05-06', 87),
  (1, '2021-05-07', 88),
  (1, '2021-05-10', 89),
  (1, '2021-05-11', 90),
  (1, '2021-05-12', 91),
  (1, '2021-05-13', 92),
  (1, '2021-05-14', 93),
  (1, '2021-05-17', 94),
  (1, '2021-05-18', 95),
  (1, '2021-05-19', 96),
  (1, '2021-05-20', 97),
  (1, '2021-05-21', 98),
  (1, '2021-05-25', 99),
  (1, '2021-05-26', 100),
  (1, '2021-05-27', 101),
  (1, '2021-05-28', 102),
  (1, '2021-05-31', 103),
  (1, '2021-06-01', 104),
  (1, '2021-06-02', 105),
  (1, '2021-06-03', 106),
  (1, '2021-06-04', 107),
  (1, '2021-06-07', 108),
  (1, '2021-06-08', 109),
  (1, '2021-06-09', 110),
  (1, '2021-06-10', 111),
  (1, '2021-06-11', 112),
  (1, '2021-06-14', 113),
  (1, '2021-06-15', 114),
  (1, '2021-06-16', 115),
  (1, '2021-06-17', 116),
  (1, '2021-06-18', 117),
  (1, '2021-06-21', 118),
  (1, '2021-06-22', 119),
  (1, '2021-06-23', 120),
  (1, '2021-06-24', 121),
  (1, '2021-06-25', 122),
  (1, '2021-06-28', 123),
  (1, '2021-06-29', 124),
  (1, '2021-06-30', 125),
  (1, '2021-07-01', 126),
  (1, '2021-07-02', 127),
  (1, '2021-07-05', 128),
  (1, '2021-07-06', 129),
  (1, '2021-07-07', 130),
  (1, '2021-07-08', 131),
  (1, '2021-07-09', 132),
  (1, '2021-07-12', 133),
  (1, '2021-07-13', 134),
  (1, '2021-07-14', 135),
  (1, '2021-07-15', 136),
  (1, '2021-07-16', 137),
  (1, '2021-07-19', 138),
  (1, '2021-07-20', 139),
  (1, '2021-07-21', 140),
  (1, '2021-07-22', 141),
  (1, '2021-07-23', 142),
  (1, '2021-07-26', 143),
  (1, '2021-07-27', 144),
  (1, '2021-07-28', 145),
  (1, '2021-07-29', 146),
  (1, '2021-07-30', 147),
  (1, '2021-08-02', 148),
  (1, '2021-08-03', 149),
  (1, '2021-08-04', 150),
  (1, '2021-08-05', 151),
  (1, '2021-08-06', 152),
  (1, '2021-08-09', 153),
  (1, '2021-08-10', 154),
  (1, '2021-08-11', 155),
  (1, '2021-08-12', 156),
  (1, '2021-08-13', 157),
  (1, '2021-08-16', 158),
  (1, '2021-08-17', 159),
  (1, '2021-08-18', 160),
  (1, '2021-08-19', 161),
  (1, '2021-08-20', 162),
  (1, '2021-08-23', 163),
  (1, '2021-08-24', 164),
  (1, '2021-08-25', 165),
  (1, '2021-08-26', 166),
  (1, '2021-08-27', 167),
  (1, '2021-08-30', 168),
  (1, '2021-08-31', 169),
  (1, '2021-09-01', 170),
  (1, '2021-09-02', 171),
  (1, '2021-09-03', 172),
  (1, '2021-09-06', 173),
  (1, '2021-09-07', 174),
  (1, '2021-09-08', 175),
  (1, '2021-09-09', 176),
  (1, '2021-09-10', 177),
  (1, '2021-09-13', 178),
  (1, '2021-09-14', 179),
  (1, '2021-09-15', 180),
  (1, '2021-09-16', 181),
  (1, '2021-09-17', 182),
  (1, '2021-09-20', 183),
  (1, '2021-09-21', 184),
  (1, '2021-09-22', 185),
  (1, '2021-09-23', 186),
  (1, '2021-09-24', 187),
  (1, '2021-09-27', 188),
  (1, '2021-09-28', 189),
  (1, '2021-09-29', 190),
  (1, '2021-09-30', 191),
  (1, '2021-10-01', 192),
  (1, '2021-10-04', 193),
  (1, '2021-10-05', 194),
  (1, '2021-10-06', 195),
  (1, '2021-10-07', 196),
  (1, '2021-10-08', 197),
  (1, '2021-10-11', 198),
  (1, '2021-10-12', 199),
  (1, '2021-10-13', 200),
  (1, '2021-10-14', 201),
  (1, '2021-10-15', 202),
  (1, '2021-10-18', 203),
  (1, '2021-10-19', 204),
  (1, '2021-10-20', 205),
  (1, '2021-10-21', 206),
  (1, '2021-10-22', 207),
  (1, '2021-10-25', 208),
  (1, '2021-10-26', 209),
  (1, '2021-10-27', 210),
  (1, '2021-10-28', 211),
  (1, '2021-10-29', 212),
  (1, '2021-11-01', 213),
  (1, '2021-11-02', 214),
  (1, '2021-11-03', 215),
  (1, '2021-11-04', 216),
  (1, '2021-11-05', 217),
  (1, '2021-11-08', 218),
  (1, '2021-11-09', 219),
  (1, '2021-11-10', 220),
  (1, '2021-11-11', 221),
  (1, '2021-11-12', 222),
  (1, '2021-11-15', 223),
  (1, '2021-11-16', 224),
  (1, '2021-11-17', 225),
  (1, '2021-11-18', 226),
  (1, '2021-11-19', 227),
  (1, '2021-11-22', 228),
  (1, '2021-11-23', 229),
  (1, '2021-11-24', 230),
  (1, '2021-11-25', 231),
  (1, '2021-11-26', 232),
  (1, '2021-11-29', 233),
  (1, '2021-11-30', 234),
  (1, '2021-12-01', 235),
  (1, '2021-12-02', 236),
  (1, '2021-12-03', 237),
  (1, '2021-12-06', 238),
  (1, '2021-12-07', 239),
  (1, '2021-12-08', 240),
  (1, '2021-12-09', 241),
  (1, '2021-12-10', 242),
  (1, '2021-12-13', 243),
  (1, '2021-12-14', 244),
  (1, '2021-12-15', 245),
  (1, '2021-12-16', 246),
  (1, '2021-12-17', 247),
  (1, '2021-12-20', 248),
  (1, '2021-12-21', 249),
  (1, '2021-12-22', 250),
  (1, '2021-12-23', 251),
  (1, '2021-12-27', 252),
  (1, '2021-12-28', 253),
  (1, '2021-12-29', 254),
  (1, '2021-12-30', 255),
  (1, '2022-01-03', 256),
  (1, '2022-01-04', 257),
  (1, '2022-01-05', 258),
  (1, '2022-01-06', 259),
  (1, '2022-01-07', 260),
  (1, '2022-01-10', 261),
  (1, '2022-01-11', 262),
  (1, '2022-01-12', 263),
  (1, '2022-01-13', 264),
  (1, '2022-01-14', 265),
  (1, '2022-01-17', 266),
  (1, '2022-01-18', 267),
  (1, '2022-01-19', 268),
  (1, '2022-01-20', 269),
  (1, '2022-01-21', 270),
  (1, '2022-01-24', 271),
  (1, '2022-01-25', 272),
  (1, '2022-01-26', 273),
  (1, '2022-01-27', 274),
  (1, '2022-01-28', 275),
  (1, '2022-01-31', 276),
  (1, '2022-02-01', 277),
  (1, '2022-02-02', 278),
  (1, '2022-02-03', 279),
  (1, '2022-02-04', 280),
  (1, '2022-02-07', 281),
  (1, '2022-02-08', 282),
  (1, '2022-02-09', 283),
  (1, '2022-02-10', 284),
  (1, '2022-02-11', 285),
  (1, '2022-02-14', 286),
  (1, '2022-02-15', 287),
  (1, '2022-02-16', 288),
  (1, '2022-02-17', 289),
  (1, '2022-02-18', 290),
  (1, '2022-02-21', 291),
  (1, '2022-02-22', 292),
  (1, '2022-02-23', 293),
  (1, '2022-02-24', 294),
  (1, '2022-02-25', 295),
  (1, '2022-02-28', 296),
  (1, '2022-03-01', 297),
  (1, '2022-03-02', 298),
  (1, '2022-03-03', 299),
  (1, '2022-03-04', 300),
  (1, '2022-03-07', 301),
  (1, '2022-03-08', 302),
  (1, '2022-03-09', 303),
  (1, '2022-03-10', 304),
  (1, '2022-03-11', 305),
  (1, '2022-03-14', 306),
  (1, '2022-03-15', 307),
  (1, '2022-03-16', 308),
  (1, '2022-03-17', 309),
  (1, '2022-03-18', 310),
  (1, '2022-03-21', 311),
  (1, '2022-03-22', 312),
  (1, '2022-03-23', 313),
  (1, '2022-03-24', 314),
  (1, '2022-03-25', 315),
  (1, '2022-03-28', 316),
  (1, '2022-03-29', 317),
  (1, '2022-03-30', 318),
  (1, '2022-03-31', 319),
  (1, '2022-04-01', 320),
  (1, '2022-04-04', 321),
  (1, '2022-04-05', 322),
  (1, '2022-04-06', 323),
  (1, '2022-04-07', 324),
  (1, '2022-04-08', 325),
  (1, '2022-04-11', 326),
  (1, '2022-04-12', 327),
  (1, '2022-04-13', 328),
  (1, '2022-04-14', 329),
  (1, '2022-04-19', 330),
  (1, '2022-04-20', 331),
  (1, '2022-04-21', 332),
  (1, '2022-04-22', 333),
  (1, '2022-04-25', 334),
  (1, '2022-04-26', 335),
  (1, '2022-04-27', 336),
  (1, '2022-04-28', 337),
  (1, '2022-04-29', 338),
  (1, '2022-05-02', 339),
  (1, '2022-05-03', 340),
  (1, '2022-05-04', 341),
  (1, '2022-05-05', 342),
  (1, '2022-05-06', 343),
  (1, '2022-05-09', 344),
  (1, '2022-05-10', 345),
  (1, '2022-05-11', 346),
  (1, '2022-05-12', 347),
  (1, '2022-05-13', 348),
  (1, '2022-05-16', 349),
  (1, '2022-05-17', 350),
  (1, '2022-05-18', 351),
  (1, '2022-05-19', 352),
  (1, '2022-05-20', 353),
  (1, '2022-05-23', 354),
  (1, '2022-05-24', 355),
  (1, '2022-05-25', 356),
  (1, '2022-05-26', 357),
  (1, '2022-05-27', 358),
  (1, '2022-05-30', 359),
  (1, '2022-05-31', 360),
  (1, '2022-06-01', 361),
  (1, '2022-06-02', 362),
  (1, '2022-06-03', 363),
  (1, '2022-06-06', 364),
  (1, '2022-06-07', 365),
  (1, '2022-06-08', 366),
  (1, '2022-06-09', 367),
  (1, '2022-06-10', 368),
  (1, '2022-06-13', 369),
  (1, '2022-06-14', 370),
  (1, '2022-06-15', 371),
  (1, '2022-06-16', 372),
  (1, '2022-06-17', 373),
  (1, '2022-06-20', 374),
  (1, '2022-06-21', 375),
  (1, '2022-06-22', 376),
  (1, '2022-06-23', 377),
  (1, '2022-06-24', 378),
  (1, '2022-06-27', 379),
  (1, '2022-06-28', 380),
  (1, '2022-06-29', 381),
  (1, '2022-06-30', 382),
  (1, '2022-07-01', 383),
  (1, '2022-07-04', 384),
  (1, '2022-07-05', 385),
  (1, '2022-07-06', 386),
  (1, '2022-07-07', 387),
  (1, '2022-07-08', 388),
  (1, '2022-07-11', 389),
  (1, '2022-07-12', 390),
  (1, '2022-07-13', 391),
  (1, '2022-07-14', 392),
  (1, '2022-07-15', 393),
  (1, '2022-07-18', 394),
  (1, '2022-07-19', 395),
  (1, '2022-07-20', 396),
  (1, '2022-07-21', 397),
  (1, '2022-07-22', 398),
  (1, '2022-07-25', 399),
  (1, '2022-07-26', 400),
  (1, '2022-07-27', 401),
  (1, '2022-07-28', 402),
  (1, '2022-07-29', 403),
  (1, '2022-08-01', 404),
  (1, '2022-08-02', 405),
  (1, '2022-08-03', 406),
  (1, '2022-08-04', 407),
  (1, '2022-08-05', 408),
  (1, '2022-08-08', 409),
  (1, '2022-08-09', 410),
  (1, '2022-08-10', 411),
  (1, '2022-08-11', 412),
  (1, '2022-08-12', 413),
  (1, '2022-08-15', 414),
  (1, '2022-08-16', 415),
  (1, '2022-08-17', 416),
  (1, '2022-08-18', 417),
  (1, '2022-08-19', 418),
  (1, '2022-08-22', 419),
  (1, '2022-08-23', 420),
  (1, '2022-08-24', 421),
  (1, '2022-08-25', 422),
  (1, '2022-08-26', 423),
  (1, '2022-08-29', 424),
  (1, '2022-08-30', 425),
  (1, '2022-08-31', 426),
  (1, '2022-09-01', 427),
  (1, '2022-09-02', 428),
  (1, '2022-09-05', 429),
  (1, '2022-09-06', 430),
  (1, '2022-09-07', 431),
  (1, '2022-09-08', 432),
  (1, '2022-09-09', 433),
  (1, '2022-09-12', 434),
  (1, '2022-09-13', 435),
  (1, '2022-09-14', 436),
  (1, '2022-09-15', 437),
  (1, '2022-09-16', 438),
  (1, '2022-09-19', 439),
  (1, '2022-09-20', 440),
  (1, '2022-09-21', 441),
  (1, '2022-09-22', 442),
  (1, '2022-09-23', 443),
  (1, '2022-09-26', 444),
  (1, '2022-09-27', 445),
  (1, '2022-09-28', 446),
  (1, '2022-09-29', 447),
  (1, '2022-09-30', 448),
  (1, '2022-10-03', 449),
  (1, '2022-10-04', 450),
  (1, '2022-10-05', 451),
  (1, '2022-10-06', 452),
  (1, '2022-10-07', 453),
  (1, '2022-10-10', 454),
  (1, '2022-10-11', 455),
  (1, '2022-10-12', 456),
  (1, '2022-10-13', 457),
  (1, '2022-10-14', 458),
  (1, '2022-10-17', 459),
  (1, '2022-10-18', 460),
  (1, '2022-10-19', 461),
  (1, '2022-10-20', 462),
  (1, '2022-10-21', 463),
  (1, '2022-10-24', 464),
  (1, '2022-10-25', 465),
  (1, '2022-10-26', 466),
  (1, '2022-10-27', 467),
  (1, '2022-10-28', 468),
  (1, '2022-10-31', 469),
  (1, '2022-11-01', 470),
  (1, '2022-11-02', 471),
  (1, '2022-11-03', 472),
  (1, '2022-11-04', 473),
  (1, '2022-11-07', 474),
  (1, '2022-11-08', 475),
  (1, '2022-11-09', 476),
  (1, '2022-11-10', 477),
  (1, '2022-11-11', 478),
  (1, '2022-11-14', 479),
  (1, '2022-11-15', 480),
  (1, '2022-11-16', 481),
  (1, '2022-11-17', 482),
  (1, '2022-11-18', 483),
  (1, '2022-11-21', 484),
  (1, '2022-11-22', 485),
  (1, '2022-11-23', 486),
  (1, '2022-11-24', 487),
  (1, '2022-11-25', 488),
  (1, '2022-11-28', 489),
  (1, '2022-11-29', 490),
  (1, '2022-11-30', 491),
  (1, '2022-12-01', 492),
  (1, '2022-12-02', 493),
  (1, '2022-12-05', 494),
  (1, '2022-12-06', 495),
  (1, '2022-12-07', 496),
  (1, '2022-12-08', 497),
  (1, '2022-12-09', 498),
  (1, '2022-12-12', 499),
  (1, '2022-12-13', 500),
  (1, '2022-12-14', 501),
  (1, '2022-12-15', 502),
  (1, '2022-12-16', 503),
  (1, '2022-12-19', 504),
  (1, '2022-12-20', 505),
  (1, '2022-12-21', 506),
  (1, '2022-12-22', 507),
  (1, '2022-12-23', 508),
  (1, '2022-12-27', 509),
  (1, '2022-12-28', 510),
  (1, '2022-12-29', 511),
  (1, '2022-12-30', 512);

INSERT INTO Fonds (Name, ISIN, Portfolio_id)
VALUES 
('Lux Fonds', 'LU0047355440', '1');

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
