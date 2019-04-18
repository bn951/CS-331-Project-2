--PROJECT 2-G95
-- ============================================= 
-- Author:  Bobby Nijjar
-- Procedure:   DbSecurity.UserAuthorization
-- Create date:  4/12
-- Description: Table containing each Group Member
-- ==============================================
-- Create Schemas
CREATE SCHEMA DbSecurity;
GO
CREATE SCHEMA PkSequence;
GO
-- Create Sequence Object for UserAuthorization Table
CREATE SEQUENCE PkSequence.UserAuthorizationSequenceObject AS INT MINVALUE 1;

-- Create UserAuthorization Table
CREATE TABLE DbSecurity.UserAuthorization(
    UserAuthorizationKey INT            NOT NULL    DEFAULT (NEXT VALUE FOR PkSequence.UserAuthorizationSequenceObject) PRIMARY KEY,
    ClassTime            NCHAR(5)       NULL        DEFAULT '9:15',
    [Individual Project] NVARCHAR(60)   NULL        DEFAULT 'PROJECT 2 RECREATE THE BICLASS DATABASE STAR SCHEMA',
    GroupMemberLastName  NVARCHAR(35)   NOT NULL,
    GroupMemberFirstName NVARCHAR(25)   NOT NULL,
    GroupName            NVARCHAR(20)   NOT NULL    DEFAULT 'G9-5',
    DateAdded            DATETIME2      NULL        DEFAULT SYSDATETIME()
);
-- Insert Group Members into table
INSERT INTO DbSecurity.UserAuthorization(
    GroupMemberLastName,
    GroupMemberFirstName
) VALUES
    ('Nijjar', 'Bobby'),
    ('Ma', 'Philip'),
    ('Li', 'Gen'),
    ('Pevidal', 'Kirsten'),
    ('Padua', 'Kate');
--------------------------------------
-- ============================================= 
-- Author:  Gen. Li
-- Procedure:   Process.WorkflowSteps table 
-- Create date:  4/11
-- Description: A table of each worksteps

-- ==============================================
create schema Process
Go
create sequence PkSequence.WorkflowStepsSequenceObject AS INT MINVALUE 1;

create table Process.WorkflowSteps(
		WorkFlowStepKey INT NOT NULL DEFAULT(NEXT VALUE FOR PkSequence.WorkflowStepsSequenceObject) primary key,
		WorkFlowStepDescription NVARCHAR(100) NOT NULL,
		WorkFlowStepTableRowCount INT NULL DEFAULT (0),
		StartingDateTime DATETIME2(7) NULL DEFAULT (SYSDATETIME()),
		EndingDateTime DATETIME2(7) NULL DEFAULT (SYSDATETIME()),
		ClassTime CHAR(5) NULL DEFAULT ('09:15'),
        UserAuthorizationKey INT NOT NULL 
)
-- ============================================= 
-- Author:  Gen. Li
-- Procedure:   Process.usp_TrackWorkFlow 
-- Create date:  4/11
-- Description: A stored procedure to track the workflow

-- ==============================================
go
create procedure Process.usp_TrackWorkFlow 

   @StartTime DATETIME2,    
   @WorkFlowDescription NVARCHAR(100),     
   @WorkFlowStepTableRowCount int,     
   @UserAuthorization int 
as
insert into Process.WorkflowSteps(WorkFlowStepDescription, WorkFlowStepTableRowCount, StartingDateTime, UserAuthorizationKey)
values (@WorkFlowDescription, @WorkFlowStepTableRowCount, @StartTime, @UserAuthorization);
-- =============================================
-- Author: Kate Padua
-- Procedure: Process.usp_ShowWorkflowSteps
-- Create date: 04/18/2019
-- Description: SHOW WORK FLOW STEPS
-- =============================================
GO
CREATE or Alter PROCEDURE Process.usp_ShowWorkflowSteps
AS
BEGIN
set nocount on;
select * from process.WorkflowSteps
select [total run time in seconds]=
cast(
	DATEDIFF(millisecond,min(startingdatetime),MAX(endingdatetime))
 as float) / 10000
 from process.WorkflowSteps
