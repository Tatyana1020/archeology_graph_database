---------- 1-4 ----------

USE master;
GO

IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'Archeology')
BEGIN
  ALTER DATABASE Archeology SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
  DROP DATABASE Archeology;
END 
GO

CREATE DATABASE Archeology;
GO

USE Archeology;
GO

CREATE TABLE [Sites]
(
 [ID] Int NOT NULL,
 [SiteName] Nvarchar(100) NULL,
 [Location] Nvarchar(100) NULL,
 CONSTRAINT [PK_Sites] PRIMARY KEY ([ID])
)
AS NODE
go

CREATE TABLE [Artifacts]
(
 [ID] Int NOT NULL,
 [ArtifactName] Nvarchar(100) NULL,
 [Material] Nvarchar(50) NULL,
 CONSTRAINT [PK_Artifacts] PRIMARY KEY ([ID])
)
AS NODE
go

CREATE TABLE [Eras]
(
 [ID] Int NOT NULL,
 [EraName] Nvarchar(100) NULL,
 [CenturyRange] Nvarchar(50) NULL,
 CONSTRAINT [PK_Eras] PRIMARY KEY ([ID])
)
AS NODE
go

CREATE TABLE [FoundAt]
(
 [DiscoveryDate] Date NULL,
 [Depth] Decimal(5,2) NULL
)
AS EDGE
go

ALTER TABLE [FoundAt] ADD CONSTRAINT [EC_FOUNDAT] CONNECTION (
  [Artifacts] TO [Sites])
go

CREATE TABLE [BelongsToEra]
(
 [ConfidenceLevel] Int NULL
)
AS EDGE
go

ALTER TABLE [BelongsToEra] ADD CONSTRAINT [EC_ERA] CONNECTION (
  [Sites] TO [Eras],
  [Artifacts] TO [Eras])
go

CREATE TABLE [RelatedTo]
(
 [RelationType] Nvarchar(50) NULL
)
AS EDGE
go

ALTER TABLE [RelatedTo] ADD CONSTRAINT [EC_RELATED] CONNECTION (
  [Artifacts] TO [Artifacts])
go



INSERT INTO Sites (ID, SiteName, Location) VALUES 
(1, N'Плато Гиза', N'Египет'), 
(2, N'Помпеи', N'Италия'), 
(3, N'Троя', N'Турция'),
(4, N'Кносский дворец', N'Греция'), 
(5, N'Стоунхендж', N'Великобритания'), 
(6, N'Мачу-Пикчу', N'Перу'),
(7, N'Чичен-Ица', N'Мексика'), 
(8, N'Петра', N'Иордания'), 
(9, N'Адрианов вал', N'Великобритания'),
(10, N'Ангкор-Ват', N'Камбоджа');

INSERT INTO Artifacts (ID, ArtifactName, Material) VALUES 
(1, N'Золотая маска', N'Золото'), 
(2, N'Глиняная амфора', N'Керамика'), 
(3, N'Железный меч', N'Железо'),
(4, N'Мраморная статуя', N'Мрамор'), 
(5, N'Серебряная монета', N'Серебро'), 
(6, N'Обсидиановый нож', N'Камень'),
(7, N'Бронзовый щит', N'Бронза'), 
(8, N'Папирусный свиток', N'Органика'), 
(9, N'Перстень с камнем', N'Золото'),
(10, N'Каменный топор', N'Камень');

INSERT INTO Eras (ID, EraName, CenturyRange) VALUES 
(1, N'Бронзовый век', N'3300-1200 гг. до н.э.'), 
(2, N'Железный век', N'1200-500 гг. до н.э.'), 
(3, N'Классическая античность', N'800 г. до н.э. - 500 г. н.э.'), 
(4, N'Эллинистический период', N'323-31 гг. до н.э.'),
(5, N'Римская империя', N'27 г. до н.э. - 476 г. н.э.'), 
(6, N'Классический период майя', N'250-900 гг. н.э.'),
(7, N'Среднее царство', N'2040-1782 гг. до н.э.'), 
(8, N'Неолит', N'10000-4500 гг. до н.э.'),
(9, N'Империя инков', N'1438-1533 гг. н.э.'), 
(10, N'Древнее царство', N'2686-2181 гг. до н.э.');

