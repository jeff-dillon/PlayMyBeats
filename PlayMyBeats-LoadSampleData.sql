/* PlayMyBeats-Load Sample Data.sql
 * Author: Jeff Dillon
 * Date Created: 10/3/2021
 * Description: sample data for Play My Beats app
*/


INSERT INTO Bands 
VALUES ('The Beatles'), 
        ('Americal Aquarium'),
        ('My Morning Jacket'),
        ('Lizzo'),
        ('A Tribe Called Quest'),
        ('Megan Thee Stallion'),
        ('Neil Young');
GO

INSERT INTO Friends VALUES ('Shawn'), ('Ryan'), ('Kristie');
GO

INSERT INTO Albums 
VALUES (3, 'The Waterfall'),
        (4, 'Cuz I Love You'),
        (6, 'Good News'),
        (5, 'The Love Movement'),
        (7, 'After The Goldrush');
GO

INSERT INTO Loans (FriendId, AlbumId) VALUES (1,1), (1,5), (2,2);
GO
