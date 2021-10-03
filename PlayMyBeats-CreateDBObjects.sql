/* PlayMyBeats-CreateDBObjects.sql
 * Author: Jeff Dillon
 * Date Created: 10/3/2021
 * Description: DDL PlayMyBeats app
*/


-- Create a new table called '[Loans]' in schema '[dbo]'
-- Drop the table if it already exists
IF OBJECT_ID('[dbo].[Loans]', 'U') IS NOT NULL
DROP TABLE [dbo].[Loans]
GO

-- Create a new table called '[Albums]' in schema '[dbo]'
-- Drop the table if it already exists
IF OBJECT_ID('[dbo].[Albums]', 'U') IS NOT NULL
DROP TABLE [dbo].[Albums]
GO

-- Create a new table called '[Bands]' in schema '[dbo]'
-- Drop the table if it already exists
IF OBJECT_ID('[dbo].[Bands]', 'U') IS NOT NULL
DROP TABLE [dbo].[Bands]
GO
-- Create the table in the specified schema
CREATE TABLE [dbo].[Bands]
(
    [BandId] INT NOT NULL IDENTITY PRIMARY KEY, -- Primary Key column
    [BandName] NVARCHAR(255) NOT NULL
);
GO


-- Create the table in the specified schema
CREATE TABLE [dbo].[Albums]
(
    [AlbumId] INT NOT NULL IDENTITY PRIMARY KEY, -- Primary Key column
    [BandId] INT NOT NULL,
    [AlbumName] NVARCHAR(255),
    FOREIGN KEY(BandId) REFERENCES Bands(BandId)
);
GO

-- Create a new table called '[Friends]' in schema '[dbo]'
-- Drop the table if it already exists
IF OBJECT_ID('[dbo].[Friends]', 'U') IS NOT NULL
DROP TABLE [dbo].[Friends]
GO
-- Create the table in the specified schema
CREATE TABLE [dbo].[Friends]
(
    [FriendId] INT NOT NULL IDENTITY PRIMARY KEY, -- Primary Key column
    [FriendName] NVARCHAR(255)
);
GO

-- Create a new table called '[Loans]' in schema '[dbo]'
-- Drop the table if it already exists
IF OBJECT_ID('[dbo].[Loans]', 'U') IS NOT NULL
DROP TABLE [dbo].[Loans]
GO
-- Create the table in the specified schema
CREATE TABLE [dbo].[Loans]
(
    [FriendId] INT NOT NULL, 
    [AlbumId] INT NOT NULL,
    FOREIGN KEY(FriendId) REFERENCES Friends(FriendId),
    FOREIGN KEY(AlbumId) REFERENCES Albums(AlbumId)
);
GO

CREATE NONCLUSTERED INDEX IX_FriendName ON [dbo].[Friends] ([FriendName] DESC) 
GO


CREATE NONCLUSTERED INDEX IX_BandName ON [dbo].[Bands] ([BandName] DESC) 
GO

-- Create a new stored procedure called 'ReadAlbums' in schema 'dbo'
-- Drop the stored procedure if it already exists
IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'ReadAlbums'
    AND ROUTINE_TYPE = N'PROCEDURE'
)
DROP PROCEDURE dbo.ReadAlbums
GO

CREATE PROCEDURE dbo.ReadAlbums
    @BandName NVARCHAR(255) = NULL,
    @FriendName NVARCHAR(255) = NULL
AS
BEGIN
    IF @FriendName IS NULL
    BEGIN
        SELECT Bands.BandName AS 'Band', Albums.AlbumName AS 'Album', ISNULL(Friends.FriendName,'') AS 'LoanedTo'
        FROM Albums 
            INNER JOIN Bands ON Albums.BandId = Bands.BandId
            LEFT JOIN Loans ON Albums.AlbumId = Loans.AlbumId
            LEFT JOIN Friends ON Loans.FriendId = Friends.FriendId
        WHERE Bands.BandName = ISNULL(@BandName, Bands.BandName)
        AND (Friends.FriendName = ISNULL(@FriendName, Friends.FriendName) OR Friends.FriendName IS NULL)
    END
    ELSE
    BEGIN
        SELECT Bands.BandName AS 'Band', Albums.AlbumName AS 'Album', ISNULL(Friends.FriendName,'') AS 'LoanedTo'
        FROM Albums 
            INNER JOIN Bands ON Albums.BandId = Bands.BandId
            LEFT JOIN Loans ON Albums.AlbumId = Loans.AlbumId
            LEFT JOIN Friends ON Loans.FriendId = Friends.FriendId
        WHERE Bands.BandName = ISNULL(@BandName, Bands.BandName)
        AND (Friends.FriendName = ISNULL(@FriendName, Friends.FriendName))
    END
