/*
-- ============================================= 
-- Author:  Gen. Li
-- Procedure:   Process.WorkflowSteps table 
-- Create date:  4/11
-- Description: A table of each worksteps

-- ==============================================

create schema Process
Go

create table Process.WorkflowSteps(

		WorkFlowStepKey INT NOT NULL primary key,
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
alter procedure Process.usp_TrackWorkFlow 

   @StartTime DATETIME2,    
   @WorkFlowDescription NVARCHAR(100),     
   @WorkFlowStepTableRowCount int,     
   @UserAuthorization int 

as

insert into Process.WorkflowSteps(WorkFlowStepDescription, WorkFlowStepTableRowCount, StartingDateTime, UserAuthorizationKey)
values (@WorkFlowDescription, @WorkFlowStepTableRowCount, @StartTime, @UserAuthorization);

go



-- ============================================= 
-- Author:  Gen. Li
-- Procedure: 
-- Create date:  4/16
-- Description: update new column

-- ==============================================
alter table [CH01-01-Fact].[Data] drop constraint [FK_Data_DimCustomer]
	alter table [CH01-01-Fact].[Data] drop constraint [FK_Data_DimGender] 
	alter table [CH01-01-Fact].[Data] drop constraint [FK_Data_DimMaritalStatus]
	alter table [CH01-01-Fact].[Data] drop constraint [FK_Data_DimOccupation] 
	alter table [CH01-01-Fact].[Data] drop constraint [FK_Data_DimOrderDate] 
	alter table [CH01-01-Fact].[Data] drop constraint [FK_Data_DimProduct]
	alter table [CH01-01-Fact].[Data] drop constraint [FK_Data_DimTerritory]
	alter table [CH01-01-Fact].[Data] drop constraint [FK_Data_SalesManagers]

truncate table [CH01-01-Dimension].[DimCustomer]
truncate table [CH01-01-Dimension].[DimGender]
truncate table [CH01-01-Dimension].[DimMaritalStatus]
truncate table [CH01-01-Dimension].[DimOccupation]
truncate table [CH01-01-Dimension].[DimOrderDate]
truncate table [CH01-01-Dimension].[DimProduct]
truncate table [CH01-01-Dimension].[DimTerritory]
truncate table [CH01-01-Dimension].[SalesManagers]


alter table  [CH01-01-Dimension].[DimCustomer]
alter column UserAuthorizationKey int not NULL
	
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


 */

 -- =============================================
-- Author: Gen. Li
-- Procedure: Project2.LoadDimCustomer
-- Create date: 04/17/2019
-- Description: Loads the DimCustomer table.
-- =============================================


alter procedure Project2.Load_DimCustomer
	@UserAuthorizationKey int
as
begin
	set nocount on;

	insert into [CH01-01-Dimension].[DimCustomer]
		(CustomerName)
	select orig.CustomerName
	from FileUpload.OriginallyLoadedData as orig 
		inner join [CH01-01-Dimension].DimCustomer as dc 
			on dc.CustomerName = orig.CustomerName;
	declare @start DATETIME2 = SYSDATETIME();
	exec Process.usp_TrackWorkFlow @start, "description", 1, @UserAuthorizationKey  
end;
-----------------------------------------------------------------------------------
go
set ansi_nulls on
go
set quoted_identifier on
go


-- =============================================
-- Author: Gen. Li
-- Procedure: Project2.LoadDimCustomer
-- Create date: 04/17/2019
-- Description: Loads the DimCustomer table.
-- =============================================


alter PROCEDURE Project2.Load_DimGender

 @UserAuthorizationKey int
 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO [CH01-01-Dimension].[DimGender]
		(Gender, GenderDescription)
	SELECT DISTINCT dg.Gender, GenderDescription = (CASE dg.Gender
			WHEN 'M' THEN 'MALE'
			ELSE 'FEMALE' END)
	FROM FileUpload.OriginallyLoadedData AS old INNER JOIN
		[CH01-01-Dimension].[DimGender] AS dg ON
			dg.Gender = old.Gender
			declare @start DATETIME2 = SYSDATETIME();
		exec Process.usp_TrackWorkFlow @start, "description", 1, @UserAuthorizationKey 
