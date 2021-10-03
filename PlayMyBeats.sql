/* PlayMyBeats.sql
 * Author: Jeff Dillon
 * Date Created: 9/30/2021
 * Description: DDL and DML for PlayMyBeats app
 *
*/

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

INSERT INTO Bands VALUES ('Beastie Boys');
INSERT INTO Bands VALUES ('American Aquarium');
INSERT INTO Bands VALUES ('A Tribe Called Quest');
INSERT INTO Bands VALUES ('Greateful Dead');
INSERT INTO Bands VALUES ('Joan Armatrading');
INSERT INTO Bands VALUES ('Taylor Swift');
GO

SELECT * FROM Bands
GO

-- Create a new table called '[Albums]' in schema '[dbo]'
-- Drop the table if it already exists
IF OBJECT_ID('[dbo].[Albums]', 'U') IS NOT NULL
DROP TABLE [dbo].[Albums]
GO
-- Create the table in the specified schema
CREATE TABLE [dbo].[Albums]
(
    [AlbumId] INT NOT NULL IDENTITY PRIMARY KEY, -- Primary Key column
    [BandId] INT NOT NULL,
    [Genre] NVARCHAR(50) NOT NULL,
    [Condition] NVARCHAR(50) NOT NULL,
    [AlbumName] NVARCHAR(255),
    FOREIGN KEY(BandId) REFERENCES Bands(BandId)
);
GO

INSERT INTO Albums VALUES (1,'HIP HOP', 'GOOD', 'Paul''s Botique');
GO

SELECT * FROM Albums
GO