INSERT INTO FoundAt ($from_id, $to_id, DiscoveryDate, Depth)
VALUES 
((SELECT $node_id FROM Artifacts WHERE ID = 1), (SELECT $node_id FROM Sites WHERE ID = 1), '1922-11-04', 12.50),
((SELECT $node_id FROM Artifacts WHERE ID = 2), (SELECT $node_id FROM Sites WHERE ID = 2), '1980-05-15', 3.20),
((SELECT $node_id FROM Artifacts WHERE ID = 3), (SELECT $node_id FROM Sites WHERE ID = 9), '2010-06-20', 1.50),
((SELECT $node_id FROM Artifacts WHERE ID = 5), (SELECT $node_id FROM Sites WHERE ID = 3), '1873-01-10', 5.00),
((SELECT $node_id FROM Artifacts WHERE ID = 4), (SELECT $node_id FROM Sites WHERE ID = 4), '1900-03-23', 4.10),
((SELECT $node_id FROM Artifacts WHERE ID = 6), (SELECT $node_id FROM Sites WHERE ID = 7), '2015-11-12', 2.80),
((SELECT $node_id FROM Artifacts WHERE ID = 7), (SELECT $node_id FROM Sites WHERE ID = 3), '1871-08-05', 6.30),
((SELECT $node_id FROM Artifacts WHERE ID = 8), (SELECT $node_id FROM Sites WHERE ID = 1), '1950-02-20', 8.45),
((SELECT $node_id FROM Artifacts WHERE ID = 9), (SELECT $node_id FROM Sites WHERE ID = 8), '1995-10-30', 0.50),
((SELECT $node_id FROM Artifacts WHERE ID = 10), (SELECT $node_id FROM Sites WHERE ID = 5), '2001-04-14', 1.20);

INSERT INTO BelongsToEra ($from_id, $to_id, ConfidenceLevel)
VALUES 
((SELECT $node_id FROM Sites WHERE ID = 1), (SELECT $node_id FROM Eras WHERE ID = 10), 10),
((SELECT $node_id FROM Sites WHERE ID = 2), (SELECT $node_id FROM Eras WHERE ID = 5), 10),
((SELECT $node_id FROM Sites WHERE ID = 6), (SELECT $node_id FROM Eras WHERE ID = 9), 9),
((SELECT $node_id FROM Artifacts WHERE ID = 7), (SELECT $node_id FROM Eras WHERE ID = 1), 8),
((SELECT $node_id FROM Sites WHERE ID = 3), (SELECT $node_id FROM Eras WHERE ID = 1), 7),
((SELECT $node_id FROM Sites WHERE ID = 4), (SELECT $node_id FROM Eras WHERE ID = 4), 9),
((SELECT $node_id FROM Sites WHERE ID = 5), (SELECT $node_id FROM Eras WHERE ID = 8), 6),
((SELECT $node_id FROM Sites WHERE ID = 10), (SELECT $node_id FROM Eras WHERE ID = 3), 10),
((SELECT $node_id FROM Artifacts WHERE ID = 3), (SELECT $node_id FROM Eras WHERE ID = 2), 9),
((SELECT $node_id FROM Artifacts WHERE ID = 6), (SELECT $node_id FROM Eras WHERE ID = 6), 8);

INSERT INTO RelatedTo ($from_id, $to_id, RelationType)
VALUES 
((SELECT $node_id FROM Artifacts WHERE ID = 1), 
 (SELECT $node_id FROM Artifacts WHERE ID = 9), N'Общий контекст захоронения'),

((SELECT $node_id FROM Artifacts WHERE ID = 2), 
 (SELECT $node_id FROM Artifacts WHERE ID = 8), N'Торговая документация'),

((SELECT $node_id FROM Artifacts WHERE ID = 3), 
 (SELECT $node_id FROM Artifacts WHERE ID = 7), N'Снаряжение воина'),

