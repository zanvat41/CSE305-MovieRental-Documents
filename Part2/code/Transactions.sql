# Zhe Lin 109369879
# Sean Pesce 107102508
# Weichao Zhao 109957656
#
# CSE305 Database Project Part 2
# Database Schema - Transactions



###### Manager-Level Transactions ######

# Add a movie:
START TRANSACTION;
INSERT INTO Movie (ID, Title, Genre, Fee, TotalCopies, Rating)
VALUES (1, 'The Godfather', 'Drama', 0.00, 3, 5); # Fee should be 10000.00; will be edited in next transaction
COMMIT;

# Edit a movie:
START TRANSACTION;
UPDATE Movie
SET Fee=10000.00
WHERE ID=1;
COMMIT;

# Delete a movie:
START TRANSACTION;
DELETE FROM Movie
WHERE ID=1;
COMMIT;


# Add an employee:
START TRANSACTION;
INSERT INTO Person (ID, LastName, FirstName, Address, City, State, Zip, Phone)
VALUES (123456789, 'Smith', 'Dave', '123 College road',  'Stony Brook', 'NY', 11790, 5162152345); # FirstName should be 'David'; will be changed in the next transaction
COMMIT;

# Edit employee information:
START TRANSACTION;
UPDATE Employee
SET FirstName='David'
WHERE ID=123456789;
COMMIT;

# Delete an employee:
START TRANSACTION;
DELETE FROM Employee
WHERE ID=123456789;
COMMIT;


# Obtain a sales report (i.e. the overall income from all active subscriptions) for a particular month:
START TRANSACTION;
# To calculate income for a given month, find all accounts created before the beginning of the FOLLOWING month
# The following statement calculates income for October 2006:
SELECT SUM(S.Income) MonthRevenue
FROM SalesReport S
WHERE S.AccountCreated < '2006-11-01';
COMMIT; # This transaction doesn't change the DB



