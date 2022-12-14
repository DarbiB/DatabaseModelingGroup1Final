
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



--List all survivors and their age
CREATE VIEW PeopleAges
([First Name], [Last Name], [Location], [Age]) AS
SELECT SurvivorsFirstName, SurvivorsLastName, LocationsName, DATEDIFF(YY, SurvivorsDOB, GETDATE()) AS Age
FROM Survivors
INNER JOIN Locations ON Survivors.LocationsID = Locations.LocationsID;
GO

SELECT * FROM PeopleAges ORDER BY Age;
GO



-- Show Names of locations with their currency type amounts
CREATE VIEW CurrencyTypeLocation
([Location],[CurrencyType], [Amount]) AS
SELECT locations.LocationsName, Currency.CurrencyName, CurrencyLocations.CurrencyLocationsQty
FROM Currency
INNER JOIN CurrencyLocations ON Currency.CurrencyID = CurrencyLocations.CurrencyID
INNER JOIN Locations ON CurrencyLocations.LocationsID = Locations.LocationsID;
GO

SELECT * FROM CurrencyTypeLocation;
GO



--Shows days till expiration for resource items
CREATE VIEW ExpirationDays
([Location],[Description],[DaysTillExpiration]) AS
SELECT LocationsName, ResourcesDescription, DATEDIFF(Day, GETDATE(), ResourcesExpiration) AS DaysUntilExpired
FROM Resources
INNER JOIN ResourcesLocations on ResourcesLocations.ResourcesID = Resources.ResourcesID
INNER JOIN Locations on Locations.LocationsID = ResourcesLocations.LocationsID;
GO

SELECT * FROM ExpirationDays ORDER BY DaysTillExpiration;
GO



--Show quantity on hand and locations for all supply types

		--Resources
		CREATE VIEW ResourcesOnHand
		([Resource Name],[Qty On Hand],[Location]) AS
		SELECT ResourcesDescription, ResourcesLocationsQty, LocationsName
		FROM Resources
		INNER JOIN ResourcesLocations ON Resources.ResourcesID = ResourcesLocations.ResourcesID
		INNER JOIN Locations ON ResourcesLocations.LocationsID = Locations.LocationsID;
		GO

		SELECT * FROM ResourcesOnHand ORDER BY [Qty On Hand] ASC;
		GO


		--Weapons
		CREATE VIEW WeaponsOnHand
		([Weapon Name],[Qty On Hand],[Location]) AS
		SELECT WeaponsName, WeaponsLocationsQty, LocationsName
		FROM Weapons
		INNER JOIN WeaponsLocations ON Weapons.WeaponsID = WeaponsLocations.WeaponsID
		INNER JOIN Locations ON WeaponsLocations.LocationsID = Locations.LocationsID;
		GO

		SELECT * FROM WeaponsOnHand ORDER BY [Qty On Hand] ASC;
		GO


		--Medical Supplies
		CREATE VIEW MedicalSuppliesOnHand
		([Medical Supplies Name],[Qty On Hand],[Location]) AS
		SELECT MedicalSupplyName, MedicalSuppliesLocationsQty, LocationsName
		FROM MedicalSupplies
		INNER JOIN MedicalSuppliesLocations ON MedicalSupplies.MedicalSupplyID = MedicalSuppliesLocations.MedicalSupplyID
		INNER JOIN Locations ON MedicalSuppliesLocations.LocationsID = Locations.LocationsID;
		GO

		SELECT * FROM MedicalSuppliesOnHand ORDER BY [Qty On Hand] ASC;
		GO


		--Misc Items
		CREATE VIEW MiscItemsOnHand
		([Misc Items Description],[Qty On Hand],[Location]) AS
		SELECT MiscItemsDescription, MiscItemsLocationsQty, LocationsName
		FROM MiscItems
		INNER JOIN MiscItemsLocations ON MiscItems.MiscItemsID = MiscItemsLocations.MiscItemsID
		INNER JOIN Locations ON MiscItemsLocations.LocationsID = Locations.LocationsID;
		GO

		SELECT * FROM MiscItemsOnHand ORDER BY [Qty On Hand] ASC;
		GO

		--Transportation
		CREATE VIEW TransportationOnHand
		([Transportation Name],[Qty On Hand],[Location]) AS
		SELECT TransportationName, TransportationLocationsQty, LocationsName
		FROM Transportation
		INNER JOIN TransportationLocations ON Transportation.TransportationID = TransportationLocations.TransportationID
		INNER JOIN Locations ON TransportationLocations.LocationsID = Locations.LocationsID;
		GO

		SELECT * FROM TransportationOnHand ORDER BY [Qty On Hand] ASC;
		GO


