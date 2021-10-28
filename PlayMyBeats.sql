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

-- Update the name of an album in the collection
EXECUTE UpdateAlbum @OldAlbumName = "After The Goldrush", @NewAlbumName = "After The Gold Rush"
GO

-- Loan an album to a friend
EXECUTE LoanAlbum @AlbumName = "Good News", @FriendName = "Joe"
GO

-- Return an album from a friend
EXECUTE ReturnAlbum @AlbumName = "Good News"
GO


SELECT * FROM Friends;
GO




