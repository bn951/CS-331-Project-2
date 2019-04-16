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