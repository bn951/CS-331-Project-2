use [BIClass];
go
set ansi_nulls on
go
set quoted_identifier on
go
-- =============================================
-- Author: Phillip Ma
-- Procedure: Project2.AddForeignKeysToStarSchemaData
-- Create date: 04/14/2019
-- Description: Adds foreign keys.
-- =============================================
create procedure [Project2].[AddForeignKeysToStarSchemaData]
	@UserAuthorizationKey int
as
begin
	set nocount on;

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
end;
------------------------------------------------------------------------------------------
use [BIClass];
go
set ansi_nulls on
go
set quoted_identifier on
go
-- =============================================
-- Author: Phillip Ma
-- Procedure: Project2.DropForeignKeysFromStarSchemaData
-- Create date: 04/14/2019
-- Description: Drops foreign keys.
-- =============================================
create procedure [Project2].[DropForeignKeysFromStarSchemaData]
	@UserAuthorizationKey int
as
begin
	set nocount on;

	alter table [CH01-01-Fact].[Data] drop constraint [FK_Data_DimCustomer]
	alter table [CH01-01-Fact].[Data] drop constraint [FK_Data_DimGender] 
	alter table [CH01-01-Fact].[Data] drop constraint [FK_Data_DimMaritalStatus]
	alter table [CH01-01-Fact].[Data] drop constraint [FK_Data_DimOccupation] 
	alter table [CH01-01-Fact].[Data] drop constraint [FK_Data_DimOrderDate] 
	alter table [CH01-01-Fact].[Data] drop constraint [FK_Data_DimProduct]
	alter table [CH01-01-Fact].[Data] drop constraint [FK_Data_DimTerritory]
	alter table [CH01-01-Fact].[Data] drop constraint [FK_Data_SalesManagers]
end;
----------------------------------------------------------------------------------------
use [BIClass];
go
set ansi_nulls on
go
set quoted_identifier on
go
-- =============================================
-- Author: Phillip Ma
-- Procedure: Project2.LoadData
-- Create date: 04/14/2019
-- Description: Loads data.
-- =============================================
create procedure [Project2].[LoadData]
	@UserAuthorizationKey int
as
begin
	
	set nocount on;
	
	insert into [CH01-01-Fact].Data
		(SalesManagerKey, 
		OccupationKey,
		TerritoryKey, 
		ProductKey, 
		CustomerKey,
		ProductCategory, 
		SalesManager, 
		ProductSubcategory, 
		ProductCode, 
		ProductName, 
		Color, 
		ModelName, 
		OrderQuantity, 
		UnitPrice,
		ProductStandardCost, 
		SalesAmount, 
		OrderDate, 
		[MonthName], 
		MonthNumber, 
		[Year], 
		CustomerName, 
		MaritalStatus, 
		Gender, 
		Education,
		Occupation, 
		TerritoryRegion, 
		TerritoryCountry, 
		TerritoryGroup)
	select 
		orig.SalesManagerKey, 
		orig.OccupationKey,
		dt.TerritoryKey, 
		dp.ProductKey, 
		dc.CustomerKey,
		orig.ProductCategory, 
		orig.SalesManager, 
		orig.ProductSubcategory, 
		orig.ProductCode, 
		orig.ProductName, 
		orig.Color, 
		orig.ModelName, 
		orig.OrderQuantity, 
		orig.UnitPrice,
		orig.ProductStandardCost, 
		orig.SalesAmount, 
		orig.OrderDate, 
		orig.[MonthName], 
		orig.MonthNumber, 
		orig.[Year], 
		orig.CustomerName, 
		orig.MaritalStatus, 
		orig.Gender, 
		orig.Education,
		orig.Occupation, 
		orig.TerritoryRegion, 
		orig.TerritoryCountry, 
		orig.TerritoryGroup
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
end;
--------------------------------------------------------------------------------------
use [BIClass];
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
create procedure [Project2].[LoadDimCustomer]
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
end;
-----------------------------------------------------------------------------------
use [BIClass];
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
create procedure [Project2].[LoadDimGender]
	@UserAuthorizationKey int
as
begin
	set nocount on;

	insert into [CH01-01-Dimension].[DimGender]
		(Gender, GenderDescription)
	select distinct dg.Gender, GenderDescription = (case dg.Gender
			when 'M' then 'MALE'
			else 'FEMALE' end)
	from FileUpload.OriginallyLoadedData as orig 
		inner join [CH01-01-Dimension].[DimGender] as dg 
			on dg.Gender = orig.Gender