END
GO

-- Create a new stored procedure called 'CreateAlbum' in schema 'dbo'
-- Drop the stored procedure if it already exists
IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'CreateAlbum'
    AND ROUTINE_TYPE = N'PROCEDURE'
)
DROP PROCEDURE dbo.CreateAlbum
GO
CREATE PROCEDURE dbo.CreateAlbum
    @AlbumName NVARCHAR(255),
    @BandName NVARCHAR(255)
AS
BEGIN
    BEGIN TRY
    IF((@BandName IS NULL OR @AlbumName IS NULL) OR (@BandName = '' OR @AlbumName = ''))
    BEGIN
        RAISERROR('@BandName and @AlbumName cannot be null or empty',18,0) 
    END
    ELSE
    BEGIN
        DECLARE @BandCount INT = (SELECT COUNT(1) FROM Bands WHERE BandName = @BandName) 
        DECLARE @BandId INT
        IF(@BandCount = 0)
        BEGIN
            INSERT INTO Bands VALUES (@BandName)
            SET @BandId = (SELECT scope_identity())
        END
        ELSE
        BEGIN
           SET @BandId = (SELECT Bands.BandId FROM Bands WHERE Bands.BandName = @BandName)
        END
        INSERT INTO Albums VALUES (@BandId, @AlbumName)
    END
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT; 
        SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE(); 
        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState ); 
    END CATCH

END
GO

-- Create a new stored procedure called 'DeleteAlbum' in schema 'dbo'
-- Drop the stored procedure if it already exists
IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'DeleteAlbum'
    AND ROUTINE_TYPE = N'PROCEDURE'
)
DROP PROCEDURE dbo.DeleteAlbum
GO

CREATE PROCEDURE dbo.DeleteAlbum
    @AlbumName NVARCHAR(255)
AS
BEGIN
    DECLARE @AlbumId INT = (SELECT Albums.AlbumId FROM Albums WHERE AlbumName = @AlbumName)
    DELETE FROM Loans WHERE Loans.AlbumId = @AlbumId;
    DELETE FROM Albums WHERE Albums.AlbumId = @AlbumId
END
GO


-- Create a new stored procedure called 'UpdateAlbum' in schema 'dbo'
-- Drop the stored procedure if it already exists
IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'UpdateAlbum'
    AND ROUTINE_TYPE = N'PROCEDURE'
)
DROP PROCEDURE dbo.UpdateAlbum
GO

CREATE PROCEDURE dbo.UpdateAlbum
    @OldAlbumName NVARCHAR(255),
    @NewAlbumName NVARCHAR(255)
AS
BEGIN
    UPDATE Albums SET Albums.AlbumName = @NewAlbumName WHERE Albums.AlbumName = @OldAlbumName
END
GO

-- Create a new stored procedure called 'LoanAlbum' in schema 'dbo'
-- Drop the stored procedure if it already exists
IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'LoanAlbum'
    AND ROUTINE_TYPE = N'PROCEDURE'
)
DROP PROCEDURE dbo.LoanAlbum
GO
-- Create the stored procedure in the specified schema
CREATE PROCEDURE dbo.LoanAlbum
    @AlbumName NVARCHAR(255),
    @FriendName NVARCHAR(255)
AS
BEGIN
    DECLARE @AlbumId INT = (SELECT Albums.AlbumId FROM Albums WHERE Albums.AlbumName = @AlbumName);
    DECLARE @FriendId INT = (SELECT Friends.FriendId FROM Friends WHERE Friends.FriendName = @FriendName);

    BEGIN TRY
        IF EXISTS (SELECT * FROM Loans WHERE AlbumId = @AlbumId)
            RAISERROR('Album already loaned out',18,0)
        
        INSERT INTO Loans VALUES (@FriendId, @AlbumId);
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT; 
        SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE(); 
        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState ); 
    END CATCH

    
END
GO


-- Create a new stored procedure called 'ReturnAlbum' in schema 'dbo'
-- Drop the stored procedure if it already exists
IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'ReturnAlbum'
    AND ROUTINE_TYPE = N'PROCEDURE'
)
DROP PROCEDURE dbo.ReturnAlbum
GO
-- Create the stored procedure in the specified schema
CREATE PROCEDURE dbo.ReturnAlbum
    @AlbumName NVARCHAR(255)
AS
BEGIN
    DECLARE @AlbumId INT = (SELECT Albums.AlbumId FROM Albums WHERE Albums.AlbumName = @AlbumName)
    DELETE FROM Loans WHERE Loans.AlbumId = @AlbumId
END
GO

