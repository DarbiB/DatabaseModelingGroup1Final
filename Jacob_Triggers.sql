-- Insertion trigger table
CREATE TABLE Survivors_Addition_Log
(
SurvivorsID varchar(8),
SurvivorsFirstName varchar(50),
SurvivorsLastName varchar(50),
SurvivorsGender char(1),
SurvivorsDOB Date,
LocationsID varchar(8),
Log_Action varchar(100),
Log_Timestamp datetime
)

SELECT *
FROM Survivors_Addition_Log;

-- Insertion trigger
GO
CREATE TRIGGER survivorsInsertTrigger ON [dbo].[Survivors]
AFTER INSERT
AS
	DECLARE @survivorsID varchar(8);
	DECLARE @survivorsFirstName varchar(50);
	DECLARE @survivorsLastName varchar(50);
	DECLARE @survivorsGender char(1);
	DECLARE @survivorsDOB Date;
	DECLARE @locationsID varchar(8);
	DECLARE @logAction varchar(100);

	SELECT @survivorsID=i.SurvivorsID FROM inserted AS i;
	SELECT @survivorsFirstName=i.SurvivorsFirstName FROM inserted AS i;
	SELECT @survivorsLastName=i.SurvivorsLastName FROM inserted AS i;
	SELECT @survivorsDOB=i.SurvivorsDOB FROM inserted AS i;
	SELECT @locationsID=i.LocationsID FROM inserted AS i;
	SET @logAction='Survivor Added.';

	SELECT * FROM inserted

	INSERT INTO Survivors_Addition_Log
		(SurvivorsID,SurvivorsFirstName,SurvivorsLastName,SurvivorsGender,SurvivorsDOB,LocationsID,Log_Action,Log_Timestamp)
	VALUES(@survivorsID,@survivorsFirstName,@survivorsLastName,@survivorsGender,@survivorsDOB,@locationsID,@logAction,GETDATE());

	UPDATE Locations
	SET LocationsPopulation = LocationsPopulation + 1
	WHERE LocationsID = @locationsID;

	PRINT 'Insert Trigger for Survivors table fired.'
GO


-- Deletion trigger table
CREATE TABLE Survivors_Deletion_Log
(
SurvivorsID varchar(8),
SurvivorsFirstName varchar(50),
SurvivorsLastName varchar(50),
SurvivorsGender char(1),
SurvivorsDOB Date,
LocationsID varchar(8),
Log_Action varchar(100),
Log_Timestamp datetime
)

SELECT *
FROM Survivors_Deletion_Log;

-- Deletion trigger
GO
CREATE TRIGGER survivorsDeletedTrigger ON [dbo].[Survivors]
AFTER DELETE
AS
	DECLARE @survivorsID varchar(8);
	DECLARE @survivorsFirstName varchar(50);
	DECLARE @survivorsLastName varchar(50);
	DECLARE @survivorsGender char(1);
	DECLARE @survivorsDOB Date;
	DECLARE @locationsID varchar(8);

	SELECT @survivorsID=d.SurvivorsID FROM deleted AS d;
	SELECT @survivorsFirstName=d.SurvivorsFirstName FROM deleted AS d;
	SELECT @survivorsLastName=d.SurvivorsLastName FROM deleted AS d;
	SELECT @survivorsGender=d.SurvivorsGender FROM deleted AS d;
	SELECT @survivorsDOB=d.SurvivorsDOB FROM deleted AS d;
	SELECT @locationsID=d.LocationsID FROM deleted AS d;

	SELECT * FROM deleted

	INSERT INTO Survivors_Deletion_Log
		(SurvivorsID,SurvivorsFirstName,SurvivorsLastName,SurvivorsGender,SurvivorsDOB,LocationsID,Log_Action,Log_Timestamp)
	VALUES(@survivorsID,@survivorsFirstName,@survivorsLastName,@survivorsGender,@survivorsDOB,@locationsID,'Survivor Removed',GETDATE());

	UPDATE Locations
	SET LocationsPopulation = LocationsPopulation - 1
	WHERE LocationsID = @locationsID;
GO


-- Resource Low Trigger Table
CREATE TABLE Low_Resource_Log
(
ResourcesID varchar(8),
LocationsID varchar(8),
ResourcesLocationsQty int,
Log_Action varchar(20),
Log_Timestamp datetime
)

-- Resource Low Trigger
GO
CREATE TRIGGER resourceUpdateTrigger ON [dbo].[ResourcesLocations]
AFTER UPDATE
AS
	DECLARE @resourcesID varchar(8);
	DECLARE @locationsID varchar(8);
	DECLARE @resourcesLocationsQty int;

	SELECT @resourcesID=i.ResourcesID FROM inserted AS i;
	SELECT @locationsID=i.LocationsID FROM inserted AS i;
	SELECT @resourcesLocationsQty=i.ResourcesLocationsQty FROM inserted AS i;

	SELECT * FROM inserted

	IF(@resourcesLocationsQty < 10)
	BEGIN
		INSERT INTO Low_Resource_Log
			(ResourcesID, LocationsID, ResourcesLocationsQty, Log_Action, Log_Timestamp)
		VALUES (@resourcesID, @locationsID, @resourcesLocationsQty, 'Gather More', GETDATE());
		PRINT 'Update Trigger for ResourcesLocations table fired.';
	END
GO


-- Resource Update Procedures

-- Take
CREATE PROCEDURE TakeResources (
	@ResourcesID varchar(8),
	@LocationsID varchar(8),
	@ResourceTaken int
)

AS 
BEGIN
	IF (ResourcesLocationsQty >= @ResourceTaken)
	BEGIN
		UPDATE [dbo].[ResourcesLocations]
		SET ResourcesLocationsQty = ResourcesLocationsQty - @ResourceTaken
		WHERE ResourcesID = @ResourcesID AND LocationsID = @LocationsID
	END
END;

GO

-- Add
CREATE PROCEDURE AddResources (
	@ResourcesID varchar(8),
	@LocationsID varchar(8),
	@ResourceTaken int
)

AS 
BEGIN
	UPDATE [dbo].[ResourcesLocations]
	SET ResourcesLocationsQty = ResourcesLocationsQty + @ResourceTaken
	WHERE ResourcesID = @ResourcesID AND LocationsID = @LocationsID

END;

GO