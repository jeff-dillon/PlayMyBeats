/*
    Play My Beats Sample Commands
*/

-- Get a list of all albums
EXECUTE ReadAlbums
GO


-- Get a list of albums by Neil Young
EXECUTE ReadAlbums @BandName = "Neil Young"
GO

-- Get a list of albums borroed by Shawn
EXECUTE ReadAlbums @FriendName = "Shawn"
GO

-- Add an album to the collection
EXECUTE CreateAlbum @AlbumName = "Harvest Moon", @BandName = "Neil Young"
GO

-- Remove an album from the collection
EXECUTE DeleteAlbum @AlbumName = "Harvest Moon"
GO

EXECUTE UpdateAlbum @OldAlbumName = "After The Goldrush", @NewAlbumName = "After The Gold Rush"
GO

EXECUTE LoanAlbum @AlbumName = "Good News", @FriendName = "Kristie"
GO

EXECUTE ReturnAlbum @AlbumName = "Good News"
GO




