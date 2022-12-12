
--Show all survivors with skills and their locations
CREATE VIEW PeopleSkills
([First Name], [Last Name], [Skill], [Location]) AS
SELECT SurvivorsFirstName, SurvivorsLastName, SkillsDescription, LocationsName
FROM Survivors AS s
INNER JOIN Locations AS l ON s.LocationsID = l.LocationsID
RIGHT JOIN SurvivorsSkills AS ss ON s.SurvivorsID = ss.SurvivorsID
INNER JOIN Skills AS sk ON ss.SkillsID = sk.SkillsID;
GO

SELECT * FROM PeopleSkills;
GO


--List all survivors with more than 1 skill
CREATE VIEW PeopleMultipleSkills
([First Name], [Last Name], [Skill Count], [Location]) AS
SELECT Survivors.SurvivorsFirstName, Survivors.SurvivorsLastName, COUNT(SurvivorsSkills.SkillsID), Locations.LocationsName
FROM Survivors
INNER JOIN SurvivorsSkills ON Survivors.SurvivorsID = SurvivorsSkills.SurvivorsID
INNER JOIN Locations ON Survivors.LocationsID = Locations.LocationsID
GROUP BY Survivors.SurvivorsID, Survivors.SurvivorsFirstName, Survivors.SurvivorsLastName, Locations.LocationsName
HAVING COUNT(SurvivorsSkills.SkillsID) > 1;
GO

SELECT * FROM PeopleMultipleSkills;
GO

--List all survivors with skills and how many skills they have
CREATE VIEW AllPeopleSkillCounts
([First Name], [Last Name], [Skill Count], [Location]) AS
SELECT Survivors.SurvivorsFirstName, Survivors.SurvivorsLastName, COUNT(SurvivorsSkills.SkillsID), Locations.LocationsName
FROM Survivors
INNER JOIN SurvivorsSkills ON Survivors.SurvivorsID = SurvivorsSkills.SurvivorsID
INNER JOIN Locations ON Survivors.LocationsID = Locations.LocationsID
GROUP BY Survivors.SurvivorsID, Survivors.SurvivorsFirstName, Survivors.SurvivorsLastName, Locations.LocationsName;
GO

SELECT * FROM AllPeopleSkillCounts;
GO


--List survivors and their location by a certain skill
CREATE VIEW PeopleSearchBySkill
([First Name], [Last Name], [Skill], [Location]) AS
SELECT SurvivorsFirstName, SurvivorsLastName, SkillsDescription, LocationsName
FROM Survivors AS s
INNER JOIN Locations AS l ON s.LocationsID = l.LocationsID
RIGHT JOIN SurvivorsSkills AS ss ON s.SurvivorsID = ss.SurvivorsID
INNER JOIN Skills AS sk ON ss.SkillsID = sk.SkillsID
WHERE SkillsDescription LIKE '%Doctor%';
GO

SELECT * FROM PeopleSearchBySkill;
GO


--List all survivors and their age
CREATE VIEW PeopleAges
([First Name], [Last Name], [Location], [Age]) AS
SELECT SurvivorsFirstName, SurvivorsLastName, LocationsName, DATEDIFF(YY, SurvivorsDOB, GETDATE()) AS Age
FROM Survivors
INNER JOIN Locations ON Survivors.LocationsID = Locations.LocationsID;
GO

SELECT * FROM PeopleAges;
GO


--List Misc items and their locations by certain keyword
CREATE VIEW MiscItemSearch
([Item Type], [Description], [Location]) AS
SELECT MiscItemsType, MiscItemsDescription, LocationsName
FROM MiscItems
INNER JOIN MiscItemsLocations ON MiscItems.MiscItemsID = MiscItemsLocations.MiscItemsID
INNER JOIN Locations ON MiscItemsLocations.LocationsID = Locations.LocationsID
WHERE MiscItemsType LIKE '%Games%';
GO

SELECT * FROM MiscItemSearch;
GO








