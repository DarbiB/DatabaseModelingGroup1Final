USE [master]
GO
/****** Object:  Database [Doomsday]    Script Date: 12/13/2022 10:40:15 PM ******/
CREATE DATABASE [Doomsday]
GO

USE [Doomsday]
GO

CREATE TABLE [dbo].[Locations](
	[LocationsID] [varchar](8) NOT NULL,
	[LocationsName] [varchar](50) NOT NULL,
	[LocationsPopulation] [int] NOT NULL,
	[LocationsCounty] [varchar](50) NOT NULL,
	[LocationsState] [char](2) NOT NULL,
 CONSTRAINT [PK_Locations] PRIMARY KEY CLUSTERED 
(
	[LocationsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Survivors]    Script Date: 12/13/2022 10:40:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Survivors](
	[SurvivorsID] [varchar](8) NOT NULL,
	[SurvivorsFirstName] [varchar](50) NOT NULL,
	[SurvivorsLastName] [varchar](50) NOT NULL,
	[SurvivorsGender] [char](1) NOT NULL,
	[SurvivorsDOB] [date] NOT NULL,
	[LocationsID] [varchar](8) NOT NULL,
 CONSTRAINT [PK_Survivors] PRIMARY KEY CLUSTERED 
(
	[SurvivorsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Skills]    Script Date: 12/13/2022 10:40:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Skills](
	[SkillsID] [varchar](8) NOT NULL,
	[SkillsDescription] [varchar](100) NOT NULL,
 CONSTRAINT [PK_Skills] PRIMARY KEY CLUSTERED 
(
	[SkillsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SurvivorsSkills]    Script Date: 12/13/2022 10:40:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SurvivorsSkills](
	[SurvivorsID] [varchar](8) NOT NULL,
	[SkillsID] [varchar](8) NOT NULL,
 CONSTRAINT [PK_SurvivorsSkills] PRIMARY KEY CLUSTERED 
(
	[SurvivorsID] ASC,
	[SkillsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[PeopleSkills]    Script Date: 12/13/2022 10:40:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[PeopleSkills]
([First Name], [Last Name], [Skill], [Location]) AS
SELECT SurvivorsFirstName, SurvivorsLastName, SkillsDescription, LocationsName
FROM Survivors AS s
INNER JOIN Locations AS l ON s.LocationsID = l.LocationsID
RIGHT JOIN SurvivorsSkills AS ss ON s.SurvivorsID = ss.SurvivorsID
INNER JOIN Skills AS sk ON ss.SkillsID = sk.SkillsID;
GO
/****** Object:  View [dbo].[PeopleMultipleSkills]    Script Date: 12/13/2022 10:40:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[PeopleMultipleSkills]
([First Name], [Last Name], [Skill Count], [Location]) AS
SELECT Survivors.SurvivorsFirstName, Survivors.SurvivorsLastName, COUNT(SurvivorsSkills.SkillsID), Locations.LocationsName
FROM Survivors
INNER JOIN SurvivorsSkills ON Survivors.SurvivorsID = SurvivorsSkills.SurvivorsID
INNER JOIN Locations ON Survivors.LocationsID = Locations.LocationsID
GROUP BY Survivors.SurvivorsID, Survivors.SurvivorsFirstName, Survivors.SurvivorsLastName, Locations.LocationsName
HAVING COUNT(SurvivorsSkills.SkillsID) > 1;
GO
/****** Object:  View [dbo].[AllPeopleSkillCounts]    Script Date: 12/13/2022 10:40:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[AllPeopleSkillCounts]
([First Name], [Last Name], [Skill Count], [Location]) AS
SELECT Survivors.SurvivorsFirstName, Survivors.SurvivorsLastName, COUNT(SurvivorsSkills.SkillsID), Locations.LocationsName
FROM Survivors
INNER JOIN SurvivorsSkills ON Survivors.SurvivorsID = SurvivorsSkills.SurvivorsID
INNER JOIN Locations ON Survivors.LocationsID = Locations.LocationsID
GROUP BY Survivors.SurvivorsID, Survivors.SurvivorsFirstName, Survivors.SurvivorsLastName, Locations.LocationsName;
GO
/****** Object:  View [dbo].[PeopleAges]    Script Date: 12/13/2022 10:40:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[PeopleAges]
([First Name], [Last Name], [Location], [Age]) AS
SELECT SurvivorsFirstName, SurvivorsLastName, LocationsName, DATEDIFF(YY, SurvivorsDOB, GETDATE()) AS Age
FROM Survivors
INNER JOIN Locations ON Survivors.LocationsID = Locations.LocationsID;
GO
/****** Object:  Table [dbo].[Currency]    Script Date: 12/13/2022 10:40:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Currency](
	[CurrencyID] [varchar](8) NOT NULL,
	[CurrencyName] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Currency] PRIMARY KEY CLUSTERED 
(
	[CurrencyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CurrencyLocations]    Script Date: 12/13/2022 10:40:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CurrencyLocations](
	[CurrencyID] [varchar](8) NOT NULL,
	[LocationsID] [varchar](8) NOT NULL,
	[CurrencyLocationsQty] [int] NOT NULL,
 CONSTRAINT [PK_CurrencyLocations] PRIMARY KEY CLUSTERED 
(
	[CurrencyID] ASC,
	[LocationsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[CurrencyTypeLocation]    Script Date: 12/13/2022 10:40:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[CurrencyTypeLocation]
([Location],[CurrencyType], [Amount]) AS
SELECT locations.LocationsName, Currency.CurrencyName, CurrencyLocations.CurrencyLocationsQty
FROM Currency
INNER JOIN CurrencyLocations ON Currency.CurrencyID = CurrencyLocations.CurrencyID
INNER JOIN Locations ON CurrencyLocations.LocationsID = Locations.LocationsID;
GO
/****** Object:  Table [dbo].[Resources]    Script Date: 12/13/2022 10:40:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Resources](
	[ResourcesID] [varchar](8) NOT NULL,
	[ResourcesDescription] [varchar](100) NOT NULL,
	[ResourcesExpiration] [date] NOT NULL,
	[ResourcesUnits] [varchar](50) NOT NULL,
	[CurrencyID] [varchar](8) NOT NULL,
	[ResourcesCurrencyCost] [int] NOT NULL,
 CONSTRAINT [PK_Resources] PRIMARY KEY CLUSTERED 
(
	[ResourcesID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ResourcesLocations]    Script Date: 12/13/2022 10:40:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ResourcesLocations](
	[ResourcesID] [varchar](8) NOT NULL,
	[LocationsID] [varchar](8) NOT NULL,
	[ResourcesLocationsQty] [int] NOT NULL,
 CONSTRAINT [PK_ResourcesLocations] PRIMARY KEY CLUSTERED 
(
	[ResourcesID] ASC,
	[LocationsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[ExpirationDays]    Script Date: 12/13/2022 10:40:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ExpirationDays]
([Location],[Description],[DaysTillExpiration]) AS
SELECT LocationsName, ResourcesDescription, DATEDIFF(Day, GETDATE(), ResourcesExpiration) AS DaysUntilExpired
FROM Resources
INNER JOIN ResourcesLocations on ResourcesLocations.ResourcesID = Resources.ResourcesID
INNER JOIN Locations on Locations.LocationsID = ResourcesLocations.LocationsID;
GO
/****** Object:  View [dbo].[ResourcesOnHand]    Script Date: 12/13/2022 10:40:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
		CREATE VIEW [dbo].[ResourcesOnHand]
		([Resource Name],[Qty On Hand],[Location]) AS
		SELECT ResourcesDescription, ResourcesLocationsQty, LocationsName
		FROM Resources
		INNER JOIN ResourcesLocations ON Resources.ResourcesID = ResourcesLocations.ResourcesID
		INNER JOIN Locations ON ResourcesLocations.LocationsID = Locations.LocationsID
GO
/****** Object:  Table [dbo].[Weapons]    Script Date: 12/13/2022 10:40:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Weapons](
	[WeaponsID] [varchar](8) NOT NULL,
	[WeaponsName] [varchar](50) NOT NULL,
	[CurrencyID] [varchar](8) NOT NULL,
	[WeaponsCost] [int] NOT NULL,
 CONSTRAINT [PK_Weapons_1] PRIMARY KEY CLUSTERED 
(
	[WeaponsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WeaponsLocations]    Script Date: 12/13/2022 10:40:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WeaponsLocations](
	[WeaponsID] [varchar](8) NOT NULL,
	[LocationsID] [varchar](8) NOT NULL,
	[WeaponsLocationsQty] [int] NOT NULL,
 CONSTRAINT [PK_WeaponsLocations] PRIMARY KEY CLUSTERED 
(
	[WeaponsID] ASC,
	[LocationsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[WeaponsOnHand]    Script Date: 12/13/2022 10:40:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	CREATE VIEW [dbo].[WeaponsOnHand]
		([Weapon Name],[Qty On Hand],[Location]) AS
		SELECT WeaponsName, WeaponsLocationsQty, LocationsName
		FROM Weapons
		INNER JOIN WeaponsLocations ON Weapons.WeaponsID = WeaponsLocations.WeaponsID
		INNER JOIN Locations ON WeaponsLocations.LocationsID = Locations.LocationsID;
GO
/****** Object:  Table [dbo].[MedicalSupplies]    Script Date: 12/13/2022 10:40:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MedicalSupplies](
	[MedicalSupplyID] [varchar](8) NOT NULL,
	[MedicalSupplyName] [varchar](100) NOT NULL,
	[MedicalSupplyDepartment] [varchar](50) NOT NULL,
	[MedicalSupplyDescription] [varchar](50) NOT NULL,
 CONSTRAINT [PK_MedicalSupplies] PRIMARY KEY CLUSTERED 
(
	[MedicalSupplyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MedicalSuppliesLocations]    Script Date: 12/13/2022 10:40:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MedicalSuppliesLocations](
	[MedicalSupplyID] [varchar](8) NOT NULL,
	[LocationsID] [varchar](8) NOT NULL,
	[MedicalSuppliesLocationsQty] [int] NOT NULL,
 CONSTRAINT [PK_MedicalSuppliesLocations] PRIMARY KEY CLUSTERED 
(
	[MedicalSupplyID] ASC,
	[LocationsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[MedicalSuppliesOnHand]    Script Date: 12/13/2022 10:40:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[MedicalSuppliesOnHand]
		([Medical Supplies Name],[Qty On Hand],[Location]) AS
		SELECT MedicalSupplyName, MedicalSuppliesLocationsQty, LocationsName
		FROM MedicalSupplies
		INNER JOIN MedicalSuppliesLocations ON MedicalSupplies.MedicalSupplyID = MedicalSuppliesLocations.MedicalSupplyID
		INNER JOIN Locations ON MedicalSuppliesLocations.LocationsID = Locations.LocationsID;
GO
/****** Object:  Table [dbo].[MiscItems]    Script Date: 12/13/2022 10:40:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MiscItems](
	[MiscItemsID] [varchar](8) NOT NULL,
	[MiscItemsType] [varchar](50) NOT NULL,
	[MiscItemsDescription] [varchar](50) NOT NULL,
 CONSTRAINT [PK_MiscItems] PRIMARY KEY CLUSTERED 
(
	[MiscItemsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MiscItemsLocations]    Script Date: 12/13/2022 10:40:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MiscItemsLocations](
	[MiscItemsID] [varchar](8) NOT NULL,
	[LocationsID] [varchar](8) NOT NULL,
	[MiscItemsLocationsQty] [int] NOT NULL,
 CONSTRAINT [PK_MiscItemsLocations] PRIMARY KEY CLUSTERED 
(
	[MiscItemsID] ASC,
	[LocationsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[MiscItemsOnHand]    Script Date: 12/13/2022 10:40:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[MiscItemsOnHand]
		([Misc Items Description],[Qty On Hand],[Location]) AS
		SELECT MiscItemsDescription, MiscItemsLocationsQty, LocationsName
		FROM MiscItems
		INNER JOIN MiscItemsLocations ON MiscItems.MiscItemsID = MiscItemsLocations.MiscItemsID
		INNER JOIN Locations ON MiscItemsLocations.LocationsID = Locations.LocationsID;
GO
/****** Object:  Table [dbo].[Transportation]    Script Date: 12/13/2022 10:40:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Transportation](
	[TransportationID] [varchar](8) NOT NULL,
	[TransportationName] [varchar](50) NOT NULL,
	[TransportationDescription] [varchar](200) NOT NULL,
	[TransportationCapacity] [int] NOT NULL,
 CONSTRAINT [PK_Transportation] PRIMARY KEY CLUSTERED 
(
	[TransportationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TransportationLocations]    Script Date: 12/13/2022 10:40:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TransportationLocations](
	[TransportationID] [varchar](8) NOT NULL,
	[LocationsID] [varchar](8) NOT NULL,
	[TransportationLocationsQty] [int] NOT NULL,
 CONSTRAINT [PK_TransportationLocations] PRIMARY KEY CLUSTERED 
(
	[TransportationID] ASC,
	[LocationsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[TransportationOnHand]    Script Date: 12/13/2022 10:40:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[TransportationOnHand]
		([Transportation Name],[Qty On Hand],[Location]) AS
		SELECT TransportationName, TransportationLocationsQty, LocationsName
		FROM Transportation
		INNER JOIN TransportationLocations ON Transportation.TransportationID = TransportationLocations.TransportationID
		INNER JOIN Locations ON TransportationLocations.LocationsID = Locations.LocationsID;
GO
/****** Object:  Table [dbo].[Low_Resource_Log]    Script Date: 12/13/2022 10:40:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Low_Resource_Log](
	[ResourcesID] [varchar](8) NULL,
	[LocationsID] [varchar](8) NULL,
	[ResourcesLocationsQty] [int] NULL,
	[Log_Action] [varchar](20) NULL,
	[Log_Timestamp] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PowerSource]    Script Date: 12/13/2022 10:40:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PowerSource](
	[PowerSourceID] [varchar](8) NOT NULL,
	[PowerSourceName] [varchar](50) NOT NULL,
	[PowerSourceUnits] [varchar](50) NOT NULL,
 CONSTRAINT [PK_PowerSource] PRIMARY KEY CLUSTERED 
(
	[PowerSourceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PowerSourceLocations]    Script Date: 12/13/2022 10:40:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PowerSourceLocations](
	[PowerSourceID] [varchar](8) NOT NULL,
	[LocationsID] [varchar](8) NOT NULL,
	[PowerSourceLocationsQty] [int] NOT NULL,
 CONSTRAINT [PK_PowerSourceLocations] PRIMARY KEY CLUSTERED 
(
	[PowerSourceID] ASC,
	[LocationsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Survivors_Addition_Log]    Script Date: 12/13/2022 10:40:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Survivors_Addition_Log](
	[SurvivorsID] [varchar](8) NULL,
	[SurvivorsFirstName] [varchar](50) NULL,
	[SurvivorsLastName] [varchar](50) NULL,
	[SurvivorsGender] [char](1) NULL,
	[SurvivorsDOB] [date] NULL,
	[LocationsID] [varchar](8) NULL,
	[Log_Action] [varchar](100) NULL,
	[Log_Timestamp] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Survivors_Deletion_Log]    Script Date: 12/13/2022 10:40:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Survivors_Deletion_Log](
	[SurvivorsID] [varchar](8) NULL,
	[SurvivorsFirstName] [varchar](50) NULL,
	[SurvivorsLastName] [varchar](50) NULL,
	[SurvivorsGender] [char](1) NULL,
	[SurvivorsDOB] [date] NULL,
	[LocationsID] [varchar](8) NULL,
	[Log_Action] [varchar](100) NULL,
	[Log_Timestamp] [datetime] NULL
) ON [PRIMARY]
GO
INSERT [dbo].[Currency] ([CurrencyID], [CurrencyName]) VALUES (N'C001', N'Silver Bars')
GO
INSERT [dbo].[Currency] ([CurrencyID], [CurrencyName]) VALUES (N'C002', N'Silver Coins')
GO
INSERT [dbo].[CurrencyLocations] ([CurrencyID], [LocationsID], [CurrencyLocationsQty]) VALUES (N'C001', N'L001', 1166)
GO
INSERT [dbo].[CurrencyLocations] ([CurrencyID], [LocationsID], [CurrencyLocationsQty]) VALUES (N'C001', N'L002', 1120)
GO
INSERT [dbo].[CurrencyLocations] ([CurrencyID], [LocationsID], [CurrencyLocationsQty]) VALUES (N'C001', N'L003', 1101)
GO
INSERT [dbo].[CurrencyLocations] ([CurrencyID], [LocationsID], [CurrencyLocationsQty]) VALUES (N'C001', N'L004', 188)
GO
INSERT [dbo].[CurrencyLocations] ([CurrencyID], [LocationsID], [CurrencyLocationsQty]) VALUES (N'C001', N'L005', 173)
GO
INSERT [dbo].[CurrencyLocations] ([CurrencyID], [LocationsID], [CurrencyLocationsQty]) VALUES (N'C002', N'L001', 2213)
GO
INSERT [dbo].[CurrencyLocations] ([CurrencyID], [LocationsID], [CurrencyLocationsQty]) VALUES (N'C002', N'L002', 1854)
GO
INSERT [dbo].[CurrencyLocations] ([CurrencyID], [LocationsID], [CurrencyLocationsQty]) VALUES (N'C002', N'L003', 1902)
GO
INSERT [dbo].[CurrencyLocations] ([CurrencyID], [LocationsID], [CurrencyLocationsQty]) VALUES (N'C002', N'L004', 1108)
GO
INSERT [dbo].[CurrencyLocations] ([CurrencyID], [LocationsID], [CurrencyLocationsQty]) VALUES (N'C002', N'L005', 917)
GO
INSERT [dbo].[Locations] ([LocationsID], [LocationsName], [LocationsPopulation], [LocationsCounty], [LocationsState]) VALUES (N'L001', N'Saint Cloud', 73, N'Stearns', N'MN')
GO
INSERT [dbo].[Locations] ([LocationsID], [LocationsName], [LocationsPopulation], [LocationsCounty], [LocationsState]) VALUES (N'L002', N'Sartell', 52, N'Stearns', N'MN')
GO
INSERT [dbo].[Locations] ([LocationsID], [LocationsName], [LocationsPopulation], [LocationsCounty], [LocationsState]) VALUES (N'L003', N'Waite Park', 42, N'Stearns', N'MN')
GO
INSERT [dbo].[Locations] ([LocationsID], [LocationsName], [LocationsPopulation], [LocationsCounty], [LocationsState]) VALUES (N'L004', N'Saint Joseph', 20, N'Stearns', N'MN')
GO
INSERT [dbo].[Locations] ([LocationsID], [LocationsName], [LocationsPopulation], [LocationsCounty], [LocationsState]) VALUES (N'L005', N'Cold Spring', 18, N'Stearns', N'MN')
GO
INSERT [dbo].[MedicalSupplies] ([MedicalSupplyID], [MedicalSupplyName], [MedicalSupplyDepartment], [MedicalSupplyDescription]) VALUES (N'M001', N'Bandage', N'First Aid', N'Gauze')
GO
INSERT [dbo].[MedicalSupplies] ([MedicalSupplyID], [MedicalSupplyName], [MedicalSupplyDepartment], [MedicalSupplyDescription]) VALUES (N'M002', N'Medicine', N'First Aid', N'Anitbiotic ointment')
GO
INSERT [dbo].[MedicalSupplies] ([MedicalSupplyID], [MedicalSupplyName], [MedicalSupplyDepartment], [MedicalSupplyDescription]) VALUES (N'M003', N'Bandage', N'First Aid', N'Small Bandages')
GO
INSERT [dbo].[MedicalSupplies] ([MedicalSupplyID], [MedicalSupplyName], [MedicalSupplyDepartment], [MedicalSupplyDescription]) VALUES (N'M004', N'Bandage', N'First Aid', N'Medium Bandages')
GO
INSERT [dbo].[MedicalSupplies] ([MedicalSupplyID], [MedicalSupplyName], [MedicalSupplyDepartment], [MedicalSupplyDescription]) VALUES (N'M005', N'Bandage', N'First Aid', N'Large Bandages')
GO
INSERT [dbo].[MedicalSupplies] ([MedicalSupplyID], [MedicalSupplyName], [MedicalSupplyDepartment], [MedicalSupplyDescription]) VALUES (N'M006', N'Medicine', N'First Aid', N'Advil')
GO
INSERT [dbo].[MedicalSupplies] ([MedicalSupplyID], [MedicalSupplyName], [MedicalSupplyDepartment], [MedicalSupplyDescription]) VALUES (N'M007', N'PPE', N'Protection', N'Rubber Gloves')
GO
INSERT [dbo].[MedicalSupplies] ([MedicalSupplyID], [MedicalSupplyName], [MedicalSupplyDepartment], [MedicalSupplyDescription]) VALUES (N'M008', N'PPE', N'Protection', N'Scrubs')
GO
INSERT [dbo].[MedicalSupplies] ([MedicalSupplyID], [MedicalSupplyName], [MedicalSupplyDepartment], [MedicalSupplyDescription]) VALUES (N'M009', N'Surgical Item', N'Surgical', N'Lidocaine')
GO
INSERT [dbo].[MedicalSupplies] ([MedicalSupplyID], [MedicalSupplyName], [MedicalSupplyDepartment], [MedicalSupplyDescription]) VALUES (N'M010', N'Surgical Item', N'Surgical', N'Syringe')
GO
INSERT [dbo].[MedicalSupplies] ([MedicalSupplyID], [MedicalSupplyName], [MedicalSupplyDepartment], [MedicalSupplyDescription]) VALUES (N'M011', N'Surgical Item', N'Surgical', N'Scalples')
GO
INSERT [dbo].[MedicalSupplies] ([MedicalSupplyID], [MedicalSupplyName], [MedicalSupplyDepartment], [MedicalSupplyDescription]) VALUES (N'M012', N'Surgical Item', N'Surgical', N'Suture needle')
GO
INSERT [dbo].[MedicalSupplies] ([MedicalSupplyID], [MedicalSupplyName], [MedicalSupplyDepartment], [MedicalSupplyDescription]) VALUES (N'M013', N'Surgical Item', N'Surgical', N'Thread')
GO
INSERT [dbo].[MedicalSupplies] ([MedicalSupplyID], [MedicalSupplyName], [MedicalSupplyDepartment], [MedicalSupplyDescription]) VALUES (N'M014', N'Surgical Item', N'Surgical', N'Foreceps')
GO
INSERT [dbo].[MedicalSupplies] ([MedicalSupplyID], [MedicalSupplyName], [MedicalSupplyDepartment], [MedicalSupplyDescription]) VALUES (N'M015', N'Surgical Item', N'Surgical', N'Hemostats')
GO
INSERT [dbo].[MedicalSupplies] ([MedicalSupplyID], [MedicalSupplyName], [MedicalSupplyDepartment], [MedicalSupplyDescription]) VALUES (N'M016', N'Surgical Item', N'Surgical', N'Skin staple')
GO
INSERT [dbo].[MedicalSupplies] ([MedicalSupplyID], [MedicalSupplyName], [MedicalSupplyDepartment], [MedicalSupplyDescription]) VALUES (N'M017', N'Surgical Item', N'Surgical', N'Trauma sheers')
GO
INSERT [dbo].[MedicalSupplies] ([MedicalSupplyID], [MedicalSupplyName], [MedicalSupplyDepartment], [MedicalSupplyDescription]) VALUES (N'M018', N'Miscellaneous', N'First Aid', N'Cold packs')
GO
INSERT [dbo].[MedicalSupplies] ([MedicalSupplyID], [MedicalSupplyName], [MedicalSupplyDepartment], [MedicalSupplyDescription]) VALUES (N'M019', N'Medicine', N'First Aid', N'Aloe vera')
GO
INSERT [dbo].[MedicalSupplies] ([MedicalSupplyID], [MedicalSupplyName], [MedicalSupplyDepartment], [MedicalSupplyDescription]) VALUES (N'M020', N'Medicine', N'First Aid', N'Asprin')
GO
INSERT [dbo].[MedicalSupplies] ([MedicalSupplyID], [MedicalSupplyName], [MedicalSupplyDepartment], [MedicalSupplyDescription]) VALUES (N'M021', N'Tool', N'Clinic', N'Blood presure cuff')
GO
INSERT [dbo].[MedicalSupplies] ([MedicalSupplyID], [MedicalSupplyName], [MedicalSupplyDepartment], [MedicalSupplyDescription]) VALUES (N'M022', N'Tool', N'Clinic', N'Stethoscope')
GO
INSERT [dbo].[MedicalSupplies] ([MedicalSupplyID], [MedicalSupplyName], [MedicalSupplyDepartment], [MedicalSupplyDescription]) VALUES (N'M023', N'Book', N'Reference', N'Medical reference')
GO
INSERT [dbo].[MedicalSupplies] ([MedicalSupplyID], [MedicalSupplyName], [MedicalSupplyDepartment], [MedicalSupplyDescription]) VALUES (N'M024', N'Book', N'Reference', N'First aid book')
GO
INSERT [dbo].[MedicalSupplies] ([MedicalSupplyID], [MedicalSupplyName], [MedicalSupplyDepartment], [MedicalSupplyDescription]) VALUES (N'M025', N'Bandage', N'First Aid', N'Tape')
GO
INSERT [dbo].[MedicalSupplies] ([MedicalSupplyID], [MedicalSupplyName], [MedicalSupplyDepartment], [MedicalSupplyDescription]) VALUES (N'M026', N'Tool', N'First Aid', N'Splint')
GO
INSERT [dbo].[MedicalSupplies] ([MedicalSupplyID], [MedicalSupplyName], [MedicalSupplyDepartment], [MedicalSupplyDescription]) VALUES (N'M027', N'Tool', N'First Aid', N'Tweezers')
GO
INSERT [dbo].[MedicalSupplies] ([MedicalSupplyID], [MedicalSupplyName], [MedicalSupplyDepartment], [MedicalSupplyDescription]) VALUES (N'M028', N'Surgical Item', N'Surgical', N'Sponges')
GO
INSERT [dbo].[MedicalSupplies] ([MedicalSupplyID], [MedicalSupplyName], [MedicalSupplyDepartment], [MedicalSupplyDescription]) VALUES (N'M029', N'Tool', N'Clinic', N'Tongue depressors')
GO
INSERT [dbo].[MedicalSupplies] ([MedicalSupplyID], [MedicalSupplyName], [MedicalSupplyDepartment], [MedicalSupplyDescription]) VALUES (N'M030', N'Miscellaneous', N'Clinic', N'Eye Wash')
GO
INSERT [dbo].[MedicalSupplies] ([MedicalSupplyID], [MedicalSupplyName], [MedicalSupplyDepartment], [MedicalSupplyDescription]) VALUES (N'M031', N'PPE', N'Protection', N'Mask')
GO
INSERT [dbo].[MedicalSupplies] ([MedicalSupplyID], [MedicalSupplyName], [MedicalSupplyDepartment], [MedicalSupplyDescription]) VALUES (N'M032', N'Cleaner', N'Cleaner', N'Hand Sanitizer')
GO
INSERT [dbo].[MedicalSupplies] ([MedicalSupplyID], [MedicalSupplyName], [MedicalSupplyDepartment], [MedicalSupplyDescription]) VALUES (N'M033', N'Cleaner', N'Cleaner', N'Hand Soap')
GO
INSERT [dbo].[MedicalSupplies] ([MedicalSupplyID], [MedicalSupplyName], [MedicalSupplyDepartment], [MedicalSupplyDescription]) VALUES (N'M034', N'Surgical Item', N'Surgical', N'Pen light')
GO
INSERT [dbo].[MedicalSupplies] ([MedicalSupplyID], [MedicalSupplyName], [MedicalSupplyDepartment], [MedicalSupplyDescription]) VALUES (N'M035', N'Miscellaneous', N'First Aid', N'Smelling salts')
GO
INSERT [dbo].[MedicalSupplies] ([MedicalSupplyID], [MedicalSupplyName], [MedicalSupplyDepartment], [MedicalSupplyDescription]) VALUES (N'M036', N'Medicine', N'First Aid', N'Burn cream')
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M001', N'L001', 12)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M001', N'L002', 7)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M001', N'L003', 15)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M001', N'L004', 4)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M001', N'L005', 9)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M002', N'L001', 3)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M002', N'L002', 2)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M002', N'L003', 4)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M002', N'L004', 5)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M002', N'L005', 1)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M003', N'L001', 30)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M003', N'L002', 45)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M003', N'L003', 50)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M003', N'L004', 40)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M003', N'L005', 44)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M004', N'L001', 32)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M004', N'L002', 43)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M004', N'L003', 15)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M004', N'L004', 19)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M004', N'L005', 29)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M005', N'L001', 53)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M005', N'L002', 44)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M005', N'L003', 29)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M005', N'L004', 20)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M005', N'L005', 33)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M006', N'L001', 44)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M006', N'L004', 49)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M006', N'L005', 57)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M007', N'L001', 32)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M007', N'L002', 44)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M007', N'L003', 28)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M007', N'L004', 32)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M007', N'L005', 20)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M008', N'L001', 12)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M008', N'L002', 6)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M008', N'L003', 4)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M008', N'L004', 8)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M008', N'L005', 9)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M009', N'L002', 4)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M009', N'L003', 7)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M010', N'L001', 3)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M010', N'L002', 6)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M010', N'L004', 9)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M010', N'L005', 2)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M011', N'L001', 2)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M011', N'L003', 3)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M011', N'L004', 1)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M012', N'L001', 2)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M012', N'L002', 4)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M012', N'L003', 2)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M012', N'L004', 1)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M012', N'L005', 7)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M013', N'L001', 3)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M013', N'L002', 5)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M013', N'L003', 2)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M013', N'L004', 6)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M013', N'L005', 4)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M014', N'L003', 1)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M014', N'L004', 2)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M014', N'L005', 1)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M015', N'L001', 2)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M015', N'L002', 1)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M015', N'L003', 3)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M015', N'L004', 1)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M016', N'L002', 10)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M016', N'L004', 12)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M016', N'L005', 8)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M017', N'L003', 1)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M018', N'L002', 1)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M018', N'L003', 3)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M018', N'L004', 2)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M018', N'L005', 1)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M019', N'L001', 4)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M019', N'L003', 2)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M020', N'L002', 45)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M020', N'L003', 37)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M020', N'L005', 23)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M021', N'L001', 1)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M021', N'L002', 1)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M022', N'L001', 1)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M022', N'L004', 1)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M022', N'L005', 1)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M023', N'L002', 1)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M023', N'L003', 1)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M024', N'L004', 1)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M024', N'L005', 1)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M025', N'L001', 2)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M025', N'L003', 5)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M025', N'L004', 3)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M025', N'L005', 1)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M026', N'L001', 2)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M026', N'L003', 5)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M027', N'L002', 1)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M027', N'L004', 3)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M028', N'L001', 3)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M028', N'L002', 4)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M028', N'L003', 2)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M028', N'L004', 5)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M028', N'L005', 3)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M029', N'L004', 10)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M029', N'L005', 12)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M030', N'L003', 1)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M030', N'L005', 3)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M031', N'L001', 15)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M031', N'L002', 22)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M031', N'L003', 13)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M031', N'L004', 10)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M031', N'L005', 43)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M032', N'L001', 7)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M032', N'L002', 3)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M032', N'L003', 5)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M032', N'L004', 1)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M032', N'L005', 9)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M033', N'L001', 4)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M033', N'L002', 15)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M033', N'L003', 2)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M033', N'L004', 8)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M033', N'L005', 12)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M034', N'L001', 1)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M034', N'L002', 1)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M035', N'L001', 4)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M035', N'L004', 7)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M036', N'L001', 3)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M036', N'L003', 7)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M036', N'L004', 5)
GO
INSERT [dbo].[MedicalSuppliesLocations] ([MedicalSupplyID], [LocationsID], [MedicalSuppliesLocationsQty]) VALUES (N'M036', N'L005', 3)
GO
INSERT [dbo].[MiscItems] ([MiscItemsID], [MiscItemsType], [MiscItemsDescription]) VALUES (N'I001', N'Electronics', N'Television')
GO
INSERT [dbo].[MiscItems] ([MiscItemsID], [MiscItemsType], [MiscItemsDescription]) VALUES (N'I002', N'Reading Material', N'Book')
GO
INSERT [dbo].[MiscItems] ([MiscItemsID], [MiscItemsType], [MiscItemsDescription]) VALUES (N'I003', N'Electronics', N'Computer')
GO
INSERT [dbo].[MiscItems] ([MiscItemsID], [MiscItemsType], [MiscItemsDescription]) VALUES (N'I004', N'Reading Material', N'Magazine')
GO
INSERT [dbo].[MiscItems] ([MiscItemsID], [MiscItemsType], [MiscItemsDescription]) VALUES (N'I005', N'Electronics', N'Walkie Talkie')
GO
INSERT [dbo].[MiscItems] ([MiscItemsID], [MiscItemsType], [MiscItemsDescription]) VALUES (N'I006', N'Electronics', N'Radio')
GO
INSERT [dbo].[MiscItems] ([MiscItemsID], [MiscItemsType], [MiscItemsDescription]) VALUES (N'I007', N'Games', N'Board Game')
GO
INSERT [dbo].[MiscItems] ([MiscItemsID], [MiscItemsType], [MiscItemsDescription]) VALUES (N'I008', N'Electronics', N'Headphones')
GO
INSERT [dbo].[MiscItems] ([MiscItemsID], [MiscItemsType], [MiscItemsDescription]) VALUES (N'I009', N'Electronics', N'Bluetooth Speakers')
GO
INSERT [dbo].[MiscItems] ([MiscItemsID], [MiscItemsType], [MiscItemsDescription]) VALUES (N'I010', N'Games', N'Card Game')
GO
INSERT [dbo].[MiscItems] ([MiscItemsID], [MiscItemsType], [MiscItemsDescription]) VALUES (N'I011', N'DVD/Bluray', N'TV Show')
GO
INSERT [dbo].[MiscItems] ([MiscItemsID], [MiscItemsType], [MiscItemsDescription]) VALUES (N'I012', N'Electronics', N'Xbox')
GO
INSERT [dbo].[MiscItems] ([MiscItemsID], [MiscItemsType], [MiscItemsDescription]) VALUES (N'I013', N'DVD/Bluray', N'Movie')
GO
INSERT [dbo].[MiscItems] ([MiscItemsID], [MiscItemsType], [MiscItemsDescription]) VALUES (N'I014', N'Electronics', N'Cell Phone')
GO
INSERT [dbo].[MiscItems] ([MiscItemsID], [MiscItemsType], [MiscItemsDescription]) VALUES (N'I015', N'Games', N'Dice')
GO
INSERT [dbo].[MiscItemsLocations] ([MiscItemsID], [LocationsID], [MiscItemsLocationsQty]) VALUES (N'I001', N'L001', 5)
GO
INSERT [dbo].[MiscItemsLocations] ([MiscItemsID], [LocationsID], [MiscItemsLocationsQty]) VALUES (N'I001', N'L002', 3)
GO
INSERT [dbo].[MiscItemsLocations] ([MiscItemsID], [LocationsID], [MiscItemsLocationsQty]) VALUES (N'I001', N'L003', 3)
GO
INSERT [dbo].[MiscItemsLocations] ([MiscItemsID], [LocationsID], [MiscItemsLocationsQty]) VALUES (N'I001', N'L004', 2)
GO
INSERT [dbo].[MiscItemsLocations] ([MiscItemsID], [LocationsID], [MiscItemsLocationsQty]) VALUES (N'I002', N'L001', 13)
GO
INSERT [dbo].[MiscItemsLocations] ([MiscItemsID], [LocationsID], [MiscItemsLocationsQty]) VALUES (N'I002', N'L002', 11)
GO
INSERT [dbo].[MiscItemsLocations] ([MiscItemsID], [LocationsID], [MiscItemsLocationsQty]) VALUES (N'I002', N'L003', 26)
GO
INSERT [dbo].[MiscItemsLocations] ([MiscItemsID], [LocationsID], [MiscItemsLocationsQty]) VALUES (N'I002', N'L004', 6)
GO
INSERT [dbo].[MiscItemsLocations] ([MiscItemsID], [LocationsID], [MiscItemsLocationsQty]) VALUES (N'I002', N'L005', 13)
GO
INSERT [dbo].[MiscItemsLocations] ([MiscItemsID], [LocationsID], [MiscItemsLocationsQty]) VALUES (N'I003', N'L001', 3)
GO
INSERT [dbo].[MiscItemsLocations] ([MiscItemsID], [LocationsID], [MiscItemsLocationsQty]) VALUES (N'I003', N'L002', 2)
GO
INSERT [dbo].[MiscItemsLocations] ([MiscItemsID], [LocationsID], [MiscItemsLocationsQty]) VALUES (N'I003', N'L003', 2)
GO
INSERT [dbo].[MiscItemsLocations] ([MiscItemsID], [LocationsID], [MiscItemsLocationsQty]) VALUES (N'I003', N'L004', 1)
GO
INSERT [dbo].[MiscItemsLocations] ([MiscItemsID], [LocationsID], [MiscItemsLocationsQty]) VALUES (N'I003', N'L005', 1)
GO
INSERT [dbo].[MiscItemsLocations] ([MiscItemsID], [LocationsID], [MiscItemsLocationsQty]) VALUES (N'I004', N'L001', 7)
GO
INSERT [dbo].[MiscItemsLocations] ([MiscItemsID], [LocationsID], [MiscItemsLocationsQty]) VALUES (N'I004', N'L002', 8)
GO
INSERT [dbo].[MiscItemsLocations] ([MiscItemsID], [LocationsID], [MiscItemsLocationsQty]) VALUES (N'I004', N'L003', 10)
GO
INSERT [dbo].[MiscItemsLocations] ([MiscItemsID], [LocationsID], [MiscItemsLocationsQty]) VALUES (N'I004', N'L004', 5)
GO
INSERT [dbo].[MiscItemsLocations] ([MiscItemsID], [LocationsID], [MiscItemsLocationsQty]) VALUES (N'I004', N'L005', 2)
GO
INSERT [dbo].[MiscItemsLocations] ([MiscItemsID], [LocationsID], [MiscItemsLocationsQty]) VALUES (N'I005', N'L001', 1)
GO
INSERT [dbo].[MiscItemsLocations] ([MiscItemsID], [LocationsID], [MiscItemsLocationsQty]) VALUES (N'I005', N'L004', 1)
GO
INSERT [dbo].[MiscItemsLocations] ([MiscItemsID], [LocationsID], [MiscItemsLocationsQty]) VALUES (N'I006', N'L001', 1)
GO
INSERT [dbo].[MiscItemsLocations] ([MiscItemsID], [LocationsID], [MiscItemsLocationsQty]) VALUES (N'I006', N'L002', 1)
GO
INSERT [dbo].[MiscItemsLocations] ([MiscItemsID], [LocationsID], [MiscItemsLocationsQty]) VALUES (N'I006', N'L005', 1)
GO
INSERT [dbo].[MiscItemsLocations] ([MiscItemsID], [LocationsID], [MiscItemsLocationsQty]) VALUES (N'I007', N'L001', 4)
GO
INSERT [dbo].[MiscItemsLocations] ([MiscItemsID], [LocationsID], [MiscItemsLocationsQty]) VALUES (N'I007', N'L002', 5)
GO
INSERT [dbo].[MiscItemsLocations] ([MiscItemsID], [LocationsID], [MiscItemsLocationsQty]) VALUES (N'I007', N'L003', 4)
GO
INSERT [dbo].[MiscItemsLocations] ([MiscItemsID], [LocationsID], [MiscItemsLocationsQty]) VALUES (N'I007', N'L004', 3)
GO
INSERT [dbo].[MiscItemsLocations] ([MiscItemsID], [LocationsID], [MiscItemsLocationsQty]) VALUES (N'I007', N'L005', 3)
GO
INSERT [dbo].[MiscItemsLocations] ([MiscItemsID], [LocationsID], [MiscItemsLocationsQty]) VALUES (N'I008', N'L001', 8)
GO
INSERT [dbo].[MiscItemsLocations] ([MiscItemsID], [LocationsID], [MiscItemsLocationsQty]) VALUES (N'I008', N'L002', 5)
GO
INSERT [dbo].[MiscItemsLocations] ([MiscItemsID], [LocationsID], [MiscItemsLocationsQty]) VALUES (N'I008', N'L003', 6)
GO
INSERT [dbo].[MiscItemsLocations] ([MiscItemsID], [LocationsID], [MiscItemsLocationsQty]) VALUES (N'I008', N'L004', 4)
GO
INSERT [dbo].[MiscItemsLocations] ([MiscItemsID], [LocationsID], [MiscItemsLocationsQty]) VALUES (N'I008', N'L005', 2)
GO
INSERT [dbo].[MiscItemsLocations] ([MiscItemsID], [LocationsID], [MiscItemsLocationsQty]) VALUES (N'I009', N'L002', 1)
GO
INSERT [dbo].[MiscItemsLocations] ([MiscItemsID], [LocationsID], [MiscItemsLocationsQty]) VALUES (N'I009', N'L004', 1)
GO
INSERT [dbo].[MiscItemsLocations] ([MiscItemsID], [LocationsID], [MiscItemsLocationsQty]) VALUES (N'I010', N'L001', 3)
GO
INSERT [dbo].[MiscItemsLocations] ([MiscItemsID], [LocationsID], [MiscItemsLocationsQty]) VALUES (N'I010', N'L002', 3)
GO
INSERT [dbo].[MiscItemsLocations] ([MiscItemsID], [LocationsID], [MiscItemsLocationsQty]) VALUES (N'I010', N'L003', 1)
GO
INSERT [dbo].[MiscItemsLocations] ([MiscItemsID], [LocationsID], [MiscItemsLocationsQty]) VALUES (N'I010', N'L004', 1)
GO
INSERT [dbo].[MiscItemsLocations] ([MiscItemsID], [LocationsID], [MiscItemsLocationsQty]) VALUES (N'I011', N'L001', 3)
GO
INSERT [dbo].[MiscItemsLocations] ([MiscItemsID], [LocationsID], [MiscItemsLocationsQty]) VALUES (N'I011', N'L002', 2)
GO
INSERT [dbo].[MiscItemsLocations] ([MiscItemsID], [LocationsID], [MiscItemsLocationsQty]) VALUES (N'I011', N'L004', 1)
GO
INSERT [dbo].[MiscItemsLocations] ([MiscItemsID], [LocationsID], [MiscItemsLocationsQty]) VALUES (N'I012', N'L001', 1)
GO
INSERT [dbo].[MiscItemsLocations] ([MiscItemsID], [LocationsID], [MiscItemsLocationsQty]) VALUES (N'I013', N'L001', 9)
GO
INSERT [dbo].[MiscItemsLocations] ([MiscItemsID], [LocationsID], [MiscItemsLocationsQty]) VALUES (N'I013', N'L002', 12)
GO
INSERT [dbo].[MiscItemsLocations] ([MiscItemsID], [LocationsID], [MiscItemsLocationsQty]) VALUES (N'I013', N'L003', 7)
GO
INSERT [dbo].[MiscItemsLocations] ([MiscItemsID], [LocationsID], [MiscItemsLocationsQty]) VALUES (N'I013', N'L004', 6)
GO
INSERT [dbo].[MiscItemsLocations] ([MiscItemsID], [LocationsID], [MiscItemsLocationsQty]) VALUES (N'I013', N'L005', 5)
GO
INSERT [dbo].[MiscItemsLocations] ([MiscItemsID], [LocationsID], [MiscItemsLocationsQty]) VALUES (N'I014', N'L001', 2)
GO
INSERT [dbo].[MiscItemsLocations] ([MiscItemsID], [LocationsID], [MiscItemsLocationsQty]) VALUES (N'I014', N'L002', 2)
GO
INSERT [dbo].[MiscItemsLocations] ([MiscItemsID], [LocationsID], [MiscItemsLocationsQty]) VALUES (N'I014', N'L003', 1)
GO
INSERT [dbo].[MiscItemsLocations] ([MiscItemsID], [LocationsID], [MiscItemsLocationsQty]) VALUES (N'I014', N'L004', 1)
GO
INSERT [dbo].[MiscItemsLocations] ([MiscItemsID], [LocationsID], [MiscItemsLocationsQty]) VALUES (N'I015', N'L001', 2)
GO
INSERT [dbo].[MiscItemsLocations] ([MiscItemsID], [LocationsID], [MiscItemsLocationsQty]) VALUES (N'I015', N'L002', 2)
GO
INSERT [dbo].[MiscItemsLocations] ([MiscItemsID], [LocationsID], [MiscItemsLocationsQty]) VALUES (N'I015', N'L003', 1)
GO
INSERT [dbo].[MiscItemsLocations] ([MiscItemsID], [LocationsID], [MiscItemsLocationsQty]) VALUES (N'I015', N'L004', 1)
GO
INSERT [dbo].[PowerSource] ([PowerSourceID], [PowerSourceName], [PowerSourceUnits]) VALUES (N'E001', N'Solar', N'Sunlight')
GO
INSERT [dbo].[PowerSource] ([PowerSourceID], [PowerSourceName], [PowerSourceUnits]) VALUES (N'E002', N'Water', N'Flowing Water')
GO
INSERT [dbo].[PowerSource] ([PowerSourceID], [PowerSourceName], [PowerSourceUnits]) VALUES (N'E003', N'Combustion Generators', N'Gas')
GO
INSERT [dbo].[PowerSource] ([PowerSourceID], [PowerSourceName], [PowerSourceUnits]) VALUES (N'E004', N'Man-Powered Generator', N'Time')
GO
INSERT [dbo].[PowerSource] ([PowerSourceID], [PowerSourceName], [PowerSourceUnits]) VALUES (N'E005', N'Battery Power', N'Batteries')
GO
INSERT [dbo].[PowerSourceLocations] ([PowerSourceID], [LocationsID], [PowerSourceLocationsQty]) VALUES (N'E001', N'L001', 5)
GO
INSERT [dbo].[PowerSourceLocations] ([PowerSourceID], [LocationsID], [PowerSourceLocationsQty]) VALUES (N'E001', N'L004', 3)
GO
INSERT [dbo].[PowerSourceLocations] ([PowerSourceID], [LocationsID], [PowerSourceLocationsQty]) VALUES (N'E001', N'L005', 2)
GO
INSERT [dbo].[PowerSourceLocations] ([PowerSourceID], [LocationsID], [PowerSourceLocationsQty]) VALUES (N'E002', N'L001', 3)
GO
INSERT [dbo].[PowerSourceLocations] ([PowerSourceID], [LocationsID], [PowerSourceLocationsQty]) VALUES (N'E002', N'L002', 1)
GO
INSERT [dbo].[PowerSourceLocations] ([PowerSourceID], [LocationsID], [PowerSourceLocationsQty]) VALUES (N'E002', N'L005', 1)
GO
INSERT [dbo].[PowerSourceLocations] ([PowerSourceID], [LocationsID], [PowerSourceLocationsQty]) VALUES (N'E003', N'L001', 7)
GO
INSERT [dbo].[PowerSourceLocations] ([PowerSourceID], [LocationsID], [PowerSourceLocationsQty]) VALUES (N'E003', N'L002', 3)
GO
INSERT [dbo].[PowerSourceLocations] ([PowerSourceID], [LocationsID], [PowerSourceLocationsQty]) VALUES (N'E003', N'L003', 2)
GO
INSERT [dbo].[PowerSourceLocations] ([PowerSourceID], [LocationsID], [PowerSourceLocationsQty]) VALUES (N'E003', N'L004', 4)
GO
INSERT [dbo].[PowerSourceLocations] ([PowerSourceID], [LocationsID], [PowerSourceLocationsQty]) VALUES (N'E003', N'L005', 5)
GO
INSERT [dbo].[PowerSourceLocations] ([PowerSourceID], [LocationsID], [PowerSourceLocationsQty]) VALUES (N'E004', N'L001', 2)
GO
INSERT [dbo].[PowerSourceLocations] ([PowerSourceID], [LocationsID], [PowerSourceLocationsQty]) VALUES (N'E004', N'L003', 1)
GO
INSERT [dbo].[PowerSourceLocations] ([PowerSourceID], [LocationsID], [PowerSourceLocationsQty]) VALUES (N'E004', N'L004', 1)
GO
INSERT [dbo].[PowerSourceLocations] ([PowerSourceID], [LocationsID], [PowerSourceLocationsQty]) VALUES (N'E005', N'L001', 561)
GO
INSERT [dbo].[PowerSourceLocations] ([PowerSourceID], [LocationsID], [PowerSourceLocationsQty]) VALUES (N'E005', N'L002', 254)
GO
INSERT [dbo].[PowerSourceLocations] ([PowerSourceID], [LocationsID], [PowerSourceLocationsQty]) VALUES (N'E005', N'L003', 184)
GO
INSERT [dbo].[PowerSourceLocations] ([PowerSourceID], [LocationsID], [PowerSourceLocationsQty]) VALUES (N'E005', N'L004', 87)
GO
INSERT [dbo].[PowerSourceLocations] ([PowerSourceID], [LocationsID], [PowerSourceLocationsQty]) VALUES (N'E005', N'L005', 52)
GO
INSERT [dbo].[Resources] ([ResourcesID], [ResourcesDescription], [ResourcesExpiration], [ResourcesUnits], [CurrencyID], [ResourcesCurrencyCost]) VALUES (N'R001', N'Standard granola bar', CAST(N'2023-12-05' AS Date), N'Bar', N'C002', 1)
GO
INSERT [dbo].[Resources] ([ResourcesID], [ResourcesDescription], [ResourcesExpiration], [ResourcesUnits], [CurrencyID], [ResourcesCurrencyCost]) VALUES (N'R002', N'Chocolate granola bar', CAST(N'2023-12-05' AS Date), N'Bar', N'C002', 1)
GO
INSERT [dbo].[Resources] ([ResourcesID], [ResourcesDescription], [ResourcesExpiration], [ResourcesUnits], [CurrencyID], [ResourcesCurrencyCost]) VALUES (N'R003', N'Berry granola bar', CAST(N'2023-12-05' AS Date), N'Bar', N'C002', 1)
GO
INSERT [dbo].[Resources] ([ResourcesID], [ResourcesDescription], [ResourcesExpiration], [ResourcesUnits], [CurrencyID], [ResourcesCurrencyCost]) VALUES (N'R004', N'Chicken noodle soup', CAST(N'2025-06-15' AS Date), N'Can', N'C002', 3)
GO
INSERT [dbo].[Resources] ([ResourcesID], [ResourcesDescription], [ResourcesExpiration], [ResourcesUnits], [CurrencyID], [ResourcesCurrencyCost]) VALUES (N'R005', N'Tomato soup', CAST(N'2025-06-15' AS Date), N'Can', N'C002', 3)
GO
INSERT [dbo].[Resources] ([ResourcesID], [ResourcesDescription], [ResourcesExpiration], [ResourcesUnits], [CurrencyID], [ResourcesCurrencyCost]) VALUES (N'R006', N'Chicken wild rice soup', CAST(N'2025-06-15' AS Date), N'Can', N'C002', 3)
GO
INSERT [dbo].[Resources] ([ResourcesID], [ResourcesDescription], [ResourcesExpiration], [ResourcesUnits], [CurrencyID], [ResourcesCurrencyCost]) VALUES (N'R007', N'Clam chowder soup', CAST(N'2025-06-15' AS Date), N'Can', N'C002', 3)
GO
INSERT [dbo].[Resources] ([ResourcesID], [ResourcesDescription], [ResourcesExpiration], [ResourcesUnits], [CurrencyID], [ResourcesCurrencyCost]) VALUES (N'R008', N'Spam', CAST(N'2026-07-29' AS Date), N'Can', N'C002', 4)
GO
INSERT [dbo].[Resources] ([ResourcesID], [ResourcesDescription], [ResourcesExpiration], [ResourcesUnits], [CurrencyID], [ResourcesCurrencyCost]) VALUES (N'R009', N'Tuna in a can', CAST(N'2025-03-12' AS Date), N'Can', N'C002', 4)
GO
INSERT [dbo].[Resources] ([ResourcesID], [ResourcesDescription], [ResourcesExpiration], [ResourcesUnits], [CurrencyID], [ResourcesCurrencyCost]) VALUES (N'R010', N'Beef hash', CAST(N'2026-05-22' AS Date), N'Can', N'C002', 4)
GO
INSERT [dbo].[Resources] ([ResourcesID], [ResourcesDescription], [ResourcesExpiration], [ResourcesUnits], [CurrencyID], [ResourcesCurrencyCost]) VALUES (N'R011', N'Chicken breast in a can', CAST(N'2027-08-30' AS Date), N'Can', N'C002', 4)
GO
INSERT [dbo].[Resources] ([ResourcesID], [ResourcesDescription], [ResourcesExpiration], [ResourcesUnits], [CurrencyID], [ResourcesCurrencyCost]) VALUES (N'R012', N'Chicken Breast', CAST(N'2023-10-17' AS Date), N'Piece', N'C002', 6)
GO
INSERT [dbo].[Resources] ([ResourcesID], [ResourcesDescription], [ResourcesExpiration], [ResourcesUnits], [CurrencyID], [ResourcesCurrencyCost]) VALUES (N'R013', N'Black beans', CAST(N'2024-11-12' AS Date), N'Jar', N'C002', 2)
GO
INSERT [dbo].[Resources] ([ResourcesID], [ResourcesDescription], [ResourcesExpiration], [ResourcesUnits], [CurrencyID], [ResourcesCurrencyCost]) VALUES (N'R014', N'Kidney beans', CAST(N'2025-12-22' AS Date), N'Jar', N'C002', 2)
GO
INSERT [dbo].[Resources] ([ResourcesID], [ResourcesDescription], [ResourcesExpiration], [ResourcesUnits], [CurrencyID], [ResourcesCurrencyCost]) VALUES (N'R015', N'Garbanzo beans', CAST(N'2026-07-12' AS Date), N'Jar', N'C002', 2)
GO
INSERT [dbo].[Resources] ([ResourcesID], [ResourcesDescription], [ResourcesExpiration], [ResourcesUnits], [CurrencyID], [ResourcesCurrencyCost]) VALUES (N'R016', N'Peanut butter', CAST(N'2024-04-01' AS Date), N'Jar', N'C002', 3)
GO
INSERT [dbo].[Resources] ([ResourcesID], [ResourcesDescription], [ResourcesExpiration], [ResourcesUnits], [CurrencyID], [ResourcesCurrencyCost]) VALUES (N'R017', N'Powdered milk', CAST(N'2028-05-17' AS Date), N'Box', N'C002', 2)
GO
INSERT [dbo].[Resources] ([ResourcesID], [ResourcesDescription], [ResourcesExpiration], [ResourcesUnits], [CurrencyID], [ResourcesCurrencyCost]) VALUES (N'R018', N'Dried mango', CAST(N'2023-08-14' AS Date), N'Bag', N'C002', 4)
GO
INSERT [dbo].[Resources] ([ResourcesID], [ResourcesDescription], [ResourcesExpiration], [ResourcesUnits], [CurrencyID], [ResourcesCurrencyCost]) VALUES (N'R019', N'Raisin', CAST(N'2023-07-12' AS Date), N'Bag', N'C002', 4)
GO
INSERT [dbo].[Resources] ([ResourcesID], [ResourcesDescription], [ResourcesExpiration], [ResourcesUnits], [CurrencyID], [ResourcesCurrencyCost]) VALUES (N'R020', N'Dried peaches', CAST(N'2023-11-11' AS Date), N'Bag', N'C002', 4)
GO
INSERT [dbo].[Resources] ([ResourcesID], [ResourcesDescription], [ResourcesExpiration], [ResourcesUnits], [CurrencyID], [ResourcesCurrencyCost]) VALUES (N'R021', N'Dried pineapple', CAST(N'2023-09-29' AS Date), N'Bag', N'C002', 4)
GO
INSERT [dbo].[Resources] ([ResourcesID], [ResourcesDescription], [ResourcesExpiration], [ResourcesUnits], [CurrencyID], [ResourcesCurrencyCost]) VALUES (N'R022', N'Onion', CAST(N'2023-12-20' AS Date), N'Item', N'C002', 2)
GO
INSERT [dbo].[Resources] ([ResourcesID], [ResourcesDescription], [ResourcesExpiration], [ResourcesUnits], [CurrencyID], [ResourcesCurrencyCost]) VALUES (N'R023', N'Canned beets', CAST(N'2026-04-05' AS Date), N'Can', N'C002', 3)
GO
INSERT [dbo].[Resources] ([ResourcesID], [ResourcesDescription], [ResourcesExpiration], [ResourcesUnits], [CurrencyID], [ResourcesCurrencyCost]) VALUES (N'R024', N'Canned carrots', CAST(N'2027-01-08' AS Date), N'Can', N'C002', 2)
GO
INSERT [dbo].[Resources] ([ResourcesID], [ResourcesDescription], [ResourcesExpiration], [ResourcesUnits], [CurrencyID], [ResourcesCurrencyCost]) VALUES (N'R025', N'Canned tomato', CAST(N'2025-06-30' AS Date), N'Can', N'C002', 4)
GO
INSERT [dbo].[Resources] ([ResourcesID], [ResourcesDescription], [ResourcesExpiration], [ResourcesUnits], [CurrencyID], [ResourcesCurrencyCost]) VALUES (N'R026', N'Tomato sauce', CAST(N'2024-08-01' AS Date), N'Jar', N'C002', 3)
GO
INSERT [dbo].[Resources] ([ResourcesID], [ResourcesDescription], [ResourcesExpiration], [ResourcesUnits], [CurrencyID], [ResourcesCurrencyCost]) VALUES (N'R027', N'Spray cheese', CAST(N'2024-12-31' AS Date), N'Can', N'C002', 3)
GO
INSERT [dbo].[Resources] ([ResourcesID], [ResourcesDescription], [ResourcesExpiration], [ResourcesUnits], [CurrencyID], [ResourcesCurrencyCost]) VALUES (N'R028', N'Canned peas', CAST(N'2026-10-28' AS Date), N'Can', N'C002', 3)
GO
INSERT [dbo].[Resources] ([ResourcesID], [ResourcesDescription], [ResourcesExpiration], [ResourcesUnits], [CurrencyID], [ResourcesCurrencyCost]) VALUES (N'R029', N'Canned corn', CAST(N'2025-05-15' AS Date), N'Can', N'C002', 3)
GO
INSERT [dbo].[Resources] ([ResourcesID], [ResourcesDescription], [ResourcesExpiration], [ResourcesUnits], [CurrencyID], [ResourcesCurrencyCost]) VALUES (N'R030', N'Strawberry jelly', CAST(N'2024-04-10' AS Date), N'Jar', N'C002', 3)
GO
INSERT [dbo].[Resources] ([ResourcesID], [ResourcesDescription], [ResourcesExpiration], [ResourcesUnits], [CurrencyID], [ResourcesCurrencyCost]) VALUES (N'R031', N'Grape jelly', CAST(N'2024-02-24' AS Date), N'Jar', N'C002', 3)
GO
INSERT [dbo].[Resources] ([ResourcesID], [ResourcesDescription], [ResourcesExpiration], [ResourcesUnits], [CurrencyID], [ResourcesCurrencyCost]) VALUES (N'R032', N'Raspberry jelly', CAST(N'2024-03-16' AS Date), N'Jar', N'C002', 3)
GO
INSERT [dbo].[Resources] ([ResourcesID], [ResourcesDescription], [ResourcesExpiration], [ResourcesUnits], [CurrencyID], [ResourcesCurrencyCost]) VALUES (N'R033', N'Ketchup', CAST(N'2024-12-01' AS Date), N'Bottle', N'C002', 2)
GO
INSERT [dbo].[Resources] ([ResourcesID], [ResourcesDescription], [ResourcesExpiration], [ResourcesUnits], [CurrencyID], [ResourcesCurrencyCost]) VALUES (N'R034', N'Mayo', CAST(N'2024-12-15' AS Date), N'Bottle', N'C002', 2)
GO
INSERT [dbo].[Resources] ([ResourcesID], [ResourcesDescription], [ResourcesExpiration], [ResourcesUnits], [CurrencyID], [ResourcesCurrencyCost]) VALUES (N'R035', N'BBQ sauce', CAST(N'2025-02-13' AS Date), N'Bottle', N'C002', 2)
GO
INSERT [dbo].[Resources] ([ResourcesID], [ResourcesDescription], [ResourcesExpiration], [ResourcesUnits], [CurrencyID], [ResourcesCurrencyCost]) VALUES (N'R036', N'White rice', CAST(N'2024-08-28' AS Date), N'Box', N'C002', 4)
GO
INSERT [dbo].[Resources] ([ResourcesID], [ResourcesDescription], [ResourcesExpiration], [ResourcesUnits], [CurrencyID], [ResourcesCurrencyCost]) VALUES (N'R037', N'Spagetti noodles', CAST(N'2025-10-04' AS Date), N'Box', N'C002', 4)
GO
INSERT [dbo].[Resources] ([ResourcesID], [ResourcesDescription], [ResourcesExpiration], [ResourcesUnits], [CurrencyID], [ResourcesCurrencyCost]) VALUES (N'R038', N'Flour', CAST(N'2025-06-24' AS Date), N'Bag', N'C002', 5)
GO
INSERT [dbo].[Resources] ([ResourcesID], [ResourcesDescription], [ResourcesExpiration], [ResourcesUnits], [CurrencyID], [ResourcesCurrencyCost]) VALUES (N'R039', N'Yeast', CAST(N'2024-12-30' AS Date), N'Bag', N'C002', 5)
GO
INSERT [dbo].[Resources] ([ResourcesID], [ResourcesDescription], [ResourcesExpiration], [ResourcesUnits], [CurrencyID], [ResourcesCurrencyCost]) VALUES (N'R040', N'Oats', CAST(N'2025-09-23' AS Date), N'Bag', N'C002', 4)
GO
INSERT [dbo].[Resources] ([ResourcesID], [ResourcesDescription], [ResourcesExpiration], [ResourcesUnits], [CurrencyID], [ResourcesCurrencyCost]) VALUES (N'R041', N'Water bottle', CAST(N'2025-07-25' AS Date), N'Bottle', N'C002', 2)
GO
INSERT [dbo].[Resources] ([ResourcesID], [ResourcesDescription], [ResourcesExpiration], [ResourcesUnits], [CurrencyID], [ResourcesCurrencyCost]) VALUES (N'R042', N'Orange juice', CAST(N'2023-11-07' AS Date), N'Bottle', N'C002', 4)
GO
INSERT [dbo].[Resources] ([ResourcesID], [ResourcesDescription], [ResourcesExpiration], [ResourcesUnits], [CurrencyID], [ResourcesCurrencyCost]) VALUES (N'R043', N'Grape juice', CAST(N'2023-04-15' AS Date), N'Bottle', N'C002', 4)
GO
INSERT [dbo].[Resources] ([ResourcesID], [ResourcesDescription], [ResourcesExpiration], [ResourcesUnits], [CurrencyID], [ResourcesCurrencyCost]) VALUES (N'R044', N'Vodka', CAST(N'2030-02-10' AS Date), N'Bottle', N'C001', 2)
GO
INSERT [dbo].[Resources] ([ResourcesID], [ResourcesDescription], [ResourcesExpiration], [ResourcesUnits], [CurrencyID], [ResourcesCurrencyCost]) VALUES (N'R045', N'Beer', CAST(N'2023-09-09' AS Date), N'Can', N'C002', 6)
GO
INSERT [dbo].[Resources] ([ResourcesID], [ResourcesDescription], [ResourcesExpiration], [ResourcesUnits], [CurrencyID], [ResourcesCurrencyCost]) VALUES (N'R046', N'Lemon water', CAST(N'2024-04-29' AS Date), N'Sleeve', N'C002', 3)
GO
INSERT [dbo].[Resources] ([ResourcesID], [ResourcesDescription], [ResourcesExpiration], [ResourcesUnits], [CurrencyID], [ResourcesCurrencyCost]) VALUES (N'R047', N'Tea', CAST(N'2024-06-22' AS Date), N'Bag', N'C002', 3)
GO
INSERT [dbo].[Resources] ([ResourcesID], [ResourcesDescription], [ResourcesExpiration], [ResourcesUnits], [CurrencyID], [ResourcesCurrencyCost]) VALUES (N'R048', N'Coffee grounds', CAST(N'2023-07-08' AS Date), N'Can', N'C002', 7)
GO
INSERT [dbo].[Resources] ([ResourcesID], [ResourcesDescription], [ResourcesExpiration], [ResourcesUnits], [CurrencyID], [ResourcesCurrencyCost]) VALUES (N'R049', N'Pedialyte', CAST(N'2024-11-29' AS Date), N'Sleeve', N'C002', 2)
GO
INSERT [dbo].[Resources] ([ResourcesID], [ResourcesDescription], [ResourcesExpiration], [ResourcesUnits], [CurrencyID], [ResourcesCurrencyCost]) VALUES (N'R050', N'Gatorade', CAST(N'2025-02-12' AS Date), N'Sleeve', N'C002', 2)
GO
INSERT [dbo].[Resources] ([ResourcesID], [ResourcesDescription], [ResourcesExpiration], [ResourcesUnits], [CurrencyID], [ResourcesCurrencyCost]) VALUES (N'R051', N'Crackers', CAST(N'2024-01-28' AS Date), N'Box', N'C002', 2)
GO
INSERT [dbo].[Resources] ([ResourcesID], [ResourcesDescription], [ResourcesExpiration], [ResourcesUnits], [CurrencyID], [ResourcesCurrencyCost]) VALUES (N'R052', N'Sugar', CAST(N'2024-12-25' AS Date), N'Bag', N'C002', 3)
GO
INSERT [dbo].[Resources] ([ResourcesID], [ResourcesDescription], [ResourcesExpiration], [ResourcesUnits], [CurrencyID], [ResourcesCurrencyCost]) VALUES (N'R053', N'Brown Rice', CAST(N'2025-01-23' AS Date), N'Box', N'C002', 4)
GO
INSERT [dbo].[Resources] ([ResourcesID], [ResourcesDescription], [ResourcesExpiration], [ResourcesUnits], [CurrencyID], [ResourcesCurrencyCost]) VALUES (N'R054', N'Mixed Nuts', CAST(N'2026-08-25' AS Date), N'Jar', N'C002', 6)
GO
INSERT [dbo].[Resources] ([ResourcesID], [ResourcesDescription], [ResourcesExpiration], [ResourcesUnits], [CurrencyID], [ResourcesCurrencyCost]) VALUES (N'R055', N'Canned Baby Food', CAST(N'2025-04-18' AS Date), N'Jar', N'C002', 3)
GO
INSERT [dbo].[Resources] ([ResourcesID], [ResourcesDescription], [ResourcesExpiration], [ResourcesUnits], [CurrencyID], [ResourcesCurrencyCost]) VALUES (N'R056', N'Infant Formula', CAST(N'2023-07-08' AS Date), N'Can', N'C002', 8)
GO
INSERT [dbo].[Resources] ([ResourcesID], [ResourcesDescription], [ResourcesExpiration], [ResourcesUnits], [CurrencyID], [ResourcesCurrencyCost]) VALUES (N'R057', N'Dried Lentils', CAST(N'2025-12-01' AS Date), N'55 Gallon Drum', N'C001', 1)
GO
INSERT [dbo].[Resources] ([ResourcesID], [ResourcesDescription], [ResourcesExpiration], [ResourcesUnits], [CurrencyID], [ResourcesCurrencyCost]) VALUES (N'R058', N'Dried Chickpeas', CAST(N'2025-12-01' AS Date), N'55 Gallon Drum', N'C001', 1)
GO
INSERT [dbo].[Resources] ([ResourcesID], [ResourcesDescription], [ResourcesExpiration], [ResourcesUnits], [CurrencyID], [ResourcesCurrencyCost]) VALUES (N'R059', N'Dried Black Beans', CAST(N'2025-12-01' AS Date), N'55 Gallon Drum', N'C001', 1)
GO
INSERT [dbo].[Resources] ([ResourcesID], [ResourcesDescription], [ResourcesExpiration], [ResourcesUnits], [CurrencyID], [ResourcesCurrencyCost]) VALUES (N'R060', N'Dried Soy Beans', CAST(N'2025-12-01' AS Date), N'55 Gallon Drum', N'C001', 1)
GO
INSERT [dbo].[Resources] ([ResourcesID], [ResourcesDescription], [ResourcesExpiration], [ResourcesUnits], [CurrencyID], [ResourcesCurrencyCost]) VALUES (N'R061', N'Dried Kidney Beans', CAST(N'2025-12-01' AS Date), N'55 Gallon Drum', N'C001', 1)
GO
INSERT [dbo].[Resources] ([ResourcesID], [ResourcesDescription], [ResourcesExpiration], [ResourcesUnits], [CurrencyID], [ResourcesCurrencyCost]) VALUES (N'R062', N'Dried Pinto Beans', CAST(N'2025-12-01' AS Date), N'55 Gallon Drum', N'C001', 1)
GO
INSERT [dbo].[Resources] ([ResourcesID], [ResourcesDescription], [ResourcesExpiration], [ResourcesUnits], [CurrencyID], [ResourcesCurrencyCost]) VALUES (N'R063', N'Dried Fava Beans', CAST(N'2025-12-01' AS Date), N'55 Gallon Drum', N'C001', 1)
GO
INSERT [dbo].[Resources] ([ResourcesID], [ResourcesDescription], [ResourcesExpiration], [ResourcesUnits], [CurrencyID], [ResourcesCurrencyCost]) VALUES (N'R064', N'Canned Bacon', CAST(N'2025-05-18' AS Date), N'Can', N'C002', 3)
GO
INSERT [dbo].[Resources] ([ResourcesID], [ResourcesDescription], [ResourcesExpiration], [ResourcesUnits], [CurrencyID], [ResourcesCurrencyCost]) VALUES (N'R065', N'M and Ms', CAST(N'2024-02-23' AS Date), N'Bag', N'C002', 2)
GO
INSERT [dbo].[Resources] ([ResourcesID], [ResourcesDescription], [ResourcesExpiration], [ResourcesUnits], [CurrencyID], [ResourcesCurrencyCost]) VALUES (N'R066', N'Peanuts', CAST(N'2024-05-25' AS Date), N'Bag', N'C002', 3)
GO
INSERT [dbo].[Resources] ([ResourcesID], [ResourcesDescription], [ResourcesExpiration], [ResourcesUnits], [CurrencyID], [ResourcesCurrencyCost]) VALUES (N'R067', N'Butter', CAST(N'2023-12-23' AS Date), N'Tub', N'C002', 2)
GO
INSERT [dbo].[Resources] ([ResourcesID], [ResourcesDescription], [ResourcesExpiration], [ResourcesUnits], [CurrencyID], [ResourcesCurrencyCost]) VALUES (N'R068', N'Powdered eggs', CAST(N'2024-06-02' AS Date), N'Bag', N'C002', 4)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R001', N'L001', 275)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R001', N'L003', 210)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R001', N'L004', 310)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R002', N'L002', 122)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R002', N'L003', 375)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R002', N'L004', 210)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R002', N'L005', 300)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R003', N'L001', 276)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R003', N'L002', 211)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R003', N'L004', 299)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R003', N'L005', 230)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R004', N'L001', 145)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R004', N'L002', 123)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R004', N'L003', 120)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R004', N'L004', 210)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R004', N'L005', 199)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R005', N'L002', 140)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R005', N'L003', 175)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R005', N'L004', 132)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R005', N'L005', 210)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R006', N'L001', 123)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R006', N'L002', 145)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R006', N'L004', 200)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R007', N'L003', 250)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R007', N'L004', 275)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R007', N'L005', 120)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R008', N'L001', 412)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R008', N'L002', 380)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R008', N'L003', 450)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R008', N'L004', 511)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R008', N'L005', 276)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R009', N'L003', 245)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R009', N'L004', 312)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R009', N'L005', 412)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R010', N'L001', 415)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R010', N'L002', 399)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R011', N'L001', 332)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R011', N'L002', 415)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R011', N'L003', 702)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R011', N'L004', 157)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R011', N'L005', 222)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R012', N'L001', 175)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R012', N'L002', 200)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R012', N'L003', 72)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R012', N'L004', 315)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R012', N'L005', 367)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R013', N'L001', 45)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R013', N'L004', 27)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R013', N'L005', 18)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R014', N'L002', 15)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R014', N'L003', 29)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R014', N'L004', 12)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R015', N'L001', 8)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R015', N'L005', 12)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R016', N'L001', 8)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R016', N'L002', 15)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R016', N'L003', 7)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R016', N'L004', 32)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R016', N'L005', 9)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R017', N'L001', 15)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R017', N'L002', 22)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R017', N'L003', 31)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R017', N'L004', 12)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R017', N'L005', 33)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R018', N'L003', 12)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R018', N'L005', 17)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R019', N'L001', 55)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R019', N'L002', 34)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R019', N'L004', 17)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R019', N'L005', 55)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R020', N'L001', 12)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R020', N'L002', 2)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R020', N'L004', 25)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R021', N'L004', 12)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R021', N'L005', 23)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R022', N'L001', 76)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R022', N'L002', 88)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R022', N'L003', 65)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R022', N'L004', 87)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R022', N'L005', 98)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R023', N'L003', 54)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R024', N'L001', 94)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R024', N'L002', 76)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R024', N'L004', 82)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R024', N'L005', 91)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R025', N'L002', 87)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R025', N'L003', 123)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R025', N'L005', 102)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R026', N'L001', 10)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R026', N'L002', 15)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R026', N'L004', 39)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R027', N'L001', 15)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R027', N'L003', 19)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R027', N'L005', 40)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R028', N'L001', 79)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R028', N'L002', 88)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R028', N'L003', 103)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R028', N'L004', 98)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R028', N'L005', 134)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R029', N'L001', 145)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R029', N'L002', 132)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R029', N'L003', 210)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R029', N'L004', 178)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R029', N'L005', 88)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R030', N'L001', 45)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R030', N'L002', 32)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R031', N'L003', 55)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R031', N'L004', 24)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R032', N'L005', 65)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R033', N'L001', 10)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R033', N'L002', 12)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R033', N'L004', 17)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R033', N'L005', 22)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R034', N'L002', 12)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R034', N'L003', 16)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R034', N'L004', 34)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R035', N'L001', 8)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R035', N'L003', 5)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R035', N'L005', 3)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R036', N'L001', 89)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R036', N'L002', 67)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R036', N'L003', 78)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R036', N'L004', 120)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R036', N'L005', 132)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R037', N'L001', 44)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R037', N'L002', 75)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R037', N'L004', 56)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R038', N'L001', 44)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R038', N'L002', 32)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R038', N'L003', 24)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R038', N'L004', 22)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R038', N'L005', 29)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R039', N'L001', 22)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R039', N'L002', 15)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R039', N'L003', 19)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R039', N'L004', 5)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R039', N'L005', 11)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R040', N'L003', 33)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R040', N'L004', 23)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R040', N'L005', 42)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R041', N'L001', 515)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R041', N'L002', 769)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R041', N'L003', 654)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R041', N'L004', 1054)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R041', N'L005', 876)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R042', N'L001', 15)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R042', N'L003', 17)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R042', N'L004', 22)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R043', N'L002', 21)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R043', N'L005', 14)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R044', N'L001', 5)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R044', N'L002', 12)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R044', N'L005', 3)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R045', N'L003', 120)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R045', N'L004', 144)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R045', N'L005', 96)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R046', N'L002', 46)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R046', N'L004', 32)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R047', N'L001', 145)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R047', N'L003', 210)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R048', N'L002', 43)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R048', N'L004', 32)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R048', N'L005', 76)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R049', N'L003', 55)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R049', N'L005', 98)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R050', N'L001', 121)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R050', N'L002', 73)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R050', N'L004', 143)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R051', N'L001', 86)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R051', N'L002', 54)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R051', N'L003', 33)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R051', N'L004', 28)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R051', N'L005', 16)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R052', N'L001', 16)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R052', N'L002', 13)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R052', N'L003', 12)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R052', N'L004', 7)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R052', N'L005', 5)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R053', N'L001', 62)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R053', N'L002', 45)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R053', N'L003', 31)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R053', N'L004', 15)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R053', N'L005', 1)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R054', N'L001', 11)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R054', N'L002', 8)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R054', N'L003', 6)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R054', N'L004', 8)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R054', N'L005', 3)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R055', N'L001', 84)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R055', N'L002', 62)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R055', N'L003', 49)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R055', N'L004', 26)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R055', N'L005', 14)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R056', N'L001', 16)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R056', N'L002', 12)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R056', N'L003', 7)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R056', N'L004', 4)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R056', N'L005', 2)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R057', N'L001', 11)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R057', N'L002', 9)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R057', N'L003', 7)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R057', N'L004', 8)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R057', N'L005', 2)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R058', N'L001', 9)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R058', N'L002', 11)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R058', N'L003', 5)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R058', N'L004', 3)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R058', N'L005', 4)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R059', N'L001', 22)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R059', N'L002', 15)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R059', N'L003', 11)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R059', N'L004', 7)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R059', N'L005', 8)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R060', N'L001', 14)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R060', N'L002', 16)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R060', N'L003', 11)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R060', N'L004', 5)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R060', N'L005', 7)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R061', N'L001', 5)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R061', N'L002', 11)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R061', N'L003', 3)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R061', N'L004', 1)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R061', N'L005', 2)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R062', N'L001', 13)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R062', N'L002', 10)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R062', N'L003', 7)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R062', N'L004', 8)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R062', N'L005', 5)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R063', N'L001', 24)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R063', N'L002', 28)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R063', N'L003', 18)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R063', N'L004', 11)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R063', N'L005', 8)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R064', N'L001', 55)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R064', N'L003', 123)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R064', N'L005', 96)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R065', N'L002', 44)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R065', N'L004', 32)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R065', N'L005', 105)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R066', N'L001', 54)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R066', N'L002', 75)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R066', N'L004', 23)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R066', N'L005', 45)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R067', N'L001', 55)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R067', N'L002', 44)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R067', N'L003', 32)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R067', N'L004', 10)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R067', N'L005', 75)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R068', N'L001', 55)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R068', N'L002', 44)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R068', N'L003', 32)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R068', N'L004', 76)
GO
INSERT [dbo].[ResourcesLocations] ([ResourcesID], [LocationsID], [ResourcesLocationsQty]) VALUES (N'R068', N'L005', 45)
GO
INSERT [dbo].[Skills] ([SkillsID], [SkillsDescription]) VALUES (N'S001', N'Nurse')
GO
INSERT [dbo].[Skills] ([SkillsID], [SkillsDescription]) VALUES (N'S002', N'Doctor')
GO
INSERT [dbo].[Skills] ([SkillsID], [SkillsDescription]) VALUES (N'S003', N'Carpenter')
GO
INSERT [dbo].[Skills] ([SkillsID], [SkillsDescription]) VALUES (N'S004', N'Handyman')
GO
INSERT [dbo].[Skills] ([SkillsID], [SkillsDescription]) VALUES (N'S005', N'Plumber')
GO
INSERT [dbo].[Skills] ([SkillsID], [SkillsDescription]) VALUES (N'S006', N'Electrician')
GO
INSERT [dbo].[Skills] ([SkillsID], [SkillsDescription]) VALUES (N'S007', N'Botanist')
GO
INSERT [dbo].[Skills] ([SkillsID], [SkillsDescription]) VALUES (N'S008', N'Cooking/Baking')
GO
INSERT [dbo].[Skills] ([SkillsID], [SkillsDescription]) VALUES (N'S009', N'Peacekeeper')
GO
INSERT [dbo].[Skills] ([SkillsID], [SkillsDescription]) VALUES (N'S010', N'Caregiver')
GO
INSERT [dbo].[Skills] ([SkillsID], [SkillsDescription]) VALUES (N'S011', N'Mechanic')
GO
INSERT [dbo].[Skills] ([SkillsID], [SkillsDescription]) VALUES (N'S012', N'Technology')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P001', N'Gary', N'Brown', N'M', CAST(N'1983-05-17' AS Date), N'L001')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P002', N'Jeffrey', N'Miller', N'M', CAST(N'2003-04-17' AS Date), N'L003')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P003', N'Robert', N'Alexander', N'M', CAST(N'1974-05-26' AS Date), N'L002')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P004', N'Brian', N'Miller', N'M', CAST(N'1997-11-30' AS Date), N'L003')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P005', N'Timothy', N'Roberts', N'M', CAST(N'1972-05-17' AS Date), N'L001')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P006', N'Andrew', N'Santiago', N'M', CAST(N'1969-01-10' AS Date), N'L002')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P007', N'Adrian', N'Diaz', N'M', CAST(N'1998-05-04' AS Date), N'L001')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P008', N'Scott', N'Porter', N'M', CAST(N'1985-09-04' AS Date), N'L001')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P009', N'Brandon', N'Simmons', N'M', CAST(N'2002-07-03' AS Date), N'L005')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P010', N'Steven', N'Fox', N'M', CAST(N'1957-12-22' AS Date), N'L003')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P011', N'Chris', N'Valenzuela', N'M', CAST(N'1995-09-10' AS Date), N'L002')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P012', N'Andrew', N'Bell', N'M', CAST(N'1962-06-21' AS Date), N'L004')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P013', N'Richard', N'Nolan', N'M', CAST(N'1995-12-18' AS Date), N'L001')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P014', N'Jeffrey', N'Beck', N'M', CAST(N'1989-08-14' AS Date), N'L002')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P015', N'Kyle', N'Clark', N'M', CAST(N'1982-07-27' AS Date), N'L003')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P016', N'Kenneth', N'Sanchez', N'M', CAST(N'1960-06-16' AS Date), N'L004')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P017', N'Gregory', N'Tucker', N'M', CAST(N'2001-05-31' AS Date), N'L003')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P018', N'Michael', N'Young', N'M', CAST(N'1963-03-31' AS Date), N'L001')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P019', N'Scott', N'Gutierrez', N'M', CAST(N'1961-03-30' AS Date), N'L001')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P020', N'Thomas', N'Ward', N'M', CAST(N'2003-01-09' AS Date), N'L003')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P021', N'Charles', N'Hernandez', N'M', CAST(N'1978-07-18' AS Date), N'L003')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P022', N'Bradley', N'Strong', N'M', CAST(N'1971-03-18' AS Date), N'L003')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P023', N'Matthew', N'Ramos', N'M', CAST(N'1958-04-03' AS Date), N'L002')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P024', N'Michael', N'Munoz', N'M', CAST(N'1968-04-11' AS Date), N'L003')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P025', N'Brian', N'Summers', N'M', CAST(N'1967-02-04' AS Date), N'L002')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P026', N'Keith', N'Ward', N'M', CAST(N'1989-08-04' AS Date), N'L004')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P027', N'James', N'Roberts', N'M', CAST(N'1999-07-29' AS Date), N'L003')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P028', N'Michael', N'Fuller', N'M', CAST(N'2004-05-19' AS Date), N'L003')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P029', N'Jeremy', N'Baker', N'M', CAST(N'1963-11-13' AS Date), N'L002')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P030', N'Thomas', N'Roberts', N'M', CAST(N'1981-05-24' AS Date), N'L001')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P031', N'Danny', N'Weiss', N'M', CAST(N'2000-01-28' AS Date), N'L001')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P032', N'Michael', N'Cox', N'M', CAST(N'1996-10-27' AS Date), N'L002')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P033', N'Joseph', N'Palmer', N'M', CAST(N'1977-04-07' AS Date), N'L001')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P034', N'Anthony', N'Stone', N'M', CAST(N'1969-11-07' AS Date), N'L002')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P035', N'Daniel', N'Andrews', N'M', CAST(N'1998-06-21' AS Date), N'L004')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P036', N'Michael', N'Williams', N'M', CAST(N'1986-01-31' AS Date), N'L003')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P037', N'Christopher', N'Richmond', N'M', CAST(N'2001-07-18' AS Date), N'L003')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P038', N'Aaron', N'Jones', N'M', CAST(N'1977-06-22' AS Date), N'L001')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P039', N'Andrew', N'Cox', N'M', CAST(N'1990-01-01' AS Date), N'L001')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P040', N'Todd', N'Porter', N'M', CAST(N'1988-06-30' AS Date), N'L005')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P041', N'Kevin', N'Harris', N'M', CAST(N'1988-10-07' AS Date), N'L002')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P042', N'Mathew', N'Vang', N'M', CAST(N'1975-03-26' AS Date), N'L003')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P043', N'John', N'Thomas', N'M', CAST(N'1980-08-16' AS Date), N'L001')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P044', N'Phillip', N'Mcclure', N'M', CAST(N'1966-04-28' AS Date), N'L001')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P045', N'Nathan', N'Scott', N'M', CAST(N'1962-01-01' AS Date), N'L001')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P046', N'Jonathan', N'Weaver', N'M', CAST(N'1959-03-29' AS Date), N'L002')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P047', N'Scott', N'Lee', N'M', CAST(N'1992-05-25' AS Date), N'L003')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P048', N'Joseph', N'Baxter', N'M', CAST(N'1986-01-04' AS Date), N'L002')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P049', N'Harold', N'Joseph', N'M', CAST(N'1978-06-09' AS Date), N'L001')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P050', N'Tyler', N'Davidson', N'M', CAST(N'2009-12-07' AS Date), N'L001')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P051', N'Daniel', N'Mcdaniel', N'M', CAST(N'2011-05-29' AS Date), N'L001')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P052', N'Erik', N'Monroe', N'M', CAST(N'2016-07-30' AS Date), N'L001')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P053', N'Barry', N'Gonzalez', N'M', CAST(N'2015-10-07' AS Date), N'L001')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P054', N'Mark', N'Kelley', N'M', CAST(N'2016-11-18' AS Date), N'L002')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P055', N'Austin', N'Barrett', N'M', CAST(N'2021-10-19' AS Date), N'L002')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P056', N'James', N'Hernandez', N'M', CAST(N'2010-01-30' AS Date), N'L003')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P057', N'William', N'Fields', N'M', CAST(N'2015-04-01' AS Date), N'L005')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P058', N'Erik', N'Allen', N'M', CAST(N'2019-02-21' AS Date), N'L005')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P059', N'Robert', N'Terry', N'M', CAST(N'2018-03-08' AS Date), N'L002')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P060', N'Adam', N'Guerra', N'M', CAST(N'2014-08-19' AS Date), N'L001')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P061', N'Kevin', N'Peters', N'M', CAST(N'2014-01-30' AS Date), N'L003')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P062', N'Austin', N'Curtis', N'M', CAST(N'2006-03-04' AS Date), N'L002')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P063', N'Collin', N'Estrada', N'M', CAST(N'2008-04-01' AS Date), N'L001')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P064', N'Alex', N'Dunn', N'M', CAST(N'2004-04-05' AS Date), N'L003')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P065', N'Willie', N'Dawson', N'M', CAST(N'2004-10-09' AS Date), N'L002')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P066', N'Douglas', N'Stout', N'M', CAST(N'2008-06-05' AS Date), N'L003')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P067', N'Kevin', N'Mitchell', N'M', CAST(N'2009-04-12' AS Date), N'L002')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P068', N'Philip', N'Kline', N'M', CAST(N'2007-03-12' AS Date), N'L004')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P069', N'David', N'Daniel', N'M', CAST(N'2009-11-22' AS Date), N'L005')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P070', N'Troy', N'Hall', N'M', CAST(N'2004-12-15' AS Date), N'L005')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P071', N'Douglas', N'Davis', N'M', CAST(N'2007-01-19' AS Date), N'L001')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P072', N'Mitchell', N'Martin', N'M', CAST(N'2007-07-13' AS Date), N'L001')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P073', N'Thomas', N'Brown', N'M', CAST(N'2009-04-25' AS Date), N'L005')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P074', N'Phillip', N'Fuentes', N'M', CAST(N'1943-11-20' AS Date), N'L002')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P075', N'Joseph', N'Davidson', N'M', CAST(N'1954-05-19' AS Date), N'L001')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P076', N'James', N'Warner', N'M', CAST(N'1925-11-12' AS Date), N'L001')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P077', N'Clayton', N'Cooper', N'M', CAST(N'1945-06-08' AS Date), N'L004')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P078', N'Michael', N'Davis', N'M', CAST(N'1956-05-03' AS Date), N'L002')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P079', N'Alan', N'Carey', N'M', CAST(N'1953-08-05' AS Date), N'L003')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P080', N'James', N'Johnson', N'M', CAST(N'1992-08-19' AS Date), N'L003')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P081', N'Caleb', N'Williams', N'M', CAST(N'1969-06-30' AS Date), N'L001')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P082', N'Timothy', N'Pearson', N'M', CAST(N'1969-06-30' AS Date), N'L001')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P083', N'Dustin', N'Jones', N'M', CAST(N'1967-10-09' AS Date), N'L002')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P084', N'Danny', N'Ray', N'M', CAST(N'1991-06-19' AS Date), N'L003')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P085', N'Keith', N'Clark', N'M', CAST(N'1991-08-08' AS Date), N'L002')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P086', N'Adam', N'Hernandez', N'M', CAST(N'1986-03-04' AS Date), N'L003')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P087', N'John', N'Mccarty', N'M', CAST(N'1968-08-31' AS Date), N'L001')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P088', N'Nicholas', N'Rowe', N'M', CAST(N'1994-03-05' AS Date), N'L001')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P089', N'Jared', N'Nunez', N'M', CAST(N'1992-06-27' AS Date), N'L004')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P090', N'Bobby', N'Johnson', N'M', CAST(N'1992-09-15' AS Date), N'L001')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P091', N'Walter', N'Taylor', N'M', CAST(N'1961-11-06' AS Date), N'L001')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P092', N'David', N'Levy', N'M', CAST(N'1957-05-31' AS Date), N'L004')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P093', N'Cole', N'Ellis', N'M', CAST(N'1959-06-13' AS Date), N'L002')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P094', N'Carlos', N'Rogers', N'M', CAST(N'1982-04-09' AS Date), N'L002')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P095', N'Patrick', N'Williams', N'M', CAST(N'1985-09-13' AS Date), N'L002')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P096', N'Edward', N'Williams', N'M', CAST(N'1965-03-27' AS Date), N'L003')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P097', N'Richard', N'Lyons', N'M', CAST(N'1981-06-25' AS Date), N'L002')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P098', N'Stephen', N'Garcia', N'M', CAST(N'1966-08-06' AS Date), N'L002')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P099', N'Eric', N'Johnson', N'M', CAST(N'1958-10-18' AS Date), N'L003')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P100', N'Benjamin', N'Martinez', N'M', CAST(N'2017-01-02' AS Date), N'L001')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P101', N'Joann', N'Gallegos', N'F', CAST(N'1967-07-08' AS Date), N'L004')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P102', N'Amy', N'Sanchez', N'F', CAST(N'2002-05-15' AS Date), N'L001')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P103', N'Melissa', N'Huff', N'F', CAST(N'1977-03-14' AS Date), N'L001')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P104', N'Marie', N'Davis', N'F', CAST(N'1968-02-20' AS Date), N'L001')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P105', N'Amanda', N'Howard', N'F', CAST(N'2003-09-22' AS Date), N'L001')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P106', N'Mary', N'Donaldson', N'F', CAST(N'2002-04-30' AS Date), N'L002')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P107', N'Shelia', N'Davis', N'F', CAST(N'1993-04-27' AS Date), N'L001')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P108', N'Jessica', N'Page', N'F', CAST(N'2003-04-12' AS Date), N'L002')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P109', N'Megan', N'Mcdonald', N'F', CAST(N'1999-11-10' AS Date), N'L004')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P110', N'Katie', N'Baker', N'F', CAST(N'1962-12-02' AS Date), N'L001')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P111', N'Michelle', N'Harrington', N'F', CAST(N'1999-12-11' AS Date), N'L003')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P112', N'Brandy', N'Griffith', N'F', CAST(N'1967-02-16' AS Date), N'L001')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P113', N'Rebecca', N'Ward', N'F', CAST(N'1977-02-17' AS Date), N'L002')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P114', N'Mary', N'Buchanan', N'F', CAST(N'1974-05-22' AS Date), N'L001')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P115', N'Stacy', N'Thomas', N'F', CAST(N'1963-12-15' AS Date), N'L001')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P116', N'Cheryl', N'Becker', N'F', CAST(N'2001-09-15' AS Date), N'L001')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P117', N'Chelsea', N'Potter', N'F', CAST(N'2000-08-08' AS Date), N'L001')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P118', N'Laura', N'Dennis', N'F', CAST(N'1995-01-26' AS Date), N'L001')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P119', N'Melissa', N'Thompson', N'F', CAST(N'1956-04-20' AS Date), N'L003')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P120', N'Kimberly', N'Perez', N'F', CAST(N'1970-12-01' AS Date), N'L002')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P121', N'Kelly', N'Cameron', N'F', CAST(N'1958-10-15' AS Date), N'L001')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P122', N'Emily', N'Smith', N'F', CAST(N'1979-12-04' AS Date), N'L003')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P123', N'Virginia', N'Hines', N'F', CAST(N'1960-07-20' AS Date), N'L002')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P124', N'Sheila', N'Peters', N'F', CAST(N'1964-08-30' AS Date), N'L001')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P125', N'Danielle', N'Rodriguez', N'F', CAST(N'1986-11-23' AS Date), N'L005')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P126', N'Janice', N'Singh', N'F', CAST(N'1961-08-09' AS Date), N'L005')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P127', N'Linda', N'Williams', N'F', CAST(N'1975-08-22' AS Date), N'L001')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P128', N'Kristy', N'Davis', N'F', CAST(N'1981-03-24' AS Date), N'L001')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P129', N'Kimberly', N'Garcia', N'F', CAST(N'1986-04-06' AS Date), N'L002')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P130', N'Melissa', N'Thomas', N'F', CAST(N'1964-04-20' AS Date), N'L003')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P131', N'Taylor', N'Martin', N'F', CAST(N'1966-09-26' AS Date), N'L002')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P132', N'Megan', N'Willis', N'F', CAST(N'1972-11-23' AS Date), N'L004')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P133', N'Katherine', N'Jones', N'F', CAST(N'1982-01-06' AS Date), N'L001')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P134', N'Amanda', N'Wagner', N'F', CAST(N'1981-06-27' AS Date), N'L001')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P135', N'Emily', N'Freeman', N'F', CAST(N'1965-01-29' AS Date), N'L001')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P136', N'Michelle', N'Williams', N'F', CAST(N'2000-05-17' AS Date), N'L002')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P137', N'Rebecca', N'Peterson', N'F', CAST(N'1993-04-29' AS Date), N'L003')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P138', N'Kari', N'Powell', N'F', CAST(N'1974-08-31' AS Date), N'L004')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P139', N'Shannon', N'Crane', N'F', CAST(N'1988-03-26' AS Date), N'L005')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P140', N'Stacey', N'Clark', N'F', CAST(N'1957-11-30' AS Date), N'L001')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P141', N'Lori', N'Edwards', N'F', CAST(N'1999-07-19' AS Date), N'L002')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P142', N'Lindsay', N'Werner', N'F', CAST(N'1999-01-05' AS Date), N'L005')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P143', N'Angela', N'Gonzalez', N'F', CAST(N'1980-07-15' AS Date), N'L004')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P144', N'Dawn', N'Norris', N'F', CAST(N'1996-09-12' AS Date), N'L005')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P145', N'Patricia', N'Perez', N'F', CAST(N'1997-05-16' AS Date), N'L005')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P146', N'Alexa', N'Maldonado', N'F', CAST(N'1980-01-06' AS Date), N'L001')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P147', N'Tammy', N'Garcia', N'F', CAST(N'1995-02-03' AS Date), N'L002')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P148', N'Heather', N'Ellis', N'F', CAST(N'1991-12-15' AS Date), N'L002')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P149', N'Margaret', N'Marks', N'F', CAST(N'1964-05-03' AS Date), N'L002')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P150', N'Elizabeth', N'Wallace', N'F', CAST(N'1977-12-26' AS Date), N'L002')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P151', N'Amanda', N'Perry', N'F', CAST(N'2016-04-13' AS Date), N'L004')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P152', N'Dana', N'Ballard', N'F', CAST(N'2019-07-24' AS Date), N'L003')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P153', N'Jordan', N'Keller', N'F', CAST(N'2018-02-01' AS Date), N'L003')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P154', N'Kristen', N'Terrell', N'F', CAST(N'2020-11-19' AS Date), N'L001')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P155', N'Tracy', N'Pope', N'F', CAST(N'2011-09-04' AS Date), N'L002')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P156', N'Mary', N'Hughes', N'F', CAST(N'2014-04-20' AS Date), N'L002')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P157', N'Michelle', N'Mccarthy', N'F', CAST(N'2020-07-26' AS Date), N'L004')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P158', N'Lisa', N'Brown', N'F', CAST(N'2012-12-10' AS Date), N'L001')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P159', N'Christine', N'Schaefer', N'F', CAST(N'2012-08-24' AS Date), N'L003')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P160', N'Kimberly', N'Liu', N'F', CAST(N'2018-08-25' AS Date), N'L001')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P161', N'Lauren', N'Knight', N'F', CAST(N'2014-04-13' AS Date), N'L001')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P162', N'Katie', N'Sullivan', N'F', CAST(N'2010-12-26' AS Date), N'L001')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P163', N'Cynthia', N'Oconnell', N'F', CAST(N'2004-08-18' AS Date), N'L001')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P164', N'Catherine', N'Jones', N'F', CAST(N'2009-09-08' AS Date), N'L002')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P165', N'Suzanne', N'Perkins', N'F', CAST(N'2006-11-05' AS Date), N'L003')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P166', N'Sheri', N'Ortiz', N'F', CAST(N'2006-11-02' AS Date), N'L001')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P167', N'Carrie', N'Allen', N'F', CAST(N'2007-10-03' AS Date), N'L003')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P168', N'Amanda', N'Garcia', N'F', CAST(N'2007-11-06' AS Date), N'L002')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P169', N'Tonya', N'Deleon', N'F', CAST(N'2003-03-29' AS Date), N'L002')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P170', N'Stephanie', N'Smith', N'F', CAST(N'2003-12-23' AS Date), N'L005')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P171', N'Jill', N'Landry', N'F', CAST(N'2004-12-07' AS Date), N'L001')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P172', N'Natalie', N'Owens', N'F', CAST(N'2005-12-27' AS Date), N'L001')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P173', N'Olivia', N'Johnson', N'F', CAST(N'2004-12-03' AS Date), N'L004')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P174', N'Sara', N'Mendez', N'F', CAST(N'2003-04-07' AS Date), N'L004')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P175', N'Jennifer', N'Alexander', N'F', CAST(N'1947-08-26' AS Date), N'L002')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P176', N'Marie', N'Williams', N'F', CAST(N'1948-09-10' AS Date), N'L005')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P177', N'Kristy', N'Santos', N'F', CAST(N'1953-10-21' AS Date), N'L001')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P178', N'Laura', N'Hill', N'F', CAST(N'1947-06-13' AS Date), N'L003')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P179', N'Kim', N'Reynolds', N'F', CAST(N'1931-05-31' AS Date), N'L003')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P180', N'Tammy', N'Levy', N'F', CAST(N'1948-10-16' AS Date), N'L001')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P181', N'Melissa', N'Crosby', N'F', CAST(N'2003-04-07' AS Date), N'L001')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P182', N'Karen', N'Knight', N'F', CAST(N'1987-03-13' AS Date), N'L002')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P183', N'Sheila', N'Palmer', N'F', CAST(N'1990-06-13' AS Date), N'L001')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P184', N'Christine', N'Davis', N'F', CAST(N'1960-07-04' AS Date), N'L003')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P185', N'Jennifer', N'Leblanc', N'F', CAST(N'1986-08-10' AS Date), N'L004')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P186', N'Peggy', N'Butler', N'F', CAST(N'1992-06-13' AS Date), N'L001')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P187', N'Ann', N'James', N'F', CAST(N'1966-06-06' AS Date), N'L003')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P188', N'Beth', N'Mills', N'F', CAST(N'1960-08-11' AS Date), N'L003')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P189', N'Samantha', N'Harris', N'F', CAST(N'1982-03-13' AS Date), N'L003')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P190', N'Elizabeth', N'Nguyen', N'F', CAST(N'1985-03-18' AS Date), N'L001')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P191', N'Veronica', N'Schaefer', N'F', CAST(N'1970-05-13' AS Date), N'L001')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P192', N'Angela', N'Stewart', N'F', CAST(N'1993-03-10' AS Date), N'L002')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P193', N'Margaret', N'Reeves', N'F', CAST(N'1995-12-03' AS Date), N'L005')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P194', N'Suzanne', N'French', N'F', CAST(N'1986-09-09' AS Date), N'L002')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P195', N'Kelsey', N'Reyes', N'F', CAST(N'1994-05-31' AS Date), N'L004')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P196', N'Mackenzie', N'Decker', N'F', CAST(N'1981-01-06' AS Date), N'L002')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P197', N'Patty', N'Marshall', N'F', CAST(N'1962-09-03' AS Date), N'L002')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P198', N'Barbara', N'Grimes', N'F', CAST(N'1959-11-02' AS Date), N'L001')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P199', N'Kelly', N'King', N'F', CAST(N'1959-07-10' AS Date), N'L005')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P200', N'Amy', N'Santos', N'F', CAST(N'1975-06-28' AS Date), N'L001')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P201', N'Darbi', N'Berkman', N'F', CAST(N'1992-01-04' AS Date), N'L001')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P202', N'Timothy', N'DeLong', N'M', CAST(N'1971-05-24' AS Date), N'L002')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P203', N'Jacob', N'Bedsted', N'M', CAST(N'1996-05-04' AS Date), N'L003')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P204', N'Zach', N'Dallum', N'M', CAST(N'1998-07-29' AS Date), N'L004')
GO
INSERT [dbo].[Survivors] ([SurvivorsID], [SurvivorsFirstName], [SurvivorsLastName], [SurvivorsGender], [SurvivorsDOB], [LocationsID]) VALUES (N'P205', N'Kim', N'Wudinich', N'F', CAST(N'1969-02-14' AS Date), N'L005')
GO
INSERT [dbo].[SurvivorsSkills] ([SurvivorsID], [SkillsID]) VALUES (N'P001', N'S006')
GO
INSERT [dbo].[SurvivorsSkills] ([SurvivorsID], [SkillsID]) VALUES (N'P003', N'S009')
GO
INSERT [dbo].[SurvivorsSkills] ([SurvivorsID], [SkillsID]) VALUES (N'P007', N'S004')
GO
INSERT [dbo].[SurvivorsSkills] ([SurvivorsID], [SkillsID]) VALUES (N'P008', N'S005')
GO
INSERT [dbo].[SurvivorsSkills] ([SurvivorsID], [SkillsID]) VALUES (N'P013', N'S008')
GO
INSERT [dbo].[SurvivorsSkills] ([SurvivorsID], [SkillsID]) VALUES (N'P017', N'S008')
GO
INSERT [dbo].[SurvivorsSkills] ([SurvivorsID], [SkillsID]) VALUES (N'P018', N'S005')
GO
INSERT [dbo].[SurvivorsSkills] ([SurvivorsID], [SkillsID]) VALUES (N'P022', N'S008')
GO
INSERT [dbo].[SurvivorsSkills] ([SurvivorsID], [SkillsID]) VALUES (N'P027', N'S010')
GO
INSERT [dbo].[SurvivorsSkills] ([SurvivorsID], [SkillsID]) VALUES (N'P032', N'S001')
GO
INSERT [dbo].[SurvivorsSkills] ([SurvivorsID], [SkillsID]) VALUES (N'P033', N'S010')
GO
INSERT [dbo].[SurvivorsSkills] ([SurvivorsID], [SkillsID]) VALUES (N'P036', N'S002')
GO
INSERT [dbo].[SurvivorsSkills] ([SurvivorsID], [SkillsID]) VALUES (N'P038', N'S011')
GO
INSERT [dbo].[SurvivorsSkills] ([SurvivorsID], [SkillsID]) VALUES (N'P039', N'S001')
GO
INSERT [dbo].[SurvivorsSkills] ([SurvivorsID], [SkillsID]) VALUES (N'P040', N'S008')
GO
INSERT [dbo].[SurvivorsSkills] ([SurvivorsID], [SkillsID]) VALUES (N'P041', N'S011')
GO
INSERT [dbo].[SurvivorsSkills] ([SurvivorsID], [SkillsID]) VALUES (N'P043', N'S009')
GO
INSERT [dbo].[SurvivorsSkills] ([SurvivorsID], [SkillsID]) VALUES (N'P044', N'S006')
GO
INSERT [dbo].[SurvivorsSkills] ([SurvivorsID], [SkillsID]) VALUES (N'P045', N'S004')
GO
INSERT [dbo].[SurvivorsSkills] ([SurvivorsID], [SkillsID]) VALUES (N'P049', N'S008')
GO
INSERT [dbo].[SurvivorsSkills] ([SurvivorsID], [SkillsID]) VALUES (N'P080', N'S004')
GO
INSERT [dbo].[SurvivorsSkills] ([SurvivorsID], [SkillsID]) VALUES (N'P081', N'S008')
GO
INSERT [dbo].[SurvivorsSkills] ([SurvivorsID], [SkillsID]) VALUES (N'P085', N'S003')
GO
INSERT [dbo].[SurvivorsSkills] ([SurvivorsID], [SkillsID]) VALUES (N'P088', N'S005')
GO
INSERT [dbo].[SurvivorsSkills] ([SurvivorsID], [SkillsID]) VALUES (N'P089', N'S004')
GO
INSERT [dbo].[SurvivorsSkills] ([SurvivorsID], [SkillsID]) VALUES (N'P096', N'S001')
GO
INSERT [dbo].[SurvivorsSkills] ([SurvivorsID], [SkillsID]) VALUES (N'P096', N'S004')
GO
INSERT [dbo].[SurvivorsSkills] ([SurvivorsID], [SkillsID]) VALUES (N'P098', N'S007')
GO
INSERT [dbo].[SurvivorsSkills] ([SurvivorsID], [SkillsID]) VALUES (N'P102', N'S007')
GO
INSERT [dbo].[SurvivorsSkills] ([SurvivorsID], [SkillsID]) VALUES (N'P103', N'S001')
GO
INSERT [dbo].[SurvivorsSkills] ([SurvivorsID], [SkillsID]) VALUES (N'P113', N'S001')
GO
INSERT [dbo].[SurvivorsSkills] ([SurvivorsID], [SkillsID]) VALUES (N'P128', N'S007')
GO
INSERT [dbo].[SurvivorsSkills] ([SurvivorsID], [SkillsID]) VALUES (N'P137', N'S004')
GO
INSERT [dbo].[SurvivorsSkills] ([SurvivorsID], [SkillsID]) VALUES (N'P144', N'S008')
GO
INSERT [dbo].[SurvivorsSkills] ([SurvivorsID], [SkillsID]) VALUES (N'P145', N'S008')
GO
INSERT [dbo].[SurvivorsSkills] ([SurvivorsID], [SkillsID]) VALUES (N'P185', N'S001')
GO
INSERT [dbo].[SurvivorsSkills] ([SurvivorsID], [SkillsID]) VALUES (N'P186', N'S004')
GO
INSERT [dbo].[SurvivorsSkills] ([SurvivorsID], [SkillsID]) VALUES (N'P187', N'S010')
GO
INSERT [dbo].[SurvivorsSkills] ([SurvivorsID], [SkillsID]) VALUES (N'P189', N'S011')
GO
INSERT [dbo].[SurvivorsSkills] ([SurvivorsID], [SkillsID]) VALUES (N'P191', N'S008')
GO
INSERT [dbo].[SurvivorsSkills] ([SurvivorsID], [SkillsID]) VALUES (N'P195', N'S007')
GO
INSERT [dbo].[SurvivorsSkills] ([SurvivorsID], [SkillsID]) VALUES (N'P196', N'S002')
GO
INSERT [dbo].[SurvivorsSkills] ([SurvivorsID], [SkillsID]) VALUES (N'P201', N'S012')
GO
INSERT [dbo].[SurvivorsSkills] ([SurvivorsID], [SkillsID]) VALUES (N'P202', N'S012')
GO
INSERT [dbo].[SurvivorsSkills] ([SurvivorsID], [SkillsID]) VALUES (N'P203', N'S012')
GO
INSERT [dbo].[SurvivorsSkills] ([SurvivorsID], [SkillsID]) VALUES (N'P204', N'S012')
GO
INSERT [dbo].[SurvivorsSkills] ([SurvivorsID], [SkillsID]) VALUES (N'P205', N'S012')
GO
INSERT [dbo].[Transportation] ([TransportationID], [TransportationName], [TransportationDescription], [TransportationCapacity]) VALUES (N'T001', N'Standard Scooter', N'Typical scooter', 1)
GO
INSERT [dbo].[Transportation] ([TransportationID], [TransportationName], [TransportationDescription], [TransportationCapacity]) VALUES (N'T002', N'Fancy Scooter', N'Standard scooter with sweet flames on the side', 1)
GO
INSERT [dbo].[Transportation] ([TransportationID], [TransportationName], [TransportationDescription], [TransportationCapacity]) VALUES (N'T003', N'Bike', N'Typical bike', 1)
GO
INSERT [dbo].[Transportation] ([TransportationID], [TransportationName], [TransportationDescription], [TransportationCapacity]) VALUES (N'T004', N'Tandem Bike', N'Bike with 2 seats for twice the fun', 2)
GO
INSERT [dbo].[Transportation] ([TransportationID], [TransportationName], [TransportationDescription], [TransportationCapacity]) VALUES (N'T005', N'Learning Bike', N'Bike with training wheels for the not so talented bikers', 1)
GO
INSERT [dbo].[Transportation] ([TransportationID], [TransportationName], [TransportationDescription], [TransportationCapacity]) VALUES (N'T006', N'Dinghy', N'Small boat with paddles', 2)
GO
INSERT [dbo].[Transportation] ([TransportationID], [TransportationName], [TransportationDescription], [TransportationCapacity]) VALUES (N'T007', N'RollerBlades', N'Shoes with wheels made for getting stuff done', 1)
GO
INSERT [dbo].[Transportation] ([TransportationID], [TransportationName], [TransportationDescription], [TransportationCapacity]) VALUES (N'T008', N'Drift Trike', N'Three wheeled bike with small back tires that slide', 1)
GO
INSERT [dbo].[Transportation] ([TransportationID], [TransportationName], [TransportationDescription], [TransportationCapacity]) VALUES (N'T009', N'Unicycle', N'Not very useful but lots of fun', 1)
GO
INSERT [dbo].[Transportation] ([TransportationID], [TransportationName], [TransportationDescription], [TransportationCapacity]) VALUES (N'T010', N'Pedal Trolley', N'Trolley powered by users biking', 10)
GO
INSERT [dbo].[Transportation] ([TransportationID], [TransportationName], [TransportationDescription], [TransportationCapacity]) VALUES (N'T011', N'Skateboard', N'Board on four wheels made for danger', 1)
GO
INSERT [dbo].[Transportation] ([TransportationID], [TransportationName], [TransportationDescription], [TransportationCapacity]) VALUES (N'T012', N'Cycle Rickshaw', N'Pedal powered bike with large back for transporting items or people', 3)
GO
INSERT [dbo].[Transportation] ([TransportationID], [TransportationName], [TransportationDescription], [TransportationCapacity]) VALUES (N'T013', N'Ice Skates', N'Shoes with blades on the bottom to make ice transportaion faster', 1)
GO
INSERT [dbo].[Transportation] ([TransportationID], [TransportationName], [TransportationDescription], [TransportationCapacity]) VALUES (N'T014', N'Toboggan', N'Optimal downhill traveling tool, not so great any other time', 3)
GO
INSERT [dbo].[TransportationLocations] ([TransportationID], [LocationsID], [TransportationLocationsQty]) VALUES (N'T001', N'L001', 3)
GO
INSERT [dbo].[TransportationLocations] ([TransportationID], [LocationsID], [TransportationLocationsQty]) VALUES (N'T001', N'L002', 4)
GO
INSERT [dbo].[TransportationLocations] ([TransportationID], [LocationsID], [TransportationLocationsQty]) VALUES (N'T001', N'L003', 3)
GO
INSERT [dbo].[TransportationLocations] ([TransportationID], [LocationsID], [TransportationLocationsQty]) VALUES (N'T001', N'L004', 2)
GO
INSERT [dbo].[TransportationLocations] ([TransportationID], [LocationsID], [TransportationLocationsQty]) VALUES (N'T002', N'L003', 1)
GO
INSERT [dbo].[TransportationLocations] ([TransportationID], [LocationsID], [TransportationLocationsQty]) VALUES (N'T002', N'L005', 1)
GO
INSERT [dbo].[TransportationLocations] ([TransportationID], [LocationsID], [TransportationLocationsQty]) VALUES (N'T003', N'L001', 5)
GO
INSERT [dbo].[TransportationLocations] ([TransportationID], [LocationsID], [TransportationLocationsQty]) VALUES (N'T003', N'L002', 4)
GO
INSERT [dbo].[TransportationLocations] ([TransportationID], [LocationsID], [TransportationLocationsQty]) VALUES (N'T003', N'L003', 3)
GO
INSERT [dbo].[TransportationLocations] ([TransportationID], [LocationsID], [TransportationLocationsQty]) VALUES (N'T003', N'L004', 4)
GO
INSERT [dbo].[TransportationLocations] ([TransportationID], [LocationsID], [TransportationLocationsQty]) VALUES (N'T003', N'L005', 5)
GO
INSERT [dbo].[TransportationLocations] ([TransportationID], [LocationsID], [TransportationLocationsQty]) VALUES (N'T004', N'L003', 3)
GO
INSERT [dbo].[TransportationLocations] ([TransportationID], [LocationsID], [TransportationLocationsQty]) VALUES (N'T004', N'L004', 4)
GO
INSERT [dbo].[TransportationLocations] ([TransportationID], [LocationsID], [TransportationLocationsQty]) VALUES (N'T004', N'L005', 3)
GO
INSERT [dbo].[TransportationLocations] ([TransportationID], [LocationsID], [TransportationLocationsQty]) VALUES (N'T005', N'L001', 2)
GO
INSERT [dbo].[TransportationLocations] ([TransportationID], [LocationsID], [TransportationLocationsQty]) VALUES (N'T005', N'L004', 1)
GO
INSERT [dbo].[TransportationLocations] ([TransportationID], [LocationsID], [TransportationLocationsQty]) VALUES (N'T006', N'L001', 3)
GO
INSERT [dbo].[TransportationLocations] ([TransportationID], [LocationsID], [TransportationLocationsQty]) VALUES (N'T006', N'L002', 2)
GO
INSERT [dbo].[TransportationLocations] ([TransportationID], [LocationsID], [TransportationLocationsQty]) VALUES (N'T006', N'L003', 1)
GO
INSERT [dbo].[TransportationLocations] ([TransportationID], [LocationsID], [TransportationLocationsQty]) VALUES (N'T006', N'L004', 2)
GO
INSERT [dbo].[TransportationLocations] ([TransportationID], [LocationsID], [TransportationLocationsQty]) VALUES (N'T007', N'L002', 3)
GO
INSERT [dbo].[TransportationLocations] ([TransportationID], [LocationsID], [TransportationLocationsQty]) VALUES (N'T007', N'L003', 2)
GO
INSERT [dbo].[TransportationLocations] ([TransportationID], [LocationsID], [TransportationLocationsQty]) VALUES (N'T007', N'L005', 2)
GO
INSERT [dbo].[TransportationLocations] ([TransportationID], [LocationsID], [TransportationLocationsQty]) VALUES (N'T008', N'L005', 1)
GO
INSERT [dbo].[TransportationLocations] ([TransportationID], [LocationsID], [TransportationLocationsQty]) VALUES (N'T009', N'L001', 2)
GO
INSERT [dbo].[TransportationLocations] ([TransportationID], [LocationsID], [TransportationLocationsQty]) VALUES (N'T009', N'L004', 1)
GO
INSERT [dbo].[TransportationLocations] ([TransportationID], [LocationsID], [TransportationLocationsQty]) VALUES (N'T010', N'L001', 1)
GO
INSERT [dbo].[TransportationLocations] ([TransportationID], [LocationsID], [TransportationLocationsQty]) VALUES (N'T010', N'L002', 1)
GO
INSERT [dbo].[TransportationLocations] ([TransportationID], [LocationsID], [TransportationLocationsQty]) VALUES (N'T010', N'L003', 1)
GO
INSERT [dbo].[TransportationLocations] ([TransportationID], [LocationsID], [TransportationLocationsQty]) VALUES (N'T010', N'L004', 1)
GO
INSERT [dbo].[TransportationLocations] ([TransportationID], [LocationsID], [TransportationLocationsQty]) VALUES (N'T010', N'L005', 1)
GO
INSERT [dbo].[TransportationLocations] ([TransportationID], [LocationsID], [TransportationLocationsQty]) VALUES (N'T011', N'L001', 2)
GO
INSERT [dbo].[TransportationLocations] ([TransportationID], [LocationsID], [TransportationLocationsQty]) VALUES (N'T011', N'L002', 3)
GO
INSERT [dbo].[TransportationLocations] ([TransportationID], [LocationsID], [TransportationLocationsQty]) VALUES (N'T011', N'L004', 1)
GO
INSERT [dbo].[TransportationLocations] ([TransportationID], [LocationsID], [TransportationLocationsQty]) VALUES (N'T011', N'L005', 3)
GO
INSERT [dbo].[TransportationLocations] ([TransportationID], [LocationsID], [TransportationLocationsQty]) VALUES (N'T012', N'L001', 1)
GO
INSERT [dbo].[TransportationLocations] ([TransportationID], [LocationsID], [TransportationLocationsQty]) VALUES (N'T012', N'L003', 2)
GO
INSERT [dbo].[TransportationLocations] ([TransportationID], [LocationsID], [TransportationLocationsQty]) VALUES (N'T012', N'L004', 1)
GO
INSERT [dbo].[TransportationLocations] ([TransportationID], [LocationsID], [TransportationLocationsQty]) VALUES (N'T013', N'L001', 5)
GO
INSERT [dbo].[TransportationLocations] ([TransportationID], [LocationsID], [TransportationLocationsQty]) VALUES (N'T013', N'L002', 4)
GO
INSERT [dbo].[TransportationLocations] ([TransportationID], [LocationsID], [TransportationLocationsQty]) VALUES (N'T013', N'L003', 5)
GO
INSERT [dbo].[TransportationLocations] ([TransportationID], [LocationsID], [TransportationLocationsQty]) VALUES (N'T013', N'L004', 3)
GO
INSERT [dbo].[TransportationLocations] ([TransportationID], [LocationsID], [TransportationLocationsQty]) VALUES (N'T013', N'L005', 6)
GO
INSERT [dbo].[TransportationLocations] ([TransportationID], [LocationsID], [TransportationLocationsQty]) VALUES (N'T014', N'L003', 4)
GO
INSERT [dbo].[TransportationLocations] ([TransportationID], [LocationsID], [TransportationLocationsQty]) VALUES (N'T014', N'L004', 3)
GO
INSERT [dbo].[TransportationLocations] ([TransportationID], [LocationsID], [TransportationLocationsQty]) VALUES (N'T014', N'L005', 4)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W001', N'Shotgun - 10 Bore', N'C002', 10)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W002', N'Shotgun - 12 Bore', N'C002', 10)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W003', N'Shotgun - 16 Bore', N'C002', 10)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W004', N'Shotgun - 20 Bore', N'C002', 10)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W005', N'Shotgun - 28 Bore', N'C002', 10)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W006', N'Shotgun - .410 Bore', N'C002', 10)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W007', N'Handgun - .17 HMR', N'C002', 5)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W008', N'Handgun - .22 LR', N'C002', 5)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W009', N'Handgun - .22 WMR', N'C002', 5)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W010', N'Handgun - .32 H&R Magnum', N'C002', 5)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W011', N'Handgun - .38 Super', N'C002', 5)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W012', N'Handgun - .400 Cor-Bon', N'C002', 5)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W013', N'Handgun - .40 S&W', N'C002', 5)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W014', N'Handgun - .41 Magnum', N'C002', 5)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W015', N'Handgun - .450 SMG', N'C002', 5)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W016', N'Handgun - .460 Rowland', N'C002', 5)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W017', N'Handgun - .44 Special (+P)', N'C002', 5)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W018', N'Handgun - .50 GI', N'C002', 5)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W019', N'Handgun - .45 Long Colt (+P)', N'C002', 5)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W020', N'Handgun - .454 Casual', N'C002', 5)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W021', N'Handgun - .445 Supermag', N'C002', 5)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W022', N'Handgun - .44 Mad Max', N'C002', 5)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W023', N'Handgun - .475 Linebaugh', N'C002', 5)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W024', N'Handgun - .500 Wyoming Express', N'C002', 5)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W025', N'Handgun - .500 S&W Magnum', N'C002', 5)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W026', N'Long Rifle - .17 HMR', N'C002', 15)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W027', N'Long Rifle - .204 Ruger', N'C002', 15)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W028', N'Long Rifle - .224 Valkyrie', N'C002', 15)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W029', N'Long Rifle - 6 mm Creedmoor', N'C002', 15)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W030', N'Long Rifle - .264 Winchester Magnum', N'C002', 15)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W031', N'Long Rifle - 6.8 Remington SPC', N'C002', 15)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W032', N'Long Rifle - 7 mm Weatherby Magnum', N'C002', 15)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W033', N'Long Rifle - .308 Winchester', N'C002', 15)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W034', N'Long Rifle - .30 Nolster', N'C002', 15)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W035', N'Long Rifle - .300 PRC', N'C002', 15)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W036', N'Long Rifle - 9.3 * 62 mm Mauser', N'C002', 15)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W037', N'Long Rifle - .375 H&H Magnum', N'C002', 15)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W038', N'Long Rifle - .375 Weatherby Magnum', N'C002', 15)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W039', N'Long Rifle - .444', N'C002', 15)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W040', N'Long Rifle - .50 BMG', N'C002', 15)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W041', N'Knife - Aircrew Survival Egress Knife', N'C001', 50)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W042', N'Knife - M9 bayonet', N'C001', 50)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W043', N'Knife - M7 bayonet', N'C001', 50)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W044', N'Knife - M11 knife', N'C001', 50)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W045', N'Knife - OKC-S3 bayonet', N'C001', 50)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W046', N'Knife - Ka-Bar combat knife', N'C001', 50)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W047', N'Knife - Gerber Mark II dagger', N'C001', 50)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W048', N'Knife - Mk 3 knife', N'C001', 50)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W049', N'Knife - MPK knife', N'C001', 50)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W050', N'Knife - Strider SMF', N'C001', 50)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W051', N'Knife - SEAL Knife 2000', N'C001', 50)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W052', N'Knife - Tomahawk', N'C001', 50)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W053', N'Knife - Entrenching tool', N'C001', 50)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W054', N'AMMO - Shotgun - 10 Bore', N'C001', 1)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W055', N'AMMO - Shotgun - 12 Bore', N'C001', 1)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W056', N'AMMO - Shotgun - 16 Bore', N'C001', 1)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W057', N'AMMO - Shotgun - 20 Bore', N'C001', 1)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W058', N'AMMO - Shotgun - 28 Bore', N'C001', 1)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W059', N'AMMO - Shotgun - .410 Bore', N'C001', 1)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W060', N'AMMO - Handgun - .17 HMR', N'C001', 1)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W061', N'AMMO - Handgun - .22 LR', N'C001', 1)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W062', N'AMMO - Handgun - .22 WMR', N'C001', 1)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W063', N'AMMO - Handgun - .32 H&R Magnum', N'C001', 1)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W064', N'AMMO - Handgun - .38 Super', N'C001', 1)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W065', N'AMMO - Handgun - .400 Cor-Bon', N'C001', 1)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W066', N'AMMO - Handgun - .40 S&W', N'C001', 1)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W067', N'AMMO - Handgun - .41 Magnum', N'C001', 1)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W068', N'AMMO - Handgun - .450 SMG', N'C001', 1)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W069', N'AMMO - Handgun - .460 Rowland', N'C001', 1)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W070', N'AMMO - Handgun - .44 Special (+P)', N'C001', 1)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W071', N'AMMO - Handgun - .50 GI', N'C001', 1)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W072', N'AMMO - Handgun - .45 Long Colt (+P)', N'C001', 1)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W073', N'AMMO - Handgun - .454 Casual', N'C001', 1)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W074', N'AMMO - Handgun - .445 Supermag', N'C001', 1)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W075', N'AMMO - Handgun - .44 Mad Max', N'C001', 1)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W076', N'AMMO - Handgun - .475 Linebaugh', N'C001', 1)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W077', N'AMMO - Handgun - .500 Wyoming Express', N'C001', 1)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W078', N'AMMO - Handgun - .500 S&W Magnum', N'C001', 1)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W079', N'AMMO - Long Rifle - .17 HMR', N'C001', 1)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W080', N'AMMO - Long Rifle - .204 Ruger', N'C001', 1)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W081', N'AMMO - Long Rifle - .224 Valkyrie', N'C001', 1)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W082', N'AMMO - Long Rifle - 6 mm Creedmoor', N'C001', 1)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W083', N'AMMO - Long Rifle - .264 Winchester Magnum', N'C001', 1)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W084', N'AMMO - Long Rifle - 6.8 Remington SPC', N'C001', 1)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W085', N'AMMO - Long Rifle - 7 mm Weatherby Magnum', N'C001', 1)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W086', N'AMMO - Long Rifle - .308 Winchester', N'C001', 1)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W087', N'AMMO - Long Rifle - .30 Nolster', N'C001', 1)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W088', N'AMMO - Long Rifle - .300 PRC', N'C001', 1)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W089', N'AMMO - Long Rifle - 9.3 * 62 mm Mauser', N'C001', 1)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W090', N'AMMO - Long Rifle - .375 H&H Magnum', N'C001', 1)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W091', N'AMMO - Long Rifle - .375 Weatherby Magnum', N'C001', 1)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W092', N'AMMO - Long Rifle - .444', N'C001', 1)
GO
INSERT [dbo].[Weapons] ([WeaponsID], [WeaponsName], [CurrencyID], [WeaponsCost]) VALUES (N'W093', N'AMMO - Long Rifle - .50 BMG', N'C001', 1)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W001', N'L001', 13)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W001', N'L002', 9)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W001', N'L003', 7)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W001', N'L004', 3)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W001', N'L005', 3)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W002', N'L001', 9)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W002', N'L002', 6)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W002', N'L003', 5)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W002', N'L004', 2)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W002', N'L005', 2)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W003', N'L001', 20)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W003', N'L002', 14)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W003', N'L003', 12)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W003', N'L004', 5)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W003', N'L005', 4)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W004', N'L001', 5)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W004', N'L002', 4)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W004', N'L003', 2)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W004', N'L004', 2)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W004', N'L005', 12)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W005', N'L001', 8)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W005', N'L002', 7)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W005', N'L003', 3)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W005', N'L004', 3)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W005', N'L005', 6)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W006', N'L001', 4)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W006', N'L002', 3)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W006', N'L003', 1)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W006', N'L004', 1)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W006', N'L005', 23)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W007', N'L001', 15)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W007', N'L002', 13)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W007', N'L003', 5)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W007', N'L004', 5)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W007', N'L005', 9)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W008', N'L001', 6)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W008', N'L002', 5)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W008', N'L003', 2)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W008', N'L004', 2)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W008', N'L005', 28)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W009', N'L001', 19)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W009', N'L002', 16)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W009', N'L003', 7)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W009', N'L004', 6)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W009', N'L005', 4)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W010', N'L001', 3)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W010', N'L002', 2)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W010', N'L003', 1)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W010', N'L004', 0)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W010', N'L005', 7)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W011', N'L001', 5)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W011', N'L002', 4)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W011', N'L003', 2)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W011', N'L004', 2)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W011', N'L005', 8)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W012', N'L001', 6)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W012', N'L002', 5)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W012', N'L003', 2)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W012', N'L004', 2)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W012', N'L005', 15)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W013', N'L001', 10)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W013', N'L002', 9)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W013', N'L003', 0)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W013', N'L004', 3)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W013', N'L005', 6)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W014', N'L001', 4)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W014', N'L002', 4)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W014', N'L003', 2)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W014', N'L004', 1)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W014', N'L005', 16)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W015', N'L001', 11)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W015', N'L002', 9)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W015', N'L003', 4)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W015', N'L004', 3)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W015', N'L005', 11)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W016', N'L001', 8)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W016', N'L002', 7)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W016', N'L003', 3)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W016', N'L004', 2)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W016', N'L005', 10)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W017', N'L001', 7)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W017', N'L002', 6)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W017', N'L003', 0)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W017', N'L004', 2)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W017', N'L005', 34)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W018', N'L001', 23)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W018', N'L002', 19)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W018', N'L003', 8)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W018', N'L004', 7)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W018', N'L005', 41)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W019', N'L001', 28)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W019', N'L002', 23)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W019', N'L003', 10)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W019', N'L004', 9)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W019', N'L005', 11)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W020', N'L001', 7)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W020', N'L002', 6)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W020', N'L003', 3)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W020', N'L004', 2)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W020', N'L005', 3)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W021', N'L001', 2)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W021', N'L002', 2)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W021', N'L003', 0)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W021', N'L004', 0)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W021', N'L005', 16)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W022', N'L001', 11)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W022', N'L002', 9)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W022', N'L003', 4)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W022', N'L004', 4)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W022', N'L005', 24)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W023', N'L001', 17)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W023', N'L002', 14)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W023', N'L003', 6)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W023', N'L004', 5)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W023', N'L005', 19)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W024', N'L001', 13)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W024', N'L002', 11)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W024', N'L003', 5)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W024', N'L004', 4)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W024', N'L005', 9)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W025', N'L001', 6)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W025', N'L002', 5)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W025', N'L003', 2)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W025', N'L004', 2)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W025', N'L005', 6)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W026', N'L001', 4)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W026', N'L002', 3)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W026', N'L003', 1)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W026', N'L004', 1)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W026', N'L005', 11)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W027', N'L001', 8)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W027', N'L002', 7)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W027', N'L003', 3)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W027', N'L004', 2)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W027', N'L005', 11)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W028', N'L001', 8)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W028', N'L002', 6)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W028', N'L003', 3)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W028', N'L004', 2)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W028', N'L005', 8)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W029', N'L001', 5)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W029', N'L002', 4)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W029', N'L003', 2)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W029', N'L004', 2)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W029', N'L005', 8)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W030', N'L001', 6)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W030', N'L002', 5)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W030', N'L003', 2)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W030', N'L004', 2)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W030', N'L005', 14)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W031', N'L001', 10)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W031', N'L002', 8)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W031', N'L003', 3)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W031', N'L004', 3)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W031', N'L005', 9)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W032', N'L001', 6)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W032', N'L002', 5)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W032', N'L003', 2)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W032', N'L004', 2)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W032', N'L005', 23)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W033', N'L001', 16)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W033', N'L002', 13)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W033', N'L003', 6)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W033', N'L004', 5)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W033', N'L005', 13)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W034', N'L001', 9)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W034', N'L002', 7)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W034', N'L003', 3)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W034', N'L004', 3)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W034', N'L005', 6)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W035', N'L001', 4)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W035', N'L002', 3)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W035', N'L003', 0)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W035', N'L004', 1)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W035', N'L005', 5)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W036', N'L001', 3)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W036', N'L002', 3)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W036', N'L003', 1)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W036', N'L004', 1)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W036', N'L005', 19)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W037', N'L001', 13)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W037', N'L002', 11)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W037', N'L003', 5)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W037', N'L004', 4)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W037', N'L005', 4)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W038', N'L001', 3)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W038', N'L002', 2)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W038', N'L003', 1)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W038', N'L004', 1)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W038', N'L005', 8)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W039', N'L001', 6)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W039', N'L002', 5)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W039', N'L003', 2)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W039', N'L004', 2)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W039', N'L005', 8)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W040', N'L001', 5)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W040', N'L002', 4)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W040', N'L003', 2)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W040', N'L004', 2)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W040', N'L005', 15)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W041', N'L001', 10)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W041', N'L002', 8)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W041', N'L003', 4)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W041', N'L004', 3)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W041', N'L005', 23)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W042', N'L001', 16)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W042', N'L002', 13)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W042', N'L003', 6)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W042', N'L004', 5)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W042', N'L005', 28)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W043', N'L001', 19)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W043', N'L002', 16)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W043', N'L003', 7)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W043', N'L004', 6)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W043', N'L005', 6)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W044', N'L001', 4)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W044', N'L002', 3)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W044', N'L003', 1)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W044', N'L004', 1)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W044', N'L005', 14)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W045', N'L001', 10)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W045', N'L002', 8)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W045', N'L003', 3)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W045', N'L004', 3)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W045', N'L005', 4)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W046', N'L001', 3)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W046', N'L002', 3)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W046', N'L003', 1)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W046', N'L004', 1)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W046', N'L005', 10)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W047', N'L001', 7)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W047', N'L002', 6)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W047', N'L003', 3)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W047', N'L004', 2)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W047', N'L005', 10)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W048', N'L001', 7)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W048', N'L002', 5)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W048', N'L003', 2)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W048', N'L004', 2)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W048', N'L005', 20)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W049', N'L001', 13)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W049', N'L002', 11)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W049', N'L003', 5)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W049', N'L004', 4)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W049', N'L005', 5)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W050', N'L001', 4)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W050', N'L002', 3)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W050', N'L003', 1)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W050', N'L004', 1)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W050', N'L005', 11)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W051', N'L001', 8)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W051', N'L002', 6)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W051', N'L003', 3)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W051', N'L004', 2)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W051', N'L005', 12)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W052', N'L001', 8)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W052', N'L002', 7)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W052', N'L003', 3)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W052', N'L004', 3)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W052', N'L005', 16)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W053', N'L001', 11)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W053', N'L002', 9)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W053', N'L003', 4)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W053', N'L004', 4)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W053', N'L005', 4)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W054', N'L001', 3)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W054', N'L002', 2)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W054', N'L003', 1)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W054', N'L004', 1)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W054', N'L005', 0)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W055', N'L001', 9250)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W055', N'L002', 6250)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W055', N'L003', 5250)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W055', N'L004', 2250)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W055', N'L005', 2000)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W056', N'L001', 13690)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W056', N'L002', 9250)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W056', N'L003', 7770)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W056', N'L004', 3330)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W056', N'L005', 2960)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W057', N'L001', 6845)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W057', N'L002', 4625)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W057', N'L003', 3885)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W057', N'L004', 1665)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W057', N'L005', 1480)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W058', N'L001', 16650)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W058', N'L002', 11250)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W058', N'L003', 9450)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W058', N'L004', 4050)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W058', N'L005', 3600)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W059', N'L001', 9990)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W059', N'L002', 6750)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W059', N'L003', 5670)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W059', N'L004', 2430)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W059', N'L005', 2160)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W060', N'L001', 25345)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W060', N'L002', 17125)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W060', N'L003', 14385)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W060', N'L004', 6165)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W060', N'L005', 5480)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W061', N'L001', 9361)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W061', N'L002', 6325)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W061', N'L003', 5313)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W061', N'L004', 2277)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W061', N'L005', 2024)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W062', N'L001', 13690)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W062', N'L002', 9250)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W062', N'L003', 7770)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W062', N'L004', 3330)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W062', N'L005', 2960)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W063', N'L001', 7215)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W063', N'L002', 4875)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W063', N'L003', 4095)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W063', N'L004', 1755)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W063', N'L005', 1560)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W064', N'L001', 16761)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W064', N'L002', 11325)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W064', N'L003', 9513)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W064', N'L004', 4077)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W064', N'L005', 3624)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W065', N'L001', 11766)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W065', N'L002', 7950)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W065', N'L003', 6678)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W065', N'L004', 2862)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W065', N'L005', 2544)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W066', N'L001', 24198)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W066', N'L002', 16350)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W066', N'L003', 13734)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W066', N'L004', 5886)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W066', N'L005', 5232)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W067', N'L001', 5513)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W067', N'L002', 3725)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W067', N'L003', 3129)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W067', N'L004', 1341)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W067', N'L005', 1192)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W068', N'L001', 8214)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W068', N'L002', 5550)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W068', N'L003', 4662)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W068', N'L004', 1998)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W068', N'L005', 1776)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W069', N'L001', 10619)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W069', N'L002', 7175)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W069', N'L003', 6027)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W069', N'L004', 2583)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W069', N'L005', 2296)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W070', N'L001', 12765)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W070', N'L002', 8625)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W070', N'L003', 7245)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W070', N'L004', 3105)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W070', N'L005', 2760)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W071', N'L001', 11618)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W071', N'L002', 7850)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W071', N'L003', 6594)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W071', N'L004', 2826)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W071', N'L005', 2512)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W072', N'L001', 14097)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W072', N'L002', 9525)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W072', N'L003', 8001)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W072', N'L004', 3429)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W072', N'L005', 3048)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W073', N'L001', 8362)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W073', N'L002', 5650)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W073', N'L003', 4746)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W073', N'L004', 2034)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W073', N'L005', 1808)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W074', N'L001', 6808)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W074', N'L002', 4600)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W074', N'L003', 3864)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W074', N'L004', 1656)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W074', N'L005', 1472)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W075', N'L001', 11063)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W075', N'L002', 7475)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W075', N'L003', 6279)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W075', N'L004', 2691)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W075', N'L005', 2392)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W076', N'L001', 12654)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W076', N'L002', 8550)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W076', N'L003', 7182)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W076', N'L004', 3078)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W076', N'L005', 2736)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W077', N'L001', 7289)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W077', N'L002', 4925)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W077', N'L003', 4137)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W077', N'L004', 1773)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W077', N'L005', 1576)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W078', N'L001', 11766)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W078', N'L002', 7950)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W078', N'L003', 6678)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W078', N'L004', 2862)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W078', N'L005', 2544)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W079', N'L001', 4551)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W079', N'L002', 3075)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W079', N'L003', 2583)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W079', N'L004', 1107)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W079', N'L005', 984)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W080', N'L001', 19277)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W080', N'L002', 13025)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W080', N'L003', 10941)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W080', N'L004', 4689)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W080', N'L005', 4168)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W081', N'L001', 11877)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W081', N'L002', 8025)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W081', N'L003', 6741)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W081', N'L004', 2889)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W081', N'L005', 2568)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W082', N'L001', 7881)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W082', N'L002', 5325)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W082', N'L003', 4473)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W082', N'L004', 1917)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W082', N'L005', 1704)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W083', N'L001', 9287)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W083', N'L002', 6275)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W083', N'L003', 5271)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W083', N'L004', 2259)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W083', N'L005', 2008)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W084', N'L001', 8177)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W084', N'L002', 5525)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W084', N'L003', 4641)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W084', N'L004', 1989)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W084', N'L005', 1768)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W085', N'L001', 13542)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W085', N'L002', 9150)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W085', N'L003', 7686)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W085', N'L004', 3294)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W085', N'L005', 2928)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W086', N'L001', 24642)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W086', N'L002', 16650)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W086', N'L003', 13986)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W086', N'L004', 5994)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W086', N'L005', 5328)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W087', N'L001', 4514)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W087', N'L002', 3050)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W087', N'L003', 2562)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W087', N'L004', 1098)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W087', N'L005', 976)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W088', N'L001', 11507)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W088', N'L002', 7775)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W088', N'L003', 6531)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W088', N'L004', 2799)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W088', N'L005', 2488)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W089', N'L001', 4662)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W089', N'L002', 3150)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W089', N'L003', 2646)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W089', N'L004', 1134)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W089', N'L005', 1008)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W090', N'L001', 8214)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W090', N'L002', 5550)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W090', N'L003', 4662)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W090', N'L004', 1998)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W090', N'L005', 1776)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W091', N'L001', 8029)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W091', N'L002', 5425)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W091', N'L003', 4557)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W091', N'L004', 1953)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W091', N'L005', 1736)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W092', N'L001', 13505)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W092', N'L002', 9125)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W092', N'L003', 7665)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W092', N'L004', 3285)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W092', N'L005', 2920)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W093', N'L001', 10434)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W093', N'L002', 7050)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W093', N'L003', 5922)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W093', N'L004', 2538)
GO
INSERT [dbo].[WeaponsLocations] ([WeaponsID], [LocationsID], [WeaponsLocationsQty]) VALUES (N'W093', N'L005', 2256)
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Currency]    Script Date: 12/13/2022 10:40:15 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Currency] ON [dbo].[Currency]
(
	[CurrencyName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_MiscItems_Type]    Script Date: 12/13/2022 10:40:15 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_MiscItems_Type] ON [dbo].[MiscItems]
(
	[MiscItemsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_PowerSource]    Script Date: 12/13/2022 10:40:15 PM ******/
ALTER TABLE [dbo].[PowerSource] ADD  CONSTRAINT [IX_PowerSource] UNIQUE NONCLUSTERED 
(
	[PowerSourceName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Weapons]    Script Date: 12/13/2022 10:40:15 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Weapons] ON [dbo].[Weapons]
(
	[WeaponsName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Locations] ADD  CONSTRAINT [DF_Locations_LocationsState]  DEFAULT ('MN') FOR [LocationsState]
GO
ALTER TABLE [dbo].[Transportation] ADD  CONSTRAINT [DF_Transportation_TransportationCapacity]  DEFAULT ((1)) FOR [TransportationCapacity]
GO
ALTER TABLE [dbo].[CurrencyLocations]  WITH CHECK ADD  CONSTRAINT [FK_CurrencyLocations_Currency] FOREIGN KEY([CurrencyID])
REFERENCES [dbo].[Currency] ([CurrencyID])
GO
ALTER TABLE [dbo].[CurrencyLocations] CHECK CONSTRAINT [FK_CurrencyLocations_Currency]
GO
ALTER TABLE [dbo].[CurrencyLocations]  WITH CHECK ADD  CONSTRAINT [FK_CurrencyLocations_Locations] FOREIGN KEY([LocationsID])
REFERENCES [dbo].[Locations] ([LocationsID])
GO
ALTER TABLE [dbo].[CurrencyLocations] CHECK CONSTRAINT [FK_CurrencyLocations_Locations]
GO
ALTER TABLE [dbo].[MedicalSuppliesLocations]  WITH CHECK ADD  CONSTRAINT [FK_MedicalSuppliesLocations_Locations] FOREIGN KEY([LocationsID])
REFERENCES [dbo].[Locations] ([LocationsID])
GO
ALTER TABLE [dbo].[MedicalSuppliesLocations] CHECK CONSTRAINT [FK_MedicalSuppliesLocations_Locations]
GO
ALTER TABLE [dbo].[MedicalSuppliesLocations]  WITH CHECK ADD  CONSTRAINT [FK_MedicalSuppliesLocations_MedicalSupplies] FOREIGN KEY([MedicalSupplyID])
REFERENCES [dbo].[MedicalSupplies] ([MedicalSupplyID])
GO
ALTER TABLE [dbo].[MedicalSuppliesLocations] CHECK CONSTRAINT [FK_MedicalSuppliesLocations_MedicalSupplies]
GO
ALTER TABLE [dbo].[MiscItemsLocations]  WITH CHECK ADD  CONSTRAINT [FK_MiscItemsLocations_Locations] FOREIGN KEY([LocationsID])
REFERENCES [dbo].[Locations] ([LocationsID])
GO
ALTER TABLE [dbo].[MiscItemsLocations] CHECK CONSTRAINT [FK_MiscItemsLocations_Locations]
GO
ALTER TABLE [dbo].[MiscItemsLocations]  WITH CHECK ADD  CONSTRAINT [FK_MiscItemsLocations_MiscItems] FOREIGN KEY([MiscItemsID])
REFERENCES [dbo].[MiscItems] ([MiscItemsID])
GO
ALTER TABLE [dbo].[MiscItemsLocations] CHECK CONSTRAINT [FK_MiscItemsLocations_MiscItems]
GO
ALTER TABLE [dbo].[PowerSourceLocations]  WITH CHECK ADD  CONSTRAINT [FK_PowerSourceLocations_Locations] FOREIGN KEY([LocationsID])
REFERENCES [dbo].[Locations] ([LocationsID])
GO
ALTER TABLE [dbo].[PowerSourceLocations] CHECK CONSTRAINT [FK_PowerSourceLocations_Locations]
GO
ALTER TABLE [dbo].[PowerSourceLocations]  WITH CHECK ADD  CONSTRAINT [FK_PowerSourceLocations_PowerSource] FOREIGN KEY([PowerSourceID])
REFERENCES [dbo].[PowerSource] ([PowerSourceID])
GO
ALTER TABLE [dbo].[PowerSourceLocations] CHECK CONSTRAINT [FK_PowerSourceLocations_PowerSource]
GO
ALTER TABLE [dbo].[Resources]  WITH CHECK ADD  CONSTRAINT [FK_Resources_Currency] FOREIGN KEY([CurrencyID])
REFERENCES [dbo].[Currency] ([CurrencyID])
GO
ALTER TABLE [dbo].[Resources] CHECK CONSTRAINT [FK_Resources_Currency]
GO
ALTER TABLE [dbo].[ResourcesLocations]  WITH CHECK ADD  CONSTRAINT [FK_ResourcesLocations_Locations] FOREIGN KEY([LocationsID])
REFERENCES [dbo].[Locations] ([LocationsID])
GO
ALTER TABLE [dbo].[ResourcesLocations] CHECK CONSTRAINT [FK_ResourcesLocations_Locations]
GO
ALTER TABLE [dbo].[ResourcesLocations]  WITH CHECK ADD  CONSTRAINT [FK_ResourcesLocations_Resources] FOREIGN KEY([ResourcesID])
REFERENCES [dbo].[Resources] ([ResourcesID])
GO
ALTER TABLE [dbo].[ResourcesLocations] CHECK CONSTRAINT [FK_ResourcesLocations_Resources]
GO
ALTER TABLE [dbo].[Survivors]  WITH CHECK ADD  CONSTRAINT [FK_Survivors_Locations] FOREIGN KEY([LocationsID])
REFERENCES [dbo].[Locations] ([LocationsID])
GO
ALTER TABLE [dbo].[Survivors] CHECK CONSTRAINT [FK_Survivors_Locations]
GO
ALTER TABLE [dbo].[SurvivorsSkills]  WITH CHECK ADD  CONSTRAINT [FK_SurvivorsSkills_Skills] FOREIGN KEY([SkillsID])
REFERENCES [dbo].[Skills] ([SkillsID])
GO
ALTER TABLE [dbo].[SurvivorsSkills] CHECK CONSTRAINT [FK_SurvivorsSkills_Skills]
GO
ALTER TABLE [dbo].[SurvivorsSkills]  WITH CHECK ADD  CONSTRAINT [FK_SurvivorsSkills_Survivors] FOREIGN KEY([SurvivorsID])
REFERENCES [dbo].[Survivors] ([SurvivorsID])
GO
ALTER TABLE [dbo].[SurvivorsSkills] CHECK CONSTRAINT [FK_SurvivorsSkills_Survivors]
GO
ALTER TABLE [dbo].[TransportationLocations]  WITH CHECK ADD  CONSTRAINT [FK_TransportationLocations_Locations] FOREIGN KEY([LocationsID])
REFERENCES [dbo].[Locations] ([LocationsID])
GO
ALTER TABLE [dbo].[TransportationLocations] CHECK CONSTRAINT [FK_TransportationLocations_Locations]
GO
ALTER TABLE [dbo].[TransportationLocations]  WITH CHECK ADD  CONSTRAINT [FK_TransportationLocations_TransportationLocations] FOREIGN KEY([TransportationID])
REFERENCES [dbo].[Transportation] ([TransportationID])
GO
ALTER TABLE [dbo].[TransportationLocations] CHECK CONSTRAINT [FK_TransportationLocations_TransportationLocations]
GO
ALTER TABLE [dbo].[Weapons]  WITH CHECK ADD  CONSTRAINT [FK_Weapons_Currency] FOREIGN KEY([CurrencyID])
REFERENCES [dbo].[Currency] ([CurrencyID])
GO
ALTER TABLE [dbo].[Weapons] CHECK CONSTRAINT [FK_Weapons_Currency]
GO
ALTER TABLE [dbo].[WeaponsLocations]  WITH CHECK ADD  CONSTRAINT [FK_WeaponsLocations_Locations] FOREIGN KEY([LocationsID])
REFERENCES [dbo].[Locations] ([LocationsID])
GO
ALTER TABLE [dbo].[WeaponsLocations] CHECK CONSTRAINT [FK_WeaponsLocations_Locations]
GO
ALTER TABLE [dbo].[WeaponsLocations]  WITH CHECK ADD  CONSTRAINT [FK_WeaponsLocations_Weapons] FOREIGN KEY([WeaponsID])
REFERENCES [dbo].[Weapons] ([WeaponsID])
GO
ALTER TABLE [dbo].[WeaponsLocations] CHECK CONSTRAINT [FK_WeaponsLocations_Weapons]
GO
ALTER TABLE [dbo].[Currency]  WITH CHECK ADD  CONSTRAINT [CK_Currency] CHECK  (([CurrencyID] like 'C%'))
GO
ALTER TABLE [dbo].[Currency] CHECK CONSTRAINT [CK_Currency]
GO
ALTER TABLE [dbo].[CurrencyLocations]  WITH CHECK ADD  CONSTRAINT [CK_CurrencyLocations_CurrencyID] CHECK  (([CurrencyID] like 'C%'))
GO
ALTER TABLE [dbo].[CurrencyLocations] CHECK CONSTRAINT [CK_CurrencyLocations_CurrencyID]
GO
ALTER TABLE [dbo].[CurrencyLocations]  WITH CHECK ADD  CONSTRAINT [CK_CurrencyLocations_LocationsID] CHECK  (([LocationsID] like 'L%'))
GO
ALTER TABLE [dbo].[CurrencyLocations] CHECK CONSTRAINT [CK_CurrencyLocations_LocationsID]
GO
ALTER TABLE [dbo].[Locations]  WITH CHECK ADD  CONSTRAINT [CK_Locations_ID] CHECK  (([LocationsID] like 'L%'))
GO
ALTER TABLE [dbo].[Locations] CHECK CONSTRAINT [CK_Locations_ID]
GO
ALTER TABLE [dbo].[Locations]  WITH CHECK ADD  CONSTRAINT [CK_Locations_State] CHECK  (([LocationsState]='WY' OR [LocationsState]='WI' OR [LocationsState]='WV' OR [LocationsState]='WA' OR [LocationsState]='VA' OR [LocationsState]='VT' OR [LocationsState]='UT' OR [LocationsState]='TX' OR [LocationsState]='TN' OR [LocationsState]='SD' OR [LocationsState]='SC' OR [LocationsState]='RI' OR [LocationsState]='PA' OR [LocationsState]='OR' OR [LocationsState]='OK' OR [LocationsState]='OH' OR [LocationsState]='ND' OR [LocationsState]='NC' OR [LocationsState]='NY' OR [LocationsState]='NM' OR [LocationsState]='NJ' OR [LocationsState]='NH' OR [LocationsState]='NV' OR [LocationsState]='NE' OR [LocationsState]='MT' OR [LocationsState]='MO' OR [LocationsState]='MS' OR [LocationsState]='MN' OR [LocationsState]='MI' OR [LocationsState]='MA' OR [LocationsState]='MD' OR [LocationsState]='ME' OR [LocationsState]='LA' OR [LocationsState]='KY' OR [LocationsState]='KS' OR [LocationsState]='IA' OR [LocationsState]='IN' OR [LocationsState]='IL' OR [LocationsState]='ID' OR [LocationsState]='HI' OR [LocationsState]='GA' OR [LocationsState]='FL' OR [LocationsState]='DE' OR [LocationsState]='CT' OR [LocationsState]='CO' OR [LocationsState]='CA' OR [LocationsState]='AR' OR [LocationsState]='AZ' OR [LocationsState]='AK' OR [LocationsState]='AL'))
GO
ALTER TABLE [dbo].[Locations] CHECK CONSTRAINT [CK_Locations_State]
GO
ALTER TABLE [dbo].[MedicalSupplies]  WITH CHECK ADD  CONSTRAINT [CK_MedicalSupplies_ID] CHECK  (([MedicalSupplyID] like 'M%'))
GO
ALTER TABLE [dbo].[MedicalSupplies] CHECK CONSTRAINT [CK_MedicalSupplies_ID]
GO
ALTER TABLE [dbo].[MedicalSuppliesLocations]  WITH CHECK ADD  CONSTRAINT [CK_MedicalSuppliesLocations_LocationID] CHECK  (([LocationsID] like 'L%'))
GO
ALTER TABLE [dbo].[MedicalSuppliesLocations] CHECK CONSTRAINT [CK_MedicalSuppliesLocations_LocationID]
GO
ALTER TABLE [dbo].[MedicalSuppliesLocations]  WITH CHECK ADD  CONSTRAINT [CK_MedicalSuppliesLocations_MedSupID] CHECK  (([MedicalSupplyID] like 'M%'))
GO
ALTER TABLE [dbo].[MedicalSuppliesLocations] CHECK CONSTRAINT [CK_MedicalSuppliesLocations_MedSupID]
GO
ALTER TABLE [dbo].[MiscItems]  WITH CHECK ADD  CONSTRAINT [CK_MiscItems_ID] CHECK  (([MiscItemsID] like 'I%'))
GO
ALTER TABLE [dbo].[MiscItems] CHECK CONSTRAINT [CK_MiscItems_ID]
GO
ALTER TABLE [dbo].[MiscItemsLocations]  WITH CHECK ADD  CONSTRAINT [CK_MiscItemsLocations_LocationsID] CHECK  (([LocationsID] like 'L%'))
GO
ALTER TABLE [dbo].[MiscItemsLocations] CHECK CONSTRAINT [CK_MiscItemsLocations_LocationsID]
GO
ALTER TABLE [dbo].[MiscItemsLocations]  WITH CHECK ADD  CONSTRAINT [CK_MiscItemsLocations_MiscItemsID] CHECK  (([MiscItemsID] like 'I%'))
GO
ALTER TABLE [dbo].[MiscItemsLocations] CHECK CONSTRAINT [CK_MiscItemsLocations_MiscItemsID]
GO
ALTER TABLE [dbo].[PowerSource]  WITH CHECK ADD  CONSTRAINT [CK_PowerSource_ID] CHECK  (([PowerSourceID] like 'E%'))
GO
ALTER TABLE [dbo].[PowerSource] CHECK CONSTRAINT [CK_PowerSource_ID]
GO
ALTER TABLE [dbo].[PowerSourceLocations]  WITH CHECK ADD  CONSTRAINT [CK_PowerSourceLocations_LocationsID] CHECK  (([LocationsID] like 'L%'))
GO
ALTER TABLE [dbo].[PowerSourceLocations] CHECK CONSTRAINT [CK_PowerSourceLocations_LocationsID]
GO
ALTER TABLE [dbo].[PowerSourceLocations]  WITH CHECK ADD  CONSTRAINT [CK_PowerSourceLocations_PowerSourceID] CHECK  (([PowerSourceID] like 'E%'))
GO
ALTER TABLE [dbo].[PowerSourceLocations] CHECK CONSTRAINT [CK_PowerSourceLocations_PowerSourceID]
GO
ALTER TABLE [dbo].[Resources]  WITH CHECK ADD  CONSTRAINT [CK_Resources_CurrencyID] CHECK  (([CurrencyID] like 'C%'))
GO
ALTER TABLE [dbo].[Resources] CHECK CONSTRAINT [CK_Resources_CurrencyID]
GO
ALTER TABLE [dbo].[Resources]  WITH CHECK ADD  CONSTRAINT [CK_Resources_ID] CHECK  (([ResourcesID] like 'R%'))
GO
ALTER TABLE [dbo].[Resources] CHECK CONSTRAINT [CK_Resources_ID]
GO
ALTER TABLE [dbo].[ResourcesLocations]  WITH CHECK ADD  CONSTRAINT [CK_ResourcesLocations_LocationsID] CHECK  (([LocationsID] like 'L%'))
GO
ALTER TABLE [dbo].[ResourcesLocations] CHECK CONSTRAINT [CK_ResourcesLocations_LocationsID]
GO
ALTER TABLE [dbo].[ResourcesLocations]  WITH CHECK ADD  CONSTRAINT [CK_ResourcesLocations_ResourcesID] CHECK  (([ResourcesID] like 'R%'))
GO
ALTER TABLE [dbo].[ResourcesLocations] CHECK CONSTRAINT [CK_ResourcesLocations_ResourcesID]
GO
ALTER TABLE [dbo].[Skills]  WITH CHECK ADD  CONSTRAINT [CK_Skills] CHECK  (([SkillsID] like 'S%'))
GO
ALTER TABLE [dbo].[Skills] CHECK CONSTRAINT [CK_Skills]
GO
ALTER TABLE [dbo].[Survivors]  WITH CHECK ADD  CONSTRAINT [CK_Survivors] CHECK  (([LocationsID] like 'L%'))
GO
ALTER TABLE [dbo].[Survivors] CHECK CONSTRAINT [CK_Survivors]
GO
ALTER TABLE [dbo].[Survivors]  WITH CHECK ADD  CONSTRAINT [CK_Survivors_Gender] CHECK  (([SurvivorsGender]='F' OR [SurvivorsGender]='M'))
GO
ALTER TABLE [dbo].[Survivors] CHECK CONSTRAINT [CK_Survivors_Gender]
GO
ALTER TABLE [dbo].[Survivors]  WITH CHECK ADD  CONSTRAINT [CK_Survivors_ID] CHECK  (([SurvivorsID] like 'P%'))
GO
ALTER TABLE [dbo].[Survivors] CHECK CONSTRAINT [CK_Survivors_ID]
GO
ALTER TABLE [dbo].[SurvivorsSkills]  WITH CHECK ADD  CONSTRAINT [CK_SurvivorsSkills_SkillsID] CHECK  (([SkillsID] like 'S%'))
GO
ALTER TABLE [dbo].[SurvivorsSkills] CHECK CONSTRAINT [CK_SurvivorsSkills_SkillsID]
GO
ALTER TABLE [dbo].[SurvivorsSkills]  WITH CHECK ADD  CONSTRAINT [CK_SurvivorsSkills_SurvivorsID] CHECK  (([SurvivorsID] like 'P%'))
GO
ALTER TABLE [dbo].[SurvivorsSkills] CHECK CONSTRAINT [CK_SurvivorsSkills_SurvivorsID]
GO
ALTER TABLE [dbo].[Transportation]  WITH CHECK ADD  CONSTRAINT [CK_Transportation_ID] CHECK  (([TransportationID] like 'T%'))
GO
ALTER TABLE [dbo].[Transportation] CHECK CONSTRAINT [CK_Transportation_ID]
GO
ALTER TABLE [dbo].[TransportationLocations]  WITH CHECK ADD  CONSTRAINT [CK_TransportationLocations_LocationID] CHECK  (([LocationsID] like 'L%'))
GO
ALTER TABLE [dbo].[TransportationLocations] CHECK CONSTRAINT [CK_TransportationLocations_LocationID]
GO
ALTER TABLE [dbo].[TransportationLocations]  WITH CHECK ADD  CONSTRAINT [CK_TransportationLocations_TranspID] CHECK  (([TransportationID] like 'T%'))
GO
ALTER TABLE [dbo].[TransportationLocations] CHECK CONSTRAINT [CK_TransportationLocations_TranspID]
GO
ALTER TABLE [dbo].[Weapons]  WITH CHECK ADD  CONSTRAINT [CK_Weapons_CurrencyID] CHECK  (([CurrencyID] like 'C%'))
GO
ALTER TABLE [dbo].[Weapons] CHECK CONSTRAINT [CK_Weapons_CurrencyID]
GO
ALTER TABLE [dbo].[Weapons]  WITH CHECK ADD  CONSTRAINT [CK_Weapons_ID] CHECK  (([WeaponsID] like 'W%'))
GO
ALTER TABLE [dbo].[Weapons] CHECK CONSTRAINT [CK_Weapons_ID]
GO
ALTER TABLE [dbo].[WeaponsLocations]  WITH CHECK ADD  CONSTRAINT [CK_WeaponsLocations_LocationsID] CHECK  (([LocationsID] like 'L%'))
GO
ALTER TABLE [dbo].[WeaponsLocations] CHECK CONSTRAINT [CK_WeaponsLocations_LocationsID]
GO
ALTER TABLE [dbo].[WeaponsLocations]  WITH CHECK ADD  CONSTRAINT [CK_WeaponsLocations_WeaponsID] CHECK  (([WeaponsID] like 'W%'))
GO
ALTER TABLE [dbo].[WeaponsLocations] CHECK CONSTRAINT [CK_WeaponsLocations_WeaponsID]
GO
/****** Object:  StoredProcedure [dbo].[AddResources]    Script Date: 12/13/2022 10:40:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddResources] (
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
/****** Object:  StoredProcedure [dbo].[capturedORkilled]    Script Date: 12/13/2022 10:40:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[capturedORkilled] (
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
/****** Object:  StoredProcedure [dbo].[rescued]    Script Date: 12/13/2022 10:40:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[rescued] (
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
/****** Object:  StoredProcedure [dbo].[TakeResources]    Script Date: 12/13/2022 10:40:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[TakeResources] (
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
USE [master]
GO
ALTER DATABASE [Doomsday] SET  READ_WRITE 
GO
