--liquibase formatted sql

--changeset database.admin:1 labels:1.0.0 context:dev,uat,prod
--comment: Initialize the base schemas.
CREATE SCHEMA [business_domain];
GO

--changeset database.admin:2 labels:1.0.0 context:dev,uat,prod
--comment: The following are tables to be released to the database.
CREATE TABLE [business_domain].[person] (
    [id] INT IDENTITY(1,1) PRIMARY KEY,
    [first_name] NVARCHAR(50) NOT NULL,
    [last_name] NVARCHAR(50) NOT NULL,
    [age] INT NOT NULL,
    [created_timestamp] DATETIME2 DEFAULT GETUTCDATE(),
    [last_modified_timestamp] DATETIME2 DEFAULT GETUTCDATE()
);
GO

--changeset database.admin:3 labels:1.0.0,fake_data context:dev
--comment: The following inserts to populate fake test data into the database tables.

INSERT INTO [business_domain].[person]
(first_name, last_name, age)
VALUES
('Kyle', 'Roberts', 24),
('Alice', 'Jefferson', 34),
('Jessica', 'Thompson', 32);