END;
-- =============================================
-- Author: Kirsten Pevidal
-- Procedure: Create Table [CH01-01-Dimension].[DimProductCategory] and [CH01-01-Dimension].[DimProductSubcategory]
-- Create date: 04/13/2019
-- Description: A table for product categorization
-- =============================================
GO
/****** Object:  Table [dbo].[CH01-01-Dimension.DimProductCategory]    Script Date: 4/13/2019 9:56:05 AM ******/
CREATE SEQUENCE PkSequence.DimProductCategorySequenceObject AS INT MINVALUE 1;
CREATE SEQUENCE PkSequence.DimProductSubcategorySequenceObject AS INT MINVALUE 1;
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CH01-01-Dimension].[DimProductCategory]
(
	[ProductCategoryKey] [int] NOT NULL DEFAULT(NEXT VALUE FOR PkSequence.DimProductCategorySequenceObject) PRIMARY KEY,
	[Productcategory] [varchar](20) NULL
)
GO
CREATE TABLE [CH01-01-Dimension].[DimProductSubCategory]
(
	[ProductSubcategoryKey] [int] NOT NULL DEFAULT(NEXT VALUE FOR PkSequence.DimProductSubcategorySequenceObject) PRIMARY KEY,
	[ProductCategoryKey] [int] NOT NULL,
	[ProductSubcategory] [varchar](20) NULL
)
GO
--SET PARENT-CHILD RELATIONSHIP (DIMPRODUCTCATEGORY -> DIMPRODUCTSUBCATEGORY)
ALTER TABLE [CH01-01-Dimension].[DimProductSubcategory]  WITH CHECK 
ADD  CONSTRAINT [FK_DimProductSubcategory_DimProductCategory] FOREIGN KEY([ProductCategoryKey])
REFERENCES [CH01-01-Dimension].[DimProductCategory] ([ProductCategoryKey])
ALTER TABLE [CH01-01-Dimension].[DimProductSubcategory] CHECK CONSTRAINT [FK_DimProductSubcategory_DimProductCategory]

--SET CHILD-GRANDCHILD RELATIONSHIP (DIMPRODUCTSUBCATEGORY -> DIMPRODUCT)
ALTER TABLE [CH01-01-Dimension].[DimProduct]  WITH CHECK 
ADD  CONSTRAINT [FK_DimProduct_DimProductSubcategory] FOREIGN KEY([ProductSubcategoryKey])
REFERENCES [CH01-01-Dimension].[DimProductSubcategory] ([ProductSubcategoryKey])
ALTER TABLE [CH01-01-Dimension].[DimProduct] CHECK CONSTRAINT [FK_DimProduct_DimProductSubcategory]
-- =============================================
-- Author: Phillip Ma
-- Procedure: Project2.DropForeignKeysFromStarSchemaData
-- Create date: 04/14/2019
-- Description: Drops foreign keys.
-- =============================================
go
create or alter procedure [Project2].[DropForeignKeysFromStarSchemaData]
	@UserAuthorizationKey int
as
begin
	set nocount on;
	declare @CurrentTime datetime2 = SYSDATETIME();
	declare @UserAuthorizationKey int = @userAuthorizationKey
	
	alter table [CH01-01-Fact].[Data] drop constraint [FK_Data_DimCustomer]
	alter table [CH01-01-Fact].[Data] drop constraint [FK_Data_DimGender] 
	alter table [CH01-01-Fact].[Data] drop constraint [FK_Data_DimMaritalStatus]
	alter table [CH01-01-Fact].[Data] drop constraint [FK_Data_DimOccupation] 
	alter table [CH01-01-Fact].[Data] drop constraint [FK_Data_DimOrderDate] 
	alter table [CH01-01-Fact].[Data] drop constraint [FK_Data_DimProduct]
	alter table [CH01-01-Fact].[Data] drop constraint [FK_Data_DimTerritory]
	alter table [CH01-01-Fact].[Data] drop constraint [FK_Data_SalesManagers]
	
	alter table [CH01-01-Dimension].[DimProduct] drop constraint [FK_DimProduct_DimProductSubcategory]
	alter table [CH01-01-Dimension].[DimProductSubcategory] drop constraint [FK_DimProductSubcategory_DimProductCategory]

	exec Process.usp_TrackWorkFlow @StartTime = @CurrentTime, @WorkFlowDescription = 'Drops FK from tables', @WorkFlowStepTableRowCount = @@RowCount, @UserAuthorization = @UserAuthorizationKey;
end;
-- =============================================
-- Author: Phillip Ma
-- Procedure: Project2.TruncateStarSchemaData
-- Create date: 04/14/2019
-- Description: Truncates schema data.
-- =============================================
create or alter procedure Project2.TruncateStarSchemaDataUpd
	@UserAuthorizationKey int
as
begin
	set nocount on;
	declare @CurrentTime datetime2 = SYSDATETIME();

	truncate table [CH01-01-Dimension].DimCustomer;
	truncate table [CH01-01-Dimension].DimGender;
	truncate table [CH01-01-Dimension].DimMaritalStatus;
	truncate table [CH01-01-Dimension].DimOccupation;
	truncate table [CH01-01-Dimension].DimOrderDate;
	truncate table [CH01-01-Dimension].DimProduct;
	truncate table [CH01-01-Dimension].DimProductCategory;
	truncate table [CH01-01-Dimension].DimProductSubcategory;
	truncate table [CH01-01-Dimension].DimTerritory;
	truncate table [CH01-01-Dimension].SalesManagers;
	truncate table [CH01-01-Fact].data;
	truncate table Process.WorkflowSteps;

	exec Process.usp_TrackWorkFlow @StartTime = @CurrentTime, @WorkFlowDescription = 'Truncate Star Schema', @WorkFlowStepTableRowCount = @@RowCount, @UserAuthorization = @UserAuthorizationKey;
