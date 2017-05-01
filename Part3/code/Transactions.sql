# Zhe Lin 109369879
# Sean Pesce 107102508
# Weichao Zhao 109957656
#
# CSE305 Database Project Part 3
# Database Schema - Transactions


########################################
###### Manager-Level Transactions ######
########################################

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
    INSERT INTO Employee (SSN, Position) VALUES (123456789, 'Customer Rep');
COMMIT;

# Edit employee information:
START TRANSACTION;
    UPDATE Person
    SET FirstName='David'
    WHERE ID=123456789;
COMMIT;

# Delete an employee:
START TRANSACTION;
    DELETE FROM Employee
    WHERE SSN=123456789;
COMMIT;


# Obtain a sales report (i.e. the overall income from all active subscriptions) for a particular month:
START TRANSACTION;
    # To calculate income for a given month, find all accounts created before the beginning of the FOLLOWING month
    # The following statement calculates income for October 2006:
    SELECT SUM(S.Income) MonthRevenue
    FROM SalesReport S     # SalesReport is a view
    WHERE S.AccountCreated < '2006-11-01';
COMMIT; # This "transaction" doesn't change the DB



# Produce a list of movie rentals by movie name:
START TRANSACTION;
    SELECT *
    FROM RentalsByMovie     # View
    WHERE Title = 'The Godfather';
COMMIT; # This "transaction" doesn't change the DB



# Produce a list of movie rentals by movie type (genre):
START TRANSACTION;
    SELECT *
    FROM RentalsByGenre     # View
    WHERE Genre = 'Drama';
COMMIT; # This "transaction" doesn't change the DB



# Produce a list of movie rentals by customer name:
START TRANSACTION;
    SELECT *
    FROM RentalsByCustomer     # View
    WHERE CustomerName = 'Lewis Phillip';
COMMIT; # This "transaction" doesn't change the DB



# Determine which customer representative oversaw the most transactions (rentals):
START TRANSACTION;
    SELECT *
    FROM RepRentalCount # View
    LIMIT 1;
COMMIT; # This "transaction" doesn't change the DB


# Produce a list of most active customers:
START TRANSACTION;
    SELECT *
    FROM MostActiveCustomers; # View
COMMIT; # This "transaction" doesn't change the DB


# Produce a list of most actively rented movies:
START TRANSACTION;
    SELECT *
    FROM PopularMovies; # View
COMMIT; # This "transaction" doesn't change the DB





#############################################
###### Customer Rep-Level Transactions ######
#############################################

# Record an order:
START TRANSACTION;
    INSERT INTO _Order (ID, OrderDate, ReturnDate)
    VALUES (2, '2009-11-11 18:15:00', NULL); # If OrderDate is NULL, the current date/time is generated for this record
    INSERT INTO Rental (OrderID, AccountID, MovieID, EmployeeID)
    VALUES (2, 2, 3, 789123456); # Victor Du rented Borat; assisted by employee David Warren
COMMIT;


# Add a customer:
START TRANSACTION;
    INSERT INTO Person (ID, LastName, FirstName, Address, City, State, Zip, Phone)
    VALUES (111111111, 'Yang', 'Shang', '123 Success Street',  'Stony Brook', 'MA', 11790, 5166328959); # State should be 'NY'; fixed in next transaction
    INSERT INTO Customer (ID, Email, CreditCard, Rating)
    VALUES (111111111, 'syang@cs.sunysb.edu', 1234567812345678, 1); # Shang Yang
COMMIT;

# Edit customer info:
START TRANSACTION;
    UPDATE Person
    SET State='NY'
    WHERE ID=111111111; # Shang Yang
COMMIT;

# Delete customer:
START TRANSACTION;
    DELETE FROM Person
    WHERE ID=111111111; # Shang Yang
COMMIT;


# Produce customer mailing list:
START TRANSACTION;
    # Generates a mailing list for accounts with Unlimited++ subscriptions:
    SELECT *
    FROM MailingList    # View
    WHERE Subscription = 'Unlimited++';
COMMIT; # This "transaction" doesn't change the DB

# Produce a list of movie suggestions for a Shang Yang, by filtering same actors
START TRANSACTION;
    SELECT M.Title
    FROM Movie M, Rental R,Casted C1, Casted C2
    WHERE M.ID NOT IN (SELECT MovieID FROM R WHERE R.Account = 111111111) AND
    (C1.MovieID = M.ID AND C2.MovieID = R.MovieID AND C1.ActorID = C2.ActorID);
COMMIT; 





#########################################
###### Customer-Level Transactions ######
#########################################

# The 'START TRANSACTION' and 'COMMIT' statements are redundant because the database is never altered; however, the project specification says to include these statements for all "transactions"...

 # Customer's currently held movies (for customer Lewis Phillip):
START TRANSACTION;
    SELECT MovieID, Title, OrderDate
    FROM CurrentRentals CR
    WHERE CR.AccountID = 1;
COMMIT; # This "transaction" doesn't change the DB

# Customer's queue of movies (for customer Lewis Phillip):
START TRANSACTION;
    SELECT MovieID, Title, DateAdded
    FROM MovieQueue MQ
    WHERE CR.AccountID = 1;
COMMIT; # This "transaction" doesn't change the DB

# Customer's account settings (??) (for customer Lewis Phillip):
START TRANSACTION;
    # @TODO: Figure out what this transaction is actually supposed to do
    SELECT Subscription
    FROM Account
    WHERE ID=1;
COMMIT; # This "transaction" doesn't change the DB

# History of all current and past orders a customer has placed (for customer Lewis Phillip):
START TRANSACTION;
    SELECT OrderID, MovieID, Title, OrderDate, ReturnDate
    FROM RentalHistory
    WHERE AccountID=1;
COMMIT; # This "transaction" doesn't change the DB

# Movies available of a particular type/genre (in this case, Drama):
START TRANSACTION;
    SELECT *
    FROM AvailableMovies
    WHERE Genre='Drama';
COMMIT; # This "transaction" doesn't change the DB

# Movies available with a particular keyword or set of keywords in the movie name (in this case, 'God'):
START TRANSACTION;
    SELECT *
    FROM AvailableMovies
    WHERE UPPER(Title) LIKE '%GOD%';
COMMIT; # This "transaction" doesn't change the DB

# Movies available starring a particular actor or group of actors (in this case, 'Al Pacino'):
START TRANSACTION;
    SELECT ActorID, MovieID, Title, Genre, MovieRating
    FROM Roles
    WHERE ActorName = 'Al Pacino';
COMMIT; # This "transaction" doesn't change the DB

# Best-Seller list of movies (??):
#START TRANSACTION;
    # @TODO: Implement this?
#COMMIT; # This "transaction" doesn't change the DB


# Personalized movie suggestion list (??):
#START TRANSACTION;
    # @TODO: Implement this?
#COMMIT; # This "transaction" doesn't change the DB


# @TODO: "Rate the movies they have rented" (from project specification)