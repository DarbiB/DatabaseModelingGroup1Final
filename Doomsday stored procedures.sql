CREATE PROCEDURE rescued (
	@SurvivorsID varchar(8) ,
	@SurvivorsFirstName varchar(50) ,
	@SurvivorsLastName varchar(50) ,
	@SurvivorsGender char(1) ,
	@SurvivorsDOB Date ,
	@LocationsID varchar(8)
)

AS 

BEGIN
	INSERT INTO survivors (SurvivorsID, SurvivorsFirstName, SurvivorsLastName, SurvivorsGender, SurvivorsDOB, LocationsID)
	VALUES (@SurvivorsID, @SurvivorsFirstName, @SurvivorsLastName, @SurvivorsGender, @SurvivorsDOB, @LocationsID);

END;

GO



CREATE PROCEDURE capturedORkilled (
	@SurvivorsID varchar(8) 
)

AS 

BEGIN
	DELETE FROM [dbo].[SurvivorsSkills]
	WHERE SurvivorsID = @SurvivorsID
	DELETE FROM [dbo].[Survivors]
	WHERE SurvivorsID = @SurvivorsID

END;

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
	DECLARE @CurrentQty AS INT;
	SELECT @CurrentQty = ResourcesLocationsQty FROM ResourcesLocations WHERE ResourcesID = @ResourcesID AND LocationsID = @LocationsID;
	IF (@CurrentQty >= @ResourceTaken)
	BEGIN
		UPDATE [dbo].[ResourcesLocations]
		SET ResourcesLocationsQty = ResourcesLocationsQty - @ResourceTaken
		WHERE ResourcesID = @ResourcesID AND LocationsID = @LocationsID
		PRINT N'Resources successfully taken.'
	END
	ELSE
		PRINT N'Not enough inventory on hand.'
END;

GO

-- Add
CREATE PROCEDURE AddResources (
	@ResourcesID varchar(8),
	@LocationsID varchar(8),
	@ResourceAdded int
)

AS 
BEGIN
	UPDATE [dbo].[ResourcesLocations]
	SET ResourcesLocationsQty = ResourcesLocationsQty + @ResourceAdded
	WHERE ResourcesID = @ResourcesID AND LocationsID = @LocationsID
	PRINT N'Resources successfully added.'

END;

GO