end;

--------------------------------------------------------------
-- Add UserAuthorizationKeys, DateAdded, DateOfLastUpdate
	exec [Project2].[DropForeignKeysFromStarSchemaData] @UserAuthorizationKey = 2;
	exec Project2.TruncateStarSchemaDataUpd @UserAuthorizationKey = 2;
-- ============================================= 
-- Author:  Gen. Li
-- Procedure: 
-- Create date:  4/16
-- Description: update new column
-- ==============================================
alter table  [CH01-01-Dimension].[DimCustomer]
add UserAuthorizationKey int not NULL,
 DateAdded         datetime2   null default sysdatetime(),
 DateOfLastUpdate datetime2   null default sysdatetime()
	
alter table [CH01-01-Dimension].[DimGender]
add  UserAuthorizationKey INT NOT NULL,
 DateAdded         datetime2   null default sysdatetime(),
 DateOfLastUpdate datetime2   null default sysdatetime()

alter table [CH01-01-Dimension].[DimMaritalStatus]
add UserAuthorizationKey INT NOT NULL,
 DateAdded         datetime2   null default sysdatetime(),
 DateOfLastUpdate datetime2   null default sysdatetime()

alter table [CH01-01-Dimension].[DimOccupation]
add UserAuthorizationKey INT NOT NULL,
 DateAdded         datetime2   null default sysdatetime(),
 DateOfLastUpdate datetime2   null default sysdatetime()

alter  table [CH01-01-Dimension].[DimOrderDate]
add UserAuthorizationKey INT NOT NULL,
 DateAdded         datetime2   null default sysdatetime(),
 DateOfLastUpdate datetime2   null default sysdatetime()

alter  table [CH01-01-Dimension].[DimProduct]
add UserAuthorizationKey INT NOT NULL,
 DateAdded         datetime2   null default sysdatetime(),
 DateOfLastUpdate datetime2   null default sysdatetime()

alter  table [CH01-01-Dimension].[DimTerritory]
add UserAuthorizationKey INT NOT NULL,
 DateAdded         datetime2   null default sysdatetime(),
 DateOfLastUpdate datetime2   null default sysdatetime()

alter  table [CH01-01-Dimension].[SalesManagers]
add UserAuthorizationKey INT NOT NULL,
 DateAdded         datetime2   null default sysdatetime(),
 DateOfLastUpdate datetime2   null default sysdatetime()

alter  table [CH01-01-Dimension].[DimProductCategory]
add UserAuthorizationKey INT NOT NULL,
 DateAdded         datetime2   null default sysdatetime(),
 DateOfLastUpdate datetime2   null default sysdatetime()

alter  table [CH01-01-Dimension].[DimProductSubCategory]
add UserAuthorizationKey INT NOT NULL,
 DateAdded         datetime2   null default sysdatetime(),
 DateOfLastUpdate datetime2   null default sysdatetime()

 -- TRUNCATE TABLE [CH01-01-Dimension].DimOccupation;

CREATE SEQUENCE PkSequence.DimOccupationSequenceObject AS INT MINVALUE 1;
ALTER TABLE [CH01-01-Dimension].DimOccupation
DROP CONSTRAINT [PK_DimOccupation];

ALTER TABLE [CH01-01-Dimension].DimOccupation
    DROP COLUMN OccupationKey;

ALTER TABLE [CH01-01-Dimension].DimOccupation
    ADD OccupationKey INT NOT NULL DEFAULT(NEXT VALUE FOR PkSequence.DimOccupationSequenceObject) PRIMARY KEY CLUSTERED;
-- TRUNCATE TABLE [CH01-01-Dimension].SalesManagers
CREATE SEQUENCE PkSequence.SalesManagersSequenceObject AS INT MINVALUE 1;
ALTER TABLE [CH01-01-Dimension].SalesManagers
DROP CONSTRAINT [PK_SalesManagers];

ALTER TABLE [CH01-01-Dimension].SalesManagers
    DROP COLUMN SalesManagerKey;

ALTER TABLE [CH01-01-Dimension].SalesManagers
    ADD SalesManagerKey INT NOT NULL DEFAULT(NEXT VALUE FOR PkSequence.SalesManagersSequenceObject) PRIMARY KEY CLUSTERED;

