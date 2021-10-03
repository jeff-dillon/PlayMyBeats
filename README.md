# SQL Project for Code Louisville

## Project Description

**Play My Beats**

This is a sample database for tracking a personal vinyl album collection and, importantly, which friends have borrowed your records. This database tracks the bands and albums in a collection, along with information about the albums like condition, year issued, etc. You can easily add friends and track which albums they have borrowed.

## Features

**App Features**

- Maintain lists of Bands, Albums, and Friends
- Add new albums to your collection
- Track what you have loaned to friends


**Technical Details**

- DDL for creating database tables
- DML script to load sample data
- Stored Procedures providing CRUD funtionality - for use by a front-end application
- Documentation of the Stored Procedures

## Instructions
**User Instructions**

| Feature | Command |
| ----------- | ----------- |
| List All Albums | EXECUTE ListAlbums |
| List Albums by Band | EXECUTE ListAlbums @BandName = "band name" |
| List Albums by Borrower | EXECUTE ListAlbums @BorrowerName = "borrower name" |


**Technical Instructions**

- Requires MS SQL Server
- Execute the DDL to create the database objects
- Execute the DML to load the sample data

