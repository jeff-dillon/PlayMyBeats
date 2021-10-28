/* PlayMyBeats-Createpmbbjects.sql
 * Author: Jeff Dillon
 * Date Created: 10/3/2021
 * Description: DDL PlayMyBeats app
 *
 * Tables:
 *    Bands (BandId, BandName)
 *    Albums (AlbumId, BandId, AlbumName)
 *    Friends (FriendId, FriendName)
 *    Loans (FriendId, AlbumId)
 *
 * Indexes:
 *    IX_FriendName
 *    IX_AlbumName
 *
 * Stored Procedures
 *    ReadAlbums @BandName, @FriendName
 *    CreateAlbum @BandName, @AlbumName
 *    DeleteAlbum @AlbumName
 *    UpdateAlbum @OldAlbumName, @NewAlbumName
 *    LoanAlbum @AlbumName, @FriendName
 *    ReturnAlbum @AlbumName
 *
*/

SET NOCOUNT ON;
GO



/******************************************************

    Tables

******************************************************/


IF OBJECT_ID('Loans', 'U') IS NOT NULL
    DROP TABLE Loans;

IF OBJECT_ID('Albums', 'U') IS NOT NULL
    DROP TABLE Albums;

IF OBJECT_ID('Bands', 'U') IS NOT NULL
    DROP TABLE Bands;

IF OBJECT_ID('Friends', 'U') IS NOT NULL
    DROP TABLE Friends;


CREATE TABLE Bands
(
    [BandId] INT NOT NULL IDENTITY PRIMARY KEY, -- Primary Key column
    [BandName] NVARCHAR(255) NOT NULL
);
GO


CREATE TABLE Albums
(
    [AlbumId] INT NOT NULL IDENTITY PRIMARY KEY, -- Primary Key column
    [BandId] INT NOT NULL,
    [AlbumName] NVARCHAR(255),
    FOREIGN KEY(BandId) REFERENCES Bands(BandId)
);
GO


CREATE TABLE Friends
(
    [FriendId] INT NOT NULL IDENTITY PRIMARY KEY, -- Primary Key column
    [FriendName] NVARCHAR(255)
);
GO


CREATE TABLE Loans
(
    [FriendId] INT NOT NULL,
    [AlbumId] INT NOT NULL,
    [LoanDate] DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(FriendId) REFERENCES Friends(FriendId),
    FOREIGN KEY(AlbumId) REFERENCES Albums(AlbumId)
);
GO


/******************************************************

    Indexes

******************************************************/


CREATE NONCLUSTERED INDEX IX_FriendName ON Friends (FriendName DESC)
GO


CREATE NONCLUSTERED INDEX IX_BandName ON Bands (BandName DESC)
GO


/******************************************************

    Stored Procedures

******************************************************/


IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE SPECIFIC_NAME = N'ReadAlbums' AND ROUTINE_TYPE = N'PROCEDURE')
DROP PROCEDURE ReadAlbums
GO

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE SPECIFIC_NAME = N'CreateAlbum' AND ROUTINE_TYPE = N'PROCEDURE')
DROP PROCEDURE CreateAlbum
GO

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE SPECIFIC_NAME = N'DeleteAlbum' AND ROUTINE_TYPE = N'PROCEDURE')
DROP PROCEDURE DeleteAlbum
GO

IF EXISTS ( SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE SPECIFIC_NAME = N'UpdateAlbum' AND ROUTINE_TYPE = N'PROCEDURE')
DROP PROCEDURE UpdateAlbum
GO

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE SPECIFIC_NAME = N'LoanAlbum' AND ROUTINE_TYPE = N'PROCEDURE')
DROP PROCEDURE LoanAlbum
GO

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE SPECIFIC_NAME = N'ReturnAlbum' AND ROUTINE_TYPE = N'PROCEDURE')
DROP PROCEDURE ReturnAlbum
GO




CREATE PROCEDURE ReadAlbums @BandName NVARCHAR(255) = NULL, @FriendName NVARCHAR(255) = NULL AS
BEGIN
    IF @FriendName IS NULL
    BEGIN
        SELECT Bands.BandName AS 'Band', Albums.AlbumName AS 'Album', 
            ISNULL(Friends.FriendName,'') AS 'LoanedTo', ISNULL(FORMAT(Loans.LoanDate, 'd', 'en-us'),'') AS 'LoanedSince'
        FROM Albums
            INNER JOIN Bands ON Albums.BandId = Bands.BandId
            LEFT JOIN Loans ON Albums.AlbumId = Loans.AlbumId
            LEFT JOIN Friends ON Loans.FriendId = Friends.FriendId
        WHERE Bands.BandName = ISNULL(@BandName, Bands.BandName)
        AND (Friends.FriendName = ISNULL(@FriendName, Friends.FriendName) OR Friends.FriendName IS NULL)
    END
    ELSE
    BEGIN
        SELECT Bands.BandName AS 'Band', Albums.AlbumName AS 'Album', ISNULL(Friends.FriendName,'') AS 'LoanedTo',
        ISNULL(FORMAT(Loans.LoanDate, 'd', 'en-us'),'') AS 'LoanedSince'
        FROM Albums
            INNER JOIN Bands ON Albums.BandId = Bands.BandId
            LEFT JOIN Loans ON Albums.AlbumId = Loans.AlbumId
            LEFT JOIN Friends ON Loans.FriendId = Friends.FriendId
        WHERE Bands.BandName = ISNULL(@BandName, Bands.BandName)
        AND (Friends.FriendName = ISNULL(@FriendName, Friends.FriendName))
    END
END
GO

CREATE PROCEDURE CreateAlbum @AlbumName NVARCHAR(255), @BandName NVARCHAR(255) AS
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


CREATE PROCEDURE DeleteAlbum @AlbumName NVARCHAR(255) AS
BEGIN
    DECLARE @AlbumId INT = (SELECT Albums.AlbumId FROM Albums WHERE AlbumName = @AlbumName)
    DELETE FROM Loans WHERE Loans.AlbumId = @AlbumId;
    DELETE FROM Albums WHERE Albums.AlbumId = @AlbumId
END
GO



CREATE PROCEDURE UpdateAlbum @OldAlbumName NVARCHAR(255), @NewAlbumName NVARCHAR(255) AS
BEGIN
    UPDATE Albums SET Albums.AlbumName = @NewAlbumName WHERE Albums.AlbumName = @OldAlbumName
END
GO

CREATE PROCEDURE LoanAlbum
    @AlbumName NVARCHAR(255),
    @FriendName NVARCHAR(255)
AS
BEGIN
    DECLARE @AlbumId INT = (SELECT Albums.AlbumId FROM Albums WHERE Albums.AlbumName = @AlbumName);
    DECLARE @FriendId INT = (SELECT Friends.FriendId FROM Friends WHERE Friends.FriendName = @FriendName);

    BEGIN TRY
        IF EXISTS (SELECT * FROM Loans WHERE AlbumId = @AlbumId)
            RAISERROR('Album already loaned out',18,0)
        
        INSERT INTO Loans (FriendId, AlbumId) VALUES (@FriendId, @AlbumId);
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT;
        SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();
        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState );
    END CATCH

    
END
GO

CREATE PROCEDURE ReturnAlbum @AlbumName NVARCHAR(255) AS
BEGIN
    DECLARE @AlbumId INT = (SELECT Albums.AlbumId FROM Albums WHERE Albums.AlbumName = @AlbumName)
    DELETE FROM Loans WHERE Loans.AlbumId = @AlbumId
END
GO