-- TRUNCATE TABLE [CH01-01-Fact].Data

CREATE SEQUENCE PkSequence.DataSequenceObject AS INT MINVALUE 1;
ALTER TABLE [CH01-01-Fact].Data
--DROP CONSTRAINT [PK__Data__C104F6F1B36516E7];
DROP CONSTRAINT [PK_Data];
ALTER TABLE [CH01-01-Fact].Data
    DROP COLUMN SalesKey;

ALTER TABLE [CH01-01-Fact].Data
    ADD SalesKey INT NOT NULL DEFAULT(NEXT VALUE FOR PkSequence.DataSequenceObject) PRIMARY KEY CLUSTERED;

--exec [Project2].[LoadStarSchemaData] @UserAuthorizationKey = 2;
exec [Project2].[DropForeignKeysFromStarSchemaData]  @UserAuthorizationKey  = 2 ;

-- =============================================
-- Author: Phillip Ma
-- Procedure: Project2.AddForeignKeysToStarSchemaData
-- Create date: 04/14/2019
-- Description: Adds foreign keys.
-- =============================================
create or alter procedure [Project2].[AddForeignKeysToStarSchemaData]
	@UserAuthorizationKey int
as
begin

	set nocount on;
	declare @CurrentTime datetime2 = SYSDATETIME();

	alter table [CH01-01-Fact].[Data] with check add constraint [FK_Data_DimCustomer] foreign key([CustomerKey])
	references [CH01-01-Dimension].[DimCustomer] ([CustomerKey])

	alter table [CH01-01-Fact].[Data] check constraint [FK_Data_DimCustomer]

	alter table [CH01-01-Fact].[Data] with check add constraint [FK_Data_DimGender] foreign key([Gender])
	references [CH01-01-Dimension].[DimGender] ([Gender])

	alter table [CH01-01-Fact].[Data] check constraint [FK_Data_DimGender]

	alter table [CH01-01-Fact].[Data] with check add constraint [FK_Data_DimMaritalStatus] foreign key([MaritalStatus])
	references [CH01-01-Dimension].[DimMaritalStatus] ([MaritalStatus])

	alter table [CH01-01-Fact].[Data] check constraint [FK_Data_DimMaritalStatus]

	alter table [CH01-01-Fact].[Data] with check add constraint [FK_Data_DimOccupation] foreign key([OccupationKey])
	references [CH01-01-Dimension].[DimOccupation] ([OccupationKey])

	alter table [CH01-01-Fact].[Data] check constraint [FK_Data_DimOccupation]

	alter table [CH01-01-Fact].[Data] with check add constraint [FK_Data_DimOrderDate] foreign key([OrderDate])
	references [CH01-01-Dimension].[DimOrderDate] ([OrderDate])

	alter table [CH01-01-Fact].[Data] check constraint [FK_Data_DimOrderDate]

	alter table [CH01-01-Fact].[Data] with check add constraint [FK_Data_DimProduct] foreign key([ProductKey])
	references [CH01-01-Dimension].[DimProduct] ([ProductKey])

	alter table [CH01-01-Fact].[Data] check constraint [FK_Data_DimProduct]

	alter table [CH01-01-Fact].[Data] with check add constraint [FK_Data_DimTerritory] foreign key([TerritoryKey])
	references [CH01-01-Dimension].[DimTerritory] ([TerritoryKey])

	alter table [CH01-01-Fact].[Data] check constraint [FK_Data_DimTerritory]

	alter table [CH01-01-Fact].[Data] with check add constraint [FK_Data_SalesManagers] foreign key([SalesManagerKey])
	references [CH01-01-Dimension].[SalesManagers] ([SalesManagerKey])

	alter table [CH01-01-Fact].[Data] check constraint [FK_Data_SalesManagers]

	alter table [CH01-01-Dimension].[DimProductSubcategory] with check add constraint [FK_DimProductSubcategory_DimProductCategory] foreign key([ProductCategoryKey])
	references [CH01-01-Dimension].[DimProductCategory] ([ProductCategoryKey])

	alter table [CH01-01-Dimension].[DimProductSubcategory] check constraint [FK_DimProductSubcategory_DimProductCategory]

	alter table [CH01-01-Dimension].[DimProduct] with check add constraint [FK_DimProduct_DimProductSubcategory] foreign key([ProductSubcategoryKey])
	references [CH01-01-Dimension].[DimProductSubcategory] ([ProductSubcategoryKey])

	alter table [CH01-01-Dimension].[DimProduct] check constraint [FK_DimProduct_DimProductSubcategory]

	
	exec Process.usp_TrackWorkFlow @StartTime = @CurrentTime, @WorkFlowDescription = 'Adds FK back to tables', @WorkFlowStepTableRowCount = @@RowCount, @UserAuthorization = @UserAuthorizationKey;
