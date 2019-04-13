- =============================================
-- Author: Kirsten Pevidal
-- Procedure: Create Table [CH01-01-Dimension].[DimProductCategory] and [CH01-01-Dimension].[DimProductSubcategory]
-- Create date: 04/13/2019
-- Description: A table for product categorization
-- =============================================USE [BIClass]
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
GO--SET PRIMARY KEY
ALTER TABLE [CH01-01-Dimension].[DimProductCategory] ADD PRIMARY KEY ([ProductCategoryKey])ALTER TABLE [CH01-01-Dimension].[DimProductSubcategory] ADD PRIMARY KEY ([ProductSubcategoryKey])--SET PARENT-CHILD RELATIONSHIP (DIMPRODUCTCATEGORY -> DIMPRODUCTSUBCATEGORY)ALTER TABLE [CH01-01-Dimension].[DimProductSubcategory]  WITH CHECK 
ADD  CONSTRAINT [FK_DimProductSubcategory_DimProductCategory] FOREIGN KEY([ProductCategoryKey])
REFERENCES [CH01-01-Dimension].[DimProductCategory] ([ProductCategoryKey])ALTER TABLE [CH01-01-Dimension].[DimProductSubcategory] CHECK CONSTRAINT [FK_DimProductSubcategory_DimProductCategory]--SET CHILD-GRANDCHILD RELATIONSHIP (DIMPRODUCTSUBCATEGORY -> DIMPRODUCT)ALTER TABLE [CH01-01-Dimension].[DimProduct]  WITH CHECK 
ADD  CONSTRAINT [FK_DimProduct_DimProductSubcategory] FOREIGN KEY([ProductSubcategoryKey])
REFERENCES [CH01-01-Dimension].[DimProductSubcategory] ([ProductSubcategoryKey])
ALTER TABLE [CH01-01-Dimension].[DimProduct] CHECK CONSTRAINT [FK_DimProduct_DiroductSubcategory]