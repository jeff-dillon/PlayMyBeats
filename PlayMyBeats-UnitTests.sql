/**
    Unit testing for PlayMyBeats app.
    Requires:
        DDL script (PlayMyBeats-CreateDBObjects.sql) has run successfullly
        Sample Data script (PlayMyBeats-LoadSampleData.sql) has run successfully
**/
SET NOCOUNT ON;
PRINT N'Unit Testing for PlayMyBeats app.';


/** Create a temp table to store the results **/
CREATE TABLE #AlbumTest(Band VARCHAR(255), Album VARCHAR(255), LoanedTo VARCHAR(255), LoanedSince DATE);


/** Test 1: ReadAlbums **/
INSERT #AlbumTest EXEC ReadAlbums;
DECLARE @expectedRecords INT = (SELECT COUNT(1) FROM Albums);
DECLARE @actualRecords INT = (SELECT COUNT(1) FROM #AlbumTest);
IF(@expectedRecords = @actualRecords)
    PRINT N'Test: ReadAlbums - Result: Pass';
ELSE
    PRINT N'Test: ReadAlbums - Result: Fail';
DELETE FROM #AlbumTest;

/** Test 2: ReadAlbums @BandName **/
INSERT #AlbumTest EXEC ReadAlbums @BandName = 'Neil Young';
DECLARE @test2ExpectedRecords INT = (SELECT COUNT(1) FROM Albums, Bands WHERE Albums.BandId = Bands.BandId and Bands.BandName = 'Neil Young');
DECLARE @test2ActualRecords INT = (SELECT COUNT(1) FROM #AlbumTest);
IF(@test2ExpectedRecords = @test2ActualRecords)
    PRINT N'Test: ReadAlbums @BandName - Result: Pass';
ELSE
    PRINT N'Test: ReadAlbums @BandName - Result: Fail';
DELETE FROM #AlbumTest;

/** Test 3: ReadAlbums @FriendName **/
INSERT #AlbumTest EXEC ReadAlbums @FriendName = 'Shawn';
DECLARE @test3ExpectedRecords INT = (SELECT COUNT(1) FROM Albums, Friends, Loans WHERE Albums.AlbumId = Loans.AlbumId AND Loans.FriendId = Friends.FriendId and Friends.FriendName = 'Shawn');
DECLARE @test3ActualRecords INT = (SELECT COUNT(1) FROM #AlbumTest);
IF(@test3ExpectedRecords = @test3ActualRecords)
    PRINT N'Test: ReadAlbums @FriendName - Result: Pass';
ELSE
    PRINT N'Test: ReadAlbums @FriendName - Result: Fail';
DELETE FROM #AlbumTest;

/** Test 4: CreateAlbum **/
EXECUTE CreateAlbum @BandName = 'The Beatles', @AlbumName = 'Abbey Road';
DECLARE @test4NumAlbums INT = (SELECT COUNT(1) FROM Albums WHERE AlbumName = 'Abbey Road');
DECLARE @test4NumBands INT = (SELECT COUNT(1) FROM Bands WHERE BandName = 'The Beatles');
IF(@test4NumAlbums = 1 AND @test4NumBands = 1)
    PRINT N'Test: CreateAlbum - Result: Pass';
ELSE
    PRINT N'Test: CreateAlbum - Result: Fail';
DELETE FROM Albums WHERE AlbumName = 'Abbey Road';

/** Test 5: DeleteAlbum **/
EXECUTE CreateAlbum @BandName = 'The Beatles', @AlbumName = 'Abbey Road';
DECLARE @test5BeforeNumAlbums INT = (SELECT COUNT(1) FROM Albums WHERE AlbumName = 'Abbey Road');
EXECUTE DeleteAlbum @AlbumName = 'Abbey Road';
DECLARE @test5AfterNumAlbums INT = (SELECT COUNT(1) FROM Albums WHERE AlbumName = 'Abbey Road');
IF(@test5BeforeNumAlbums = 1 AND @test5AfterNumAlbums = 0)
    PRINT N'Test: DeleteAlbum - Result: Pass';
ELSE
    PRINT N'Test: DeleteAlbum - Result: Fail';
DELETE FROM Albums WHERE AlbumName = 'Abbey Road';


/** Test 6: UpdateAlbum **/
EXECUTE CreateAlbum @BandName = 'The Beatles', @AlbumName = 'Abbi Road';
DECLARE @test6BeforeNumAlbums INT = (SELECT COUNT(1) FROM Albums WHERE AlbumName = 'Abbi Road');
EXECUTE UpdateAlbum @OldAlbumName = 'Abbi Road', @NewAlbumName = 'Abbey Road';
DECLARE @test6AfterNumAlbums INT = (SELECT COUNT(1) FROM Albums WHERE AlbumName = 'Abbey Road');
IF(@test6BeforeNumAlbums = 1 AND @test6AfterNumAlbums = 1)
    PRINT N'Test: UpdateAlbum - Result: Pass';
ELSE
    PRINT N'Test: UpdateAlbum - Result: Fail';
EXECUTE DeleteAlbum @AlbumName = 'Abbey Road';

/** Test 7: LoanAlbum to existing friend **/
DECLARE @test7BeforeNumAlbums INT = (SELECT COUNT(1) FROM Albums, Loans, Friends WHERE Albums.AlbumId = Loans.AlbumId AND Loans.FriendId = Friends.FriendId AND Friends.FriendName = 'Kristie');
EXECUTE LoanAlbum @AlbumName = 'Good News', @FriendName = 'Kristie';
DECLARE @test7AfterNumAlbums INT = (SELECT COUNT(1) FROM Albums, Loans, Friends WHERE Albums.AlbumId = Loans.AlbumId AND Loans.FriendId = Friends.FriendId AND Friends.FriendName = 'Kristie');
IF(@test7BeforeNumAlbums = 0 AND @test7AfterNumAlbums = 1)
    PRINT N'Test: LoaneAlbum - Result: Pass';
ELSE
    PRINT N'Test: LoanAlbum - Result: Fail';
DELETE FROM Loans WHERE FriendId = 3;

/** Test 7b: LoanAlbum to new friend **/
DECLARE @test7bBeforeNumAlbums INT = (SELECT COUNT(1) FROM Albums, Loans, Friends WHERE Albums.AlbumId = Loans.AlbumId AND Loans.FriendId = Friends.FriendId AND Friends.FriendName = 'Joe');
EXECUTE LoanAlbum @AlbumName = 'Good News', @FriendName = 'Joe';
DECLARE @test7bAfterNumAlbums INT = (SELECT COUNT(1) FROM Albums, Loans, Friends WHERE Albums.AlbumId = Loans.AlbumId AND Loans.FriendId = Friends.FriendId AND Friends.FriendName = 'Joe');
IF(@test7bBeforeNumAlbums = 0 AND @test7bAfterNumAlbums = 1)
    PRINT N'Test: LoaneAlbum[new friend] - Result: Pass';
ELSE
    PRINT N'Test: LoanAlbum[new friend] - Result: Fail';
DELETE FROM Loans WHERE FriendId = 3;


/** Test 8: ReturnAlbum **/
EXECUTE LoanAlbum @AlbumName = 'Good News', @FriendName = 'Joe';
DECLARE @test8BeforeNumAlbums INT = (SELECT COUNT(1) FROM Albums, Loans, Friends WHERE Albums.AlbumId = Loans.AlbumId AND Loans.FriendId = Friends.FriendId AND Friends.FriendName = 'Joe');
EXECUTE ReturnAlbum @AlbumName = 'Good News';
DECLARE @test8AfterNumAlbums INT = (SELECT COUNT(1) FROM Albums, Loans, Friends WHERE Albums.AlbumId = Loans.AlbumId AND Loans.FriendId = Friends.FriendId AND Friends.FriendName = 'Joe');
IF(@test8BeforeNumAlbums = 1 AND @test8AfterNumAlbums = 0)
    PRINT N'Test: ReturnAlbum - Result: Pass';
ELSE
    PRINT N'Test: ReturnAlbum - Result: Fail';
DELETE FROM Loans WHERE FriendId = 3;


/** Clean up the temp table **/
DROP TABLE #AlbumTest;
GO