end;

-- =============================================
-- Author: Phillip Ma
-- Procedure: Project2.LoadData
-- Create date: 04/14/2019
-- Description: Loads data.
-- =============================================
create or alter procedure [Project2].[LoadData]
	@UserAuthorizationKey int
as
begin
	
	set nocount on;
	declare @CurrentTime datetime2 = SYSDATETIME();
	
	insert into [CH01-01-Fact].Data
		(SalesManagerKey, OccupationKey, TerritoryKey, ProductKey, CustomerKey,
		ProductCategory, SalesManager, ProductSubcategory, ProductCode, 
		ProductName, Color, ModelName, OrderQuantity, UnitPrice,
		ProductStandardCost, SalesAmount, OrderDate, [MonthName], MonthNumber, 
		[Year], CustomerName, MaritalStatus, Gender, Education,
		Occupation, TerritoryRegion, TerritoryCountry, TerritoryGroup)
	select top (130)
		sm.SalesManagerKey, do.OccupationKey, dt.TerritoryKey, dp.ProductKey, dc.CustomerKey,
		orig.ProductCategory, orig.SalesManager, orig.ProductSubcategory, orig.ProductCode, 
		orig.ProductName, orig.Color, orig.ModelName, orig.OrderQuantity, orig.UnitPrice,
		orig.ProductStandardCost, orig.SalesAmount, orig.OrderDate, orig.[MonthName], orig.MonthNumber, 
		orig.[Year], orig.CustomerName, orig.MaritalStatus, orig.Gender, orig.Education,
		orig.Occupation, orig.TerritoryRegion, orig.TerritoryCountry, orig.TerritoryGroup
	from
	FileUpload.OriginallyLoadedData as orig 
		inner join [CH01-01-Dimension].DimProduct as dp
			on dp.ProductName = orig.ProductName
		inner join [CH01-01-Dimension].DimTerritory as dt
			on dt.TerritoryCountry = orig.TerritoryCountry
			and dt.TerritoryGroup = orig.TerritoryGroup
			and dt.TerritoryRegion = orig.TerritoryRegion 
		inner join [CH01-01-Dimension].DimCustomer as dc
			on dc.CustomerName = orig.CustomerName
		inner join [CH01-01-Dimension].SalesManagers as sm
			on sm.SalesManager = orig.SalesManager
		inner join [CH01-01-Dimension].DimOccupation as do
			on do.Occupation = orig.Occupation

	exec Process.usp_TrackWorkFlow @StartTime = @CurrentTime, @WorkFlowDescription = 'Load Data table', @WorkFlowStepTableRowCount = @@RowCount, @UserAuthorization = @UserAuthorizationKey;
end;
--------------------------------------------------------------------------------------
go
set ansi_nulls on
go
set quoted_identifier on
go
-- =============================================
-- Author: Phillip Ma
-- Procedure: Project2.LoadDimCustomer
-- Create date: 04/14/2019
-- Description: Loads the DimCustomer table.
-- =============================================
create or alter procedure [Project2].[LoadDimCustomer]
	@UserAuthorizationKey int
as
begin
	set nocount on;
	declare @CurrentTime datetime2 = SYSDATETIME();

	insert into [CH01-01-Dimension].[DimCustomer]
		(CustomerName,
		UserAuthorizationKey, DateAdded)
	select distinct orig.CustomerName, @UserAuthorizationKey, @CurrentTime
	from FileUpload.OriginallyLoadedData as orig 
		--inner join [CH01-01-Dimension].DimCustomer as dc 
			--on dc.CustomerName = orig.CustomerName;

	exec Process.usp_TrackWorkFlow @StartTime = @CurrentTime, @WorkFlowDescription = 'Load DimCustomer', @WorkFlowStepTableRowCount = @@RowCount, @UserAuthorization = @UserAuthorizationKey;
end;
-----------------------------------------------------------------------------------
go
set ansi_nulls on
go
set quoted_identifier on
go
-- =============================================
-- Author: Phillip Ma
-- Procedure: Project2.LoadDimGender
-- Create date: 04/14/2019
-- Description: Loads DimGender table.
-- =============================================
create or alter procedure [Project2].[LoadDimGender]
	@UserAuthorizationKey int