end;
------------------------------------------------------------------------
use [BIClass];
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
create procedure [Project2].[LoadDimMaritalStatus]
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
end;
--------------------------------------------------------------------------
use [BIClass];
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
create procedure [Project2].[LoadDimOccupation]
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
end;
-------------------------------------------------------------------------------
use [BIClass];
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
create procedure [Project2].[LoadDimOrderDate]
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
end;
---------------------------------------------------------------------------------------------
use [BIClass];
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
create procedure [Project2].[LoadDimProduct]
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
end;
------------------------------------------------------------------------------
use [BIClass];
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
create procedure [Project2].[LoadDimProductCategory]
	@UserAuthorizationKey int
as
begin
	set nocount on;

	insert into [CH01-01-Dimension].DimProductCategory
		(ProductCategoryKey, ProductCategory)
	select orig.ProductCategoryKey, orig.ProductCategory 
	from FileUpload.OriginallyLoadedData as orig 
		inner join [CH01-01-Dimension].DimProductCategory as dpc
			on dpc.ProductCategory = orig.ProductCategory 
			and dpc.ProductCategoryKey = orig.ProductCategoryKey;
end;
----------------------------------------------------------------------------------------------
use [BIClass];
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
create procedure [Project2].[LoadDimProductSubcategory]
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
end;
----------------------------------------------------------------------------------
use [BIClass];
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
create procedure [Project1].[LoadDimTerritory]
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
end;
------------------------------------------------------------------------------
use [BIClass];
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
create procedure [Project2].[LoadSalesManagers] 
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
end;
----------------------------------------------------------------------------------------------------------------------
use [BIClass];
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
create procedure [Project2].[LoadStarSchemaData]
--alter procedure [Project2].[LoadStarSchemaData]
	@UserAuthorizationKey int
as
begin
    set nocount on;

	-- Drop foreign keys before truncation
	exec [Project2].[DropForeignKeysFromStarSchemeData];

    --	Check row count before truncation
    exec [Project2].[ShowTableStatusRowCount]
		@UserAuthorizationKey = -1,
		@TableStatus = N'''Pre-truncate of tables''';

	-- Truncate star schema data
	exec [Project2].[TruncateStarSchemaData];

    -- Load the star schema
	exec [Project2].[LoadDimProductCategory] @UserAuthorizationKey = -1;
	exec [Project2].[LoadDimProductSubcategory] @UserAuthorizationKey = -1;
	exec [Project2].[LoadDimProduct] @UserAuthorizationKey = -1;
	exec [Project2].[LoadSalesManagers] @UserAuthorizationKey = -1;
	exec [Project2].[LoadDimGender] @UserAuthorizationKey = -1;
	exec [Project2].[LoadDimMaritalStatus] @UserAuthorizationKey = -1;
	exec [Project2].[LoadDimOccupation] @UserAuthorizationKey = -1;
	exec [Project2].[LoadDimOrderDate] @UserAuthorizationKey = -1;
	exec [Project2].[LoadDimTerritory] @UserAuthorizationKey = -1;
	exec [Project2].[LoadDimCustomer] @UserAuthorizationKey = -1;
	exec [Project2].[LoadData] @UserAuthorizationKey = -1;

	-- Check row count after truncation
    exec [Project2].[ShowTableStatusRowCount]
		@UserAuthorizationKey = -1,
		@TableStatus = N'''Post-truncate of tables''';

	-- Recreate foreign keys after schema loading
	exec [Project1].[AddForeignKeysToStarSchemeData] @UserAuthorizationKey = -1;
end;
---------------------------------------------------------------------------------------------------------------------
use [BIClass];
go
set ansi_nulls on
go
set quoted_identifier on
go
-- =============================================
-- Author: Phillip Ma
-- Procedure: Project2.TruncateStarSchemaData
-- Create date: 04/14/2019
-- Description: Truncates schema data.
-- =============================================
create procedure [Project2].[TruncateStarSchemaData]
--alter procedure [Project2].[TruncateStarSchemaData]
	@UserAuthorizationKey int
as
begin
	set nocount on;

	print 'insert your statements within the Begin\End block which is the equivalent of the Java { \ }'

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
end;