END
GO
/****** Object:  StoredProcedure [Project1].[Load_DimMaritalStatus]    Script Date: 9/26/2017 11:20:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author: Gen. Li
-- Procedure: Project2.LoadDimCustomer
-- Create date: 04/17/2019
-- Description: Loads the DimCustomer table.
-- =============================================

create or alter procedure Project2.LoadDimMaritalStatus
	@UserAuthorizationKey int
as
begin
	set nocount on;

	insert into [CH01-01-Dimension].[DimMaritalStatus]
		(MaritalStatus, MaritalStatusDescription)
	select distinct dm.MaritalStatus, MaritalStatusDescription  = (case dm.MaritalStatusDescription
			when 'S' then 'SINGLE'
			when 'D' then 'DIVORCED'
			when 'W' then 'WIDOWED'
			else 'MARRIED' end)
	from FileUpload.OriginallyLoadedData as orig 
		inner join [CH01-01-Dimension].[DimMaritalStatus] as dm
			on dm.MaritalStatus = orig.MaritalStatus;

		declare @start DATETIME2 = SYSDATETIME();
		exec Process.usp_TrackWorkFlow @start, "description", 1, @UserAuthorizationKey
end;
--------------------------------------------------------------------------
go
set ansi_nulls on
go
set quoted_identifier on
go


create or alter procedure [Project2].[LoadDimOccupation]
	@UserAuthorizationKey int
as
begin
	set nocount on;

	insert into [CH01-01-Dimension].[DimOccupation]
		(Occupation)
	select orig.Occupation
	from FileUpload.OriginallyLoadedData as orig 
		inner join [CH01-01-Dimension].DimOccupation as do
			on do.Occupation = orig.Occupation;
			declare @start DATETIME2 = SYSDATETIME();
		exec Process.usp_TrackWorkFlow @start, "description", 1, @UserAuthorizationKey
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

	insert into [CH01-01-Dimension].[DimOrderDate]
		(OrderDate, [MonthName], MonthNumber, [Year])
	select dod.OrderDate, dod.[MonthName], dod.MonthNumber, dod.[Year]
	from FileUpload.OriginallyLoadedData as orig 
		inner join [CH01-01-Dimension].[DimOrderDate] as dod
			on dod.OrderDate = orig.OrderDate 
				and dod.[MonthName] = orig.[MonthName] 
				and dod.MonthNumber = orig.MonthNumber 
				and dod.[Year] = orig.[Year];

				declare @start DATETIME2 = SYSDATETIME();
		exec Process.usp_TrackWorkFlow @start, "description", 1, @UserAuthorizationKey
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

	insert into [CH01-01-Dimension].[DimProduct]
		(ProductSubCategoryKey, ProductCategory, ProductSubcategory, ProductCode, ProductName, Color, ModelName)
	select dp.ProductSubcategoryKey, dp.ProductCategory, dp.ProductSubcategory, dp.ProductCode, dp.ProductName, dp.Color,dp.ModelName
	from [CH01-01-Fact].Data as orig 
		inner join [CH01-01-Dimension].[DimProduct] as dp
			on dp.ProductCategory = orig.ProductCategory 
			and dp.ProductSubcategory = orig.ProductSubcategory 
			and dp.ProductCode = orig.ProductCode 
			and dp.ProductName = orig.ProductName 
			and dp.Color = orig.Color 
			and dp.ModelName = orig.ModelName 
		inner join [CH01-01-Dimension].DimProductSubcategory as dps
			on dp.ProductSubcategoryKey = dps.ProductSubcategoryKey;

			declare @start DATETIME2 = SYSDATETIME();
		exec Process.usp_TrackWorkFlow @start, "description", 1, @UserAuthorizationKey
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

	insert into [CH01-01-Dimension].DimProductCategory
		(ProductCategoryKey, ProductCategory)
	select dpc.ProductCategoryKey, orig.ProductCategory 
	from FileUpload.OriginallyLoadedData as orig 
		inner join [CH01-01-Dimension].DimProductCategory as dpc
			on dpc.ProductCategory = orig.ProductCategory 
			and dpc.ProductCategoryKey = orig.ProductCategoryKey;

			declare @start DATETIME2 = SYSDATETIME();
		exec Process.usp_TrackWorkFlow @start, "description", 1, @UserAuthorizationKey
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

	insert into [CH01-01-Dimension].DimProductSubcategory
		(ProductSubcategoryKey, ProductCategoryKey, ProductSubcategory)
	select orig.ProductSubcategory, dpc.ProductCategoryKey, orig.ProductSubcategory
	from FileUpload.OriginallyLoadedData as orig 
		inner join [CH01-01-Dimension].DimProductSubcategory as dps
			on dps.ProductSubcategoryKey = orig.ProductSubcategory 
			and	dps.ProductSubcategory = orig.ProductSubcategory 
		inner join [CH01-01-Dimension].DimProductCategory as dpc 
			on dpc.ProductCategoryKey = dps.ProductCategoryKey
			and dpc.ProductSubcategoryKey = dps.ProductSubcategoryKey;

			declare @start DATETIME2 = SYSDATETIME();
		exec Process.usp_TrackWorkFlow @start, "description", 1, @UserAuthorizationKey
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

	insert into [CH01-01-Dimension].[DimTerritory]
		(TerritoryGroup, TerritoryCountry, TerritoryRegion)
	select dt.TerritoryGroup, dt.TerritoryCountry, dt.TerritoryRegion
	from FileUpload.OriginallyLoadedData as orig 
		inner join [CH01-01-Dimension].[DimTerritory] as dt
			on dt.TerritoryGroup = orig.TerritoryGroup 
			and dt.TerritoryCountry = orig.TerritoryCountry 
			and	dt.TerritoryRegion = orig.TerritoryRegion;

			declare @start DATETIME2 = SYSDATETIME();
		exec Process.usp_TrackWorkFlow @start, "description", 1, @UserAuthorizationKey
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
-- Description: Loads SalesManagers table.
-- =============================================
create or alter procedure [Project2].[LoadSalesManagers] 
	@UserAuthorizationKey int
as
begin
	set nocount on;

	insert into [CH01-01-Dimension].[SalesManagers]
		(SalesManager, Category, Office)
	select sm.SalesManager, sm.Category, sm.Office
	from FileUpload.OriginallyLoadedData as orig 
		inner join [CH01-01-Dimension].[SalesManagers] as sm
			on sm.SalesManager = orig.SalesManager
			 and Category IS NULL 
			 and Office IS NULL;

			 declare @start DATETIME2 = SYSDATETIME();
		exec Process.usp_TrackWorkFlow @start, "description", 1, @UserAuthorizationKey
end;
----------------------------------------------------------------------------------------------------------------------
go
set ansi_nulls on
go
set quoted_identifier on
go