as
begin
	set nocount on;
	declare @CurrentTime datetime2 = SYSDATETIME();

	insert into [CH01-01-Dimension].[DimGender]
		(Gender, GenderDescription,
		UserAuthorizationKey, DateAdded)
	select distinct orig.Gender, GenderDescription = (case orig.Gender
			when 'M' then 'MALE'
			else 'FEMALE' end),
			@UserAuthorizationKey, @CurrentTime
	from FileUpload.OriginallyLoadedData as orig 
		--inner join [CH01-01-Dimension].[DimGender] as dg 
			--on dg.Gender = orig.Gender
	exec Process.usp_TrackWorkFlow @StartTime = @CurrentTime, @WorkFlowDescription = 'Load DimGender', @WorkFlowStepTableRowCount = @@RowCount, @UserAuthorization = @UserAuthorizationKey;
end;
------------------------------------------------------------------------
go
set ansi_nulls on
go
set quoted_identifier on
go
-- =============================================
-- Author: Phillip Ma
-- Procedure: Project2.LoadDimMaritalStatus
-- Create date: 04/14/2019
-- Description: Load DimMaritalStatus table.
-- =============================================
create or alter procedure Project2.LoadDimMaritalStatus
	@UserAuthorizationKey int
as
begin
	set nocount on;
	declare @CurrentTime datetime2 = SYSDATETIME();

	insert into [CH01-01-Dimension].[DimMaritalStatus]
		(MaritalStatus, MaritalStatusDescription,
		UserAuthorizationKey, DateAdded)
	select distinct orig.MaritalStatus, MaritalStatusDescription  = (case orig.MaritalStatus
			when 'S' then 'SINGLE'
			when 'D' then 'DIVORCED'
			when 'W' then 'WIDOWED'
			else 'MARRIED' end),
			@UserAuthorizationKey, @CurrentTime
	from FileUpload.OriginallyLoadedData as orig 
		--inner join [CH01-01-Dimension].[DimMaritalStatus] as dm
			--on dm.MaritalStatus = orig.MaritalStatus;
	exec Process.usp_TrackWorkFlow @StartTime = @CurrentTime, @WorkFlowDescription = 'Load DimMaritalStatus', @WorkFlowStepTableRowCount = @@RowCount, @UserAuthorization = @UserAuthorizationKey;
end;
--------------------------------------------------------------------------
go
set ansi_nulls on
go
set quoted_identifier on
go
-- =============================================
-- Author: Phillip Ma
-- Procedure: Project2.LoadDimOccupation
-- Create date: 04/14/2019
-- Description: Loads DimOccupation table.
-- =============================================
create or alter procedure [Project2].[LoadDimOccupation]
	@UserAuthorizationKey int
as
begin
	set nocount on;
	declare @CurrentTime datetime2 = SYSDATETIME();

	insert into [CH01-01-Dimension].[DimOccupation]
		(Occupation,
		UserAuthorizationKey, DateAdded)
	select distinct orig.Occupation,
			@UserAuthorizationKey, @CurrentTime
	from FileUpload.OriginallyLoadedData as orig 
		--inner join [CH01-01-Dimension].DimOccupation as do
			--on do.Occupation = orig.Occupation;
	exec Process.usp_TrackWorkFlow @StartTime = @CurrentTime, @WorkFlowDescription = 'Load DimOccupation', @WorkFlowStepTableRowCount = @@RowCount, @UserAuthorization = @UserAuthorizationKey;
end;
-------------------------------------------------------------------------------
go
set ansi_nulls on
go
set quoted_identifier on
go
-- =============================================
-- Author: Phillip Ma
-- Procedure: Project2.LoadDimOrderDate
-- Create date: 04/14/2019
-- Description: Loads DimOrderDate table.
-- =============================================
create or alter procedure [Project2].[LoadDimOrderDate]
	@UserAuthorizationKey int
as
begin
	set nocount on;
	declare @CurrentTime datetime2 = SYSDATETIME();

	insert into [CH01-01-Dimension].[DimOrderDate]
		(OrderDate, [MonthName], MonthNumber, [Year],
		UserAuthorizationKey, DateAdded)
	select distinct orig.OrderDate, orig.[MonthName], orig.MonthNumber, orig.[Year],
			@UserAuthorizationKey, @CurrentTime
	from FileUpload.OriginallyLoadedData as orig 
		--inner join [CH01-01-Dimension].[DimOrderDate] as dod
			--on dod.OrderDate = orig.OrderDate 
				--and dod.[MonthName] = orig.[MonthName] 
				--and dod.MonthNumber = orig.MonthNumber 
				--and dod.[Year] = orig.[Year];
	exec Process.usp_TrackWorkFlow @StartTime = @CurrentTime, @WorkFlowDescription = 'Load DimOrderDate', @WorkFlowStepTableRowCount = @@RowCount, @UserAuthorization = @UserAuthorizationKey;
end;
---------------------------------------------------------------------------------------------
go
set ansi_nulls on
go
set quoted_identifier on
go
-- =============================================
-- Author: Phillip Ma
-- Procedure: Project2.LoadDimProduct
-- Create date: 04/14/2019
-- Description: Loads DimProduct table.
-- =============================================
create or alter procedure [Project2].[LoadDimProduct]
	@UserAuthorizationKey int
