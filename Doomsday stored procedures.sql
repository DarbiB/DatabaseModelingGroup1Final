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



CREATE PROCEDURE captured (
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



CREATE PROCEDURE killed (
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