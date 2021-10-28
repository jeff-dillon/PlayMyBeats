# SQL Project for Code Louisville

## Introduction
This repository is an example project for the [Code Louisville](https://www.codelouisville.org/) Fall 2021 SQL course. The purpose of this code is to demonstrate the use of SQL, Unit Tests, and Git.

## Project Description

**Play My Beats**

Play My Beats is a sample database for tracking a personal vinyl album collection and, importantly, which friends have borrowed your records. By executing stored procedures, you can list the albums in your collection, list albums borrowed by friends, add and remove albums to your collection, and loan and return albums.

## Features

- Maintain lists of Bands, Albums, and Friends
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
- Execute the PlayMyBeats-UnitTests.sql file to test out the functionality
- The PlayMyBeats.sql file has example commands showing how to use the stored procedures.

## Project Requirements

**Group 1: Reading Data from a Database**

- Write a SELECT query that uses a WHERE clause.
- Write a  SELECT query that uses an OR and an AND operator.
- Write a  SELECT query that filters NULL rows using IS NOT NULL.
- Write a  SELECT query that utilizes a JOIN.
- Write a  SELECT query that utilizes a JOIN with 3 or more tables.
- Write a  SELECT query that utilizes a LEFT JOIN.
- Write a  SELECT query that utilizes a variable in the WHERE clause.

**Group 2: Updating/Deleting Data from a Database**

- Write a DML statement that UPDATEs a set of rows with a WHERE clause. The values used in the WHERE clause should be a variable.
- Write a DML statement that DELETEs a set of rows with a WHERE clause. The values used in the WHERE clause should be a variable.

**Group 3: Optimizing a Database**

- Design a NONCLUSTERED INDEX with ONE KEY COLUMN that improves the performance of one of the above queries.