as
begin
	set nocount on;
	declare @CurrentTime datetime2 = SYSDATETIME();

	insert into [CH01-01-Dimension].[DimProduct]
		(ProductSubCategoryKey, ProductSubcategory, ProductCategory, ProductCode, ProductName, Color, ModelName,
		UserAuthorizationKey, DateAdded)
	select distinct top (130) dps.ProductSubcategoryKey, orig.ProductSubcategory, orig.ProductCategory, orig.ProductCode, orig.ProductName, orig.Color, orig.ModelName,
			@UserAuthorizationKey, @CurrentTime
	from FileUpload.OriginallyLoadedData as orig
		inner join [CH01-01-Dimension].DimProductSubCategory as dps
			on orig.ProductSubcategory = dps.ProductSubcategory
		inner join [CH01-01-Dimension].[DimProductCategory] as dp
			on dp.ProductCategory = orig.ProductCategory 
			--and dp.ProductSubcategory = orig.ProductSubcategory 
			--and dp.ProductCode = orig.ProductCode 
			--and dp.ProductName = orig.ProductName 
			--and dp.Color = orig.Color 
			--and dp.ModelName = orig.ModelName;
	exec Process.usp_TrackWorkFlow @StartTime = @CurrentTime, @WorkFlowDescription = 'Load DimProduct', @WorkFlowStepTableRowCount = @@RowCount, @UserAuthorization = @UserAuthorizationKey;
end;
------------------------------------------------------------------------------
go
set ansi_nulls on
go
set quoted_identifier on
go
-- =============================================
-- Author: Phillip Ma
-- Procedure: Project2.LoadDimProductCategory
-- Create date: 04/14/2019
-- Description: Loads DimProductCategory table.
-- =============================================
create or alter procedure [Project2].[LoadDimProductCategory]
	@UserAuthorizationKey int
as
begin
	set nocount on;
	declare @CurrentTime datetime2 = SYSDATETIME();

	insert into [CH01-01-Dimension].DimProductCategory
		(ProductCategory,
		UserAuthorizationKey, DateAdded)
	select distinct orig.ProductCategory,
			@UserAuthorizationKey, @CurrentTime
	from FileUpload.OriginallyLoadedData as orig 
		--inner join [CH01-01-Dimension].DimProductCategory as dpc
			--on dpc.ProductCategory = orig.ProductCategory 
	exec Process.usp_TrackWorkFlow @StartTime = @CurrentTime, @WorkFlowDescription = 'Load DimProductCategory', @WorkFlowStepTableRowCount = @@RowCount, @UserAuthorization = @UserAuthorizationKey;
end;
----------------------------------------------------------------------------------------------
go
set ansi_nulls on
go
set quoted_identifier on
go
-- =============================================
-- Author: Phillip Ma
-- Procedure: Project2.LoadDimProductSubcategory
-- Create date: 04/14/2019
-- Description: Loads DimProductSubcategory table.
-- =============================================
create or alter procedure [Project2].[LoadDimProductSubcategory]
	@UserAuthorizationKey int
as
begin
	set nocount on;
	declare @CurrentTime datetime2 = SYSDATETIME();

	insert into [CH01-01-Dimension].DimProductSubcategory
		(ProductCategoryKey, ProductSubcategory,
		UserAuthorizationKey, DateAdded)
	select distinct dpc.ProductCategoryKey, orig.ProductSubcategory,
			@UserAuthorizationKey, @CurrentTime
	from FileUpload.OriginallyLoadedData as orig  
		inner join [CH01-01-Dimension].DimProductCategory as dpc 
			on orig.ProductCategory = dpc.ProductCategory
	exec Process.usp_TrackWorkFlow @StartTime = @CurrentTime, @WorkFlowDescription = 'Load DimProductSubcategory', @WorkFlowStepTableRowCount = @@RowCount, @UserAuthorization = @UserAuthorizationKey;
end;
----------------------------------------------------------------------------------
go
set ansi_nulls on
go
set quoted_identifier on
go
-- =============================================
-- Author: Phillip Ma
-- Procedure: Project2.LoadDimTerritory
-- Create date: 04/14/2019
-- Description: Loads DimTerritory table.
-- =============================================
create or alter procedure [Project2].[LoadDimTerritory]
	@UserAuthorizationKey int
