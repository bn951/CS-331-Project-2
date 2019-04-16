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
