USE [crm_online_replication]

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '_ds' AND TABLE_NAME = 'Community')
BEGIN
    DROP TABLE [_ds].[Community];
END

-- Creating the 'Community' table
CREATE TABLE [_ds].[Community] (
    [name] nvarchar(100),
    [teamid] nvarchar(100),
    [ssi_communityou] nvarchar(100),
    [organizationid] nvarchar(100),
    [ssi_zippostalcode] nvarchar(16),
    [ssi_externalname] nvarchar(100),
    [businessunitidname] nvarchar(100)
);

-- Inserting sample data
INSERT INTO [_ds].[Community] ([name], [teamid], [ssi_communityou], [organizationid], [ssi_zippostalcode], [ssi_externalname], [businessunitidname], [LastUpdated], [LastUpdatedBy])
VALUES 
    ('Joe', 'Thomas', GETDATE(), <LastUpdatedBy, nvarchar(50)>);

-- Selecting distinct records from another table to populate the 'Community' table
SELECT DISTINCT [name], [teamid], [ssi_communityou], [organizationid], [ssi_zippostalcode], [ssi_externalname], [businessunitidname]
FROM [dbo].[team];

-- Adding audit columns for record tracking
ALTER TABLE [_ds].[Community] ADD datecreated AS GETDATE();
ALTER TABLE [_ds].[Community] ADD datemodified AS GETDATE();