as
begin
	set nocount on;
	declare @CurrentTime datetime2 = SYSDATETIME();

	insert into [CH01-01-Dimension].[DimTerritory]
		(TerritoryGroup, TerritoryCountry, TerritoryRegion,
		UserAuthorizationKey, DateAdded)
	select distinct orig.TerritoryGroup, orig.TerritoryCountry, orig.TerritoryRegion,
			@UserAuthorizationKey, @CurrentTime
	from FileUpload.OriginallyLoadedData as orig 
		--inner join [CH01-01-Dimension].[DimTerritory] as dt
			--on dt.TerritoryGroup = orig.TerritoryGroup 
			--and dt.TerritoryCountry = orig.TerritoryCountry 
			--and	dt.TerritoryRegion = orig.TerritoryRegion;
	exec Process.usp_TrackWorkFlow @StartTime = @CurrentTime, @WorkFlowDescription = 'Load DimTerritory', @WorkFlowStepTableRowCount = @@RowCount, @UserAuthorization = @UserAuthorizationKey;
end;
------------------------------------------------------------------------------
go
set ansi_nulls on
go
set quoted_identifier on
go
-- =============================================
-- Author: Phillip Ma
-- Procedure: Project2.LoadSalesManagers
-- Create date: 04/14/2019
-- Description: Loads SalesManagers table
-- =============================================
create or alter procedure [Project2].[LoadSalesManagers] 
	@UserAuthorizationKey int
as
begin
	set nocount on;
	declare @CurrentTime datetime2 = SYSDATETIME();

	insert into [CH01-01-Dimension].[SalesManagers]
		(SalesManager, Category, Office,
		UserAuthorizationKey, DateAdded)
	select distinct orig.SalesManager, orig.ProductCategory, NULL,
			@UserAuthorizationKey, @CurrentTime
	from FileUpload.OriginallyLoadedData as orig 
		inner join FileUpload.OriginallyLoadedData as orig2
			on orig.SalesManager = orig2.SalesManager
			 --and Category IS NULL 
			 --and Office IS NULL;
	exec Process.usp_TrackWorkFlow @StartTime = @CurrentTime, @WorkFlowDescription = 'Load SalesManagers', @WorkFlowStepTableRowCount = @@RowCount, @UserAuthorization = @UserAuthorizationKey;
end;
----------------------------------------------------------------------------------------------------------------------
go
set ansi_nulls on
go
set quoted_identifier on
go
-- =============================================
-- Author: Phillip Ma
-- Procedure: Project2.LoadStarSchemaData
-- Create date: 04/14/2019
-- Description: Loads tables to star schema.
-- =============================================
create or alter procedure [Project2].[LoadStarSchemaData]
	@UserAuthorizationKey int
as
begin

	declare @CurrentTime datetime2 = SYSDATETIME();

	-- Drop foreign keys before truncation
	exec [Project2].[DropForeignKeysFromStarSchemaData] @UserAuthorizationKey =@UserAuthorizationKey ;

	-- Truncate star schema data
	exec Project2.TruncateStarSchemaDataUpd @UserAuthorizationKey = @UserAuthorizationKey ;

    -- Load the star schema
	exec [Project2].[LoadDimProductCategory] @UserAuthorizationKey =@UserAuthorizationKey ;
	exec [Project2].[LoadDimProductSubcategory] @UserAuthorizationKey = @UserAuthorizationKey ;
	exec [Project2].[LoadDimProduct] @UserAuthorizationKey = @UserAuthorizationKey;
	exec [Project2].[LoadSalesManagers] @UserAuthorizationKey = @UserAuthorizationKey ;
	exec [Project2].[LoadDimGender] @UserAuthorizationKey =@UserAuthorizationKey ;
	exec [Project2].[LoadDimMaritalStatus] @UserAuthorizationKey = @UserAuthorizationKey ;
	exec [Project2].[LoadDimOccupation] @UserAuthorizationKey = @UserAuthorizationKey ;
	exec [Project2].[LoadDimOrderDate] @UserAuthorizationKey =@UserAuthorizationKey ;
	exec [Project2].[LoadDimTerritory] @UserAuthorizationKey = @UserAuthorizationKey ;
	exec [Project2].[LoadDimCustomer] @UserAuthorizationKey = @UserAuthorizationKey ;
	exec [Project2].[LoadData] @UserAuthorizationKey = @UserAuthorizationKey ;

	-- Recreate foreign keys after schema loading
	exec [Project2].[AddForeignKeysToStarSchemaData] @UserAuthorizationKey = @UserAuthorizationKey ;

	exec Process.usp_TrackWorkFlow @StartTime = @CurrentTime, @WorkFlowDescription = 'Load StarSchema', @WorkFlowStepTableRowCount = @@RowCount, @UserAuthorization = @UserAuthorizationKey ;
end;

exec [Project2].[LoadStarSchemaData]
	@UserAuthorizationKey=4
EXEC [Process].[usp_ShowWorkflowSteps]