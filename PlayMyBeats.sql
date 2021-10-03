/*
    Play My Beats Sample Commands
*/

EXECUTE ReadAlbums
GO


EXECUTE ReadAlbums @BandName = "Neil Young"
GO

EXECUTE ReadAlbums @FriendName = "Shawn"
GO

EXECUTE CreateAlbum @AlbumName = "Harvest Moon", @BandName = "Neil Young"
GO

EXECUTE DeleteAlbum @AlbumName = "Harvest Moon"
GO

EXECUTE UpdateAlbum @OldAlbumName = "After The Goldrush", @NewAlbumName = "After The Gold Rush"
GO

EXECUTE LoanAlbum @AlbumName = "Good News", @FriendName = "Kristie"
GO

EXECUTE ReturnAlbum @AlbumName = "Good News"
GO