((SELECT $node_id FROM Artifacts WHERE ID = 6), 
 (SELECT $node_id FROM Artifacts WHERE ID = 10), N'Технология обработки камня'),

((SELECT $node_id FROM Artifacts WHERE ID = 5), 
 (SELECT $node_id FROM Artifacts WHERE ID = 2), N'Предметы обмена/торговли'),

((SELECT $node_id FROM Artifacts WHERE ID = 4), 
 (SELECT $node_id FROM Artifacts WHERE ID = 1), N'Ритуальное подношение'),

((SELECT $node_id FROM Artifacts WHERE ID = 10), 
 (SELECT $node_id FROM Artifacts WHERE ID = 6), N'Орудия одного периода'),

((SELECT $node_id FROM Artifacts WHERE ID = 7), 
 (SELECT $node_id FROM Artifacts WHERE ID = 3), N'Оборонительный комплекс'),

((SELECT $node_id FROM Artifacts WHERE ID = 8), 
 (SELECT $node_id FROM Artifacts WHERE ID = 9), N'Принадлежность правителю'),

((SELECT $node_id FROM Artifacts WHERE ID = 9), 
 (SELECT $node_id FROM Artifacts WHERE ID = 5), N'Драгоценные металлы');




---------- 5 ----------
SELECT Artifacts.ArtifactName, Sites.SiteName
FROM Artifacts, FoundAt, Sites, BelongsToEra, Eras
WHERE MATCH(Artifacts-(FoundAt)->Sites-(BelongsToEra)->Eras)
  AND Eras.EraName = N'Древнее царство';

SELECT Sites.SiteName, Eras.EraName, Artifacts.ArtifactName
FROM Artifacts, FoundAt, Sites, BelongsToEra, Eras
WHERE MATCH(Artifacts-(FoundAt)->Sites-(BelongsToEra)->Eras)
  AND Artifacts.Material = N'Золото';

SELECT A1.ArtifactName AS Source, A2.ArtifactName AS Related, Sites.SiteName
FROM Artifacts AS A1, RelatedTo, Artifacts AS A2, FoundAt, Sites
WHERE MATCH(A1-(RelatedTo)->A2-(FoundAt)->Sites);

SELECT A1.ArtifactName, A2.ArtifactName, Eras.EraName
FROM Artifacts AS A1, RelatedTo, Artifacts AS A2, BelongsToEra, Eras
WHERE MATCH(A1-(RelatedTo)->A2-(BelongsToEra)->Eras)
  AND Eras.EraName = N'Бронзовый век';

SELECT A1.ArtifactName, Sites.SiteName, Eras.EraName
FROM Artifacts AS A1, RelatedTo, Artifacts AS A2, FoundAt, Sites, BelongsToEra, Eras
WHERE MATCH(A1-(RelatedTo)->A2-(FoundAt)->Sites-(BelongsToEra)->Eras);



---------- 6 ----------
SELECT 
    START_NODE.ArtifactName AS StartNode,
    STRING_AGG(Target.ArtifactName, ' -> ') WITHIN GROUP (GRAPH PATH) AS FullPath
FROM 
    Artifacts AS START_NODE,
    RelatedTo FOR PATH AS rel,
    Artifacts FOR PATH AS Target
WHERE MATCH(SHORTEST_PATH(START_NODE(-(rel)->Target){1,5}))
  AND START_NODE.ArtifactName = N'Мраморная статуя';


SELECT 
    START_NODE.ArtifactName AS FromArtifact,
    STRING_AGG(NEXT_NODE.ArtifactName, ' > ') WITHIN GROUP (GRAPH PATH) AS PathSequence
FROM 
    Artifacts AS START_NODE,
    RelatedTo FOR PATH AS rel,
    Artifacts FOR PATH AS NEXT_NODE
WHERE MATCH(SHORTEST_PATH(START_NODE(-(rel)->NEXT_NODE)+))
  AND START_NODE.ArtifactName = N'Золотая маска';