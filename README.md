# SQL Project for Code Louisville

## Project Description

**Play My Beats**

This is a sample database for tracking a personal vinyl album collection and, importantly, which friends have borrowed your records. By executing stored procedures, you can list the albums in your collection, list albums borrowed by friends, add and remove albums to your collection, and loan and return albums.

## Features

- Maintain lists of Bands, Albums, and Friends
- Add new albums to your collection
- Track what you have loaned to friends


## User Instructions

| Feature | Command |
| ----------- | ----------- |
| List All Albums | ReadAlbums |
| List Albums by Band | ReadAlbums @BandName = "band name" |
| List Albums by Friend | ReadAlbums @FriendName = "friend name" |
| Add Album to Collection | CreateAlbum @AlbumName = "album name", @BandName = "band name" |
| Remove Album from Collection | DeleteAlbum @AlbumName = "album name" |
| Edit Album in Collection | UpdateAlbum @AlbumName = "album name", @BandName = "band name" |
| Loan Album to Friend | LoanAlbum @AlbumName = "album name", @FriendName = "friend name" |
| Return Album from Friend | ReturnAlbum @AlbumName = "album name" |


## Technical Instructions

- Requires MS SQL Server
- Execute the PlayMyBeats-CreateDBObjects.sql script to create the database objects
- Execute the PlayMyBeats-LoadSampleData.sql script to load the sample data
- Execute commands in the PlayMyBeats.sql file to test out the functionality

