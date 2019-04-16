USE BIClass
GO

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

USE BIClass
GO

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

GO

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

Go

-- ============================================= 
-- Author:  Gen. Li
-- Procedure:   Process.usp_TrackWorkFlow 
-- Create date:  4/11
-- Description: A stored procedure to track the workflow

-- ==============================================

create procedure Process.usp_TrackWorkFlow 

   @StartTime DATETIME2,    
   @WorkFlowDescription NVARCHAR(100),     
   @WorkFlowStepTableRowCount int,     
   @UserAuthorization int 

as

insert into Process.WorkflowSteps(WorkFlowStepDescription, WorkFlowStepTableRowCount, StartingDateTime, UserAuthorizationKey)
values (@WorkFlowDescription, @WorkFlowStepTableRowCount, @StartTime, @UserAuthorization);

go

-- =============================================
-- Author: Kirsten Pevidal
-- Procedure: Create Table [CH01-01-Dimension].[DimProductCategory] and [CH01-01-Dimension].[DimProductSubcategory]
-- Create date: 04/13/2019
-- Description: A table for product categorization
-- =============================================USE [BIClass]
GO

/****** Object:  Table [dbo].[CH01-01-Dimension.DimProductCategory]    Script Date: 4/13/2019 9:56:05 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [CH01-01-Dimension].[DimProductCategory](
	[ProductCategoryKey] [int] NOT NULL,
	[Productcategory] [varchar](20) NULL
) 
GO

CREATE TABLE [CH01-01-Dimension].[DimProductSubCategory](
	[ProductSubcategoryKey] [int] NOT NULL,
	[ProductCategoryKey] [int] NOT NULL,
	[ProductSubcategory] [varchar](20) NULL
) 
GO--SET PRIMARY KEY
ALTER TABLE [CH01-01-Dimension].[DimProductCategory] ADD PRIMARY KEY ([ProductCategoryKey])ALTER TABLE [CH01-01-Dimension].[DimProductSubcategory] ADD PRIMARY KEY ([ProductSubcategoryKey])--SET PARENT-CHILD RELATIONSHIP (DIMPRODUCTCATEGORY -> DIMPRODUCTSUBCATEGORY)ALTER TABLE [CH01-01-Dimension].[DimProductSubcategory]  WITH CHECK 
ADD  CONSTRAINT [FK_DimProductSubcategory_DimProductCategory] FOREIGN KEY([ProductCategoryKey])
REFERENCES [CH01-01-Dimension].[DimProductCategory] ([ProductCategoryKey])ALTER TABLE [CH01-01-Dimension].[DimProductSubcategory] CHECK CONSTRAINT [FK_DimProductSubcategory_DimProductCategory]--SET CHILD-GRANDCHILD RELATIONSHIP (DIMPRODUCTSUBCATEGORY -> DIMPRODUCT)ALTER TABLE [CH01-01-Dimension].[DimProduct]  WITH CHECK 
ADD  CONSTRAINT [FK_DimProduct_DimProductSubcategory] FOREIGN KEY([ProductSubcategoryKey])
REFERENCES [CH01-01-Dimension].[DimProductSubcategory] ([ProductSubcategoryKey])
ALTER TABLE [CH01-01-Dimension].[DimProduct] CHECK CONSTRAINT [FK_DimProduct_DiroductSubcategory]

GO

-- -- WIP
-- ALTER PROCEDURE Project2.Create_Sequence_Primary_Key
-- AS
-- BEGIN
--     DROP SEQUENCE IF EXISTS PkSequence.DimCustomerSequenceObject;
--     CREATE SEQUENCE PkSequence.DimCustomerSequenceObject AS INT MINVALUE 1;
--     DROP SEQUENCE IF EXISTS PkSequence.DimGenderSequenceObject;
--     CREATE SEQUENCE PkSequence.DimGenderSequenceObject AS INT MINVALUE 1;
--     DROP SEQUENCE IF EXISTS PkSequence.DimMaritalStatusSequenceObject;
--     CREATE SEQUENCE PkSequence.DimMaritalStatusSequenceObject AS INT MINVALUE 1;
--     DROP SEQUENCE IF EXISTS PkSequence.DimOccupationSequenceObject;
--     CREATE SEQUENCE PkSequence.DimOccupationSequenceObject AS INT MINVALUE 1;
--     DROP SEQUENCE IF EXISTS PkSequence.DimOrderDateSequenceObject;
--     CREATE SEQUENCE PkSequence.DimOrderDateSequenceObject AS INT MINVALUE 1;
--     DROP SEQUENCE IF EXISTS PkSequence.DimProductSequenceObject;
--     CREATE SEQUENCE PkSequence.DimProductSequenceObject AS INT MINVALUE 1;
--     DROP SEQUENCE IF EXISTS PkSequence.DimProductCategorySequenceObject;
--     CREATE SEQUENCE PkSequence.DimProductCategorySequenceObject AS INT MINVALUE 1;
--     DROP SEQUENCE IF EXISTS PkSequence.DimProductSubCategorySequenceObject;
--     CREATE SEQUENCE PkSequence.DimProductSubCategorySequenceObject AS INT MINVALUE 1;
--     DROP SEQUENCE IF EXISTS PkSequence.DimTerritoryCategorySequenceObject;
--     CREATE SEQUENCE PkSequence.DimTerritorySequenceObject AS INT MINVALUE 1;
--     DROP SEQUENCE IF EXISTS PkSequence.SalesManagersSequenceObject;
--     CREATE SEQUENCE PkSequence.SalesManagerSequenceObject AS INT MINVALUE 1;

-- END

-- TRUNCATE TABLE [CH01-01-Dimension].DimCustomer;

CREATE SEQUENCE PkSequence.DimCustomerSequenceObject AS INT MINVALUE 1;
ALTER TABLE [CH01-01-Dimension].DimCustomer
DROP CONSTRAINT [PK__DimCusto__95011E64C4078D1B];

ALTER TABLE [CH01-01-Dimension].DimCustomer
    DROP COLUMN CustomerKey;

ALTER TABLE [CH01-01-Dimension].DimCustomer
    ADD CustomerKey INT NOT NULL DEFAULT(NEXT VALUE FOR PkSequence.DimCustomerSequenceObject) PRIMARY KEY CLUSTERED;

ALTER TABLE [CH01-01-Dimension].DimCustomer
DROP CONSTRAINT DF__DimCustom__Custo__7DCDAAA2;

-- DROP SEQUENCE PkSequence.DimCustomerSequenceObject;
-- CREATE SEQUENCE
-- PkSequence.DimCustomerSequenceObject
--  AS [int]
--  START WITH 1
--  INCREMENT BY 1
--  MINVALUE 1
--  MAXVALUE 2147483647
--  CACHE
-- GO

ALTER TABLE [CH01-01-Dimension].DimCustomer
ADD UserAuthorizationKey INT NOT NULL