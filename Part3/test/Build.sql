# Zhe Lin 109369879
# Sean Pesce 107102508
# Weichao Zhao 109957656
#
# CSE305 Database Project Part 3
# Database Initialization Statement Compilation





# This file can be copied and pasted directly into mysql to build an unpopulated database.
# Includes all functioning table creations, views, triggers, and procedures.

# Optional statements if you haven't created a database yet:
#    CREATE DATABASE cse305db;
#    USE cse305db;


# If you've already created a blank database, start here:

CREATE TABLE Person (
	ID INT(9) UNSIGNED ZEROFILL DEFAULT 0,	# This is a customer's ID and an employee's SSN
	LastName VARCHAR(64) NOT NULL,
	FirstName VARCHAR(64) NOT NULL,
	Address VARCHAR(64) NOT NULL,
	City VARCHAR(64) NOT NULL,
	# ENUMs also act as domains:
	State ENUM('AK','AL','AR','AZ','CA','CO','CT', # ENUM Domain (for valid state/territory/base abbreviations)
		'DE','FL','GA','HI','IA','ID','IL','IN','KS',
		'KY','LA','MA','MD','ME','MI','MN','MO','MS',
		'MT','NC','ND','NE','NH','NJ','NM','NV','NY',
		'OH','OK','OR','PA','RI','SC','SD','TN','TX',
		'UT','VA','VT','WA','WI','WV','WY',
		'AS','DC','FM','GU','MH','MP','PR','PW','VI', # Territories/federal districts
		'AA','AE','AP') NOT NULL, # Military bases
	Zip INT(5) UNSIGNED ZEROFILL NOT NULL,
	Phone BIGINT(10) UNSIGNED ZEROFILL NOT NULL,
	PRIMARY KEY (ID),
	UNIQUE KEY NameAddress (LastName, FirstName, Address, City, State, Zip) # There won't be two people with the same name in the same house
	# @TODO: BEFORE INSERT, check that ID is not greater than 999999999 (And do the same for zipcode and phone number)
);

CREATE TABLE Customer ( # IsA Person
	ID INT(9) UNSIGNED ZEROFILL AUTO_INCREMENT,	# References Person(ID)
	Email VARCHAR(64) NOT NULL,
	CreditCard BIGINT(16) UNSIGNED ZEROFILL NOT NULL,
	Rating INT UNSIGNED DEFAULT 1, 	# Customer Rating starts low because it is based on usage; new customers have never rented a movie
	PRIMARY KEY (ID),
	FOREIGN KEY (ID) REFERENCES Person(ID)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	# UNIQUE KEY (Email), # Don't allow multiple accounts tied to the same email address	# EDIT: or they can? Part1 solution says customers can have multiple accounts
	CONSTRAINT chk_Rating CHECK (Rating IN (1, 2, 3, 4, 5)),
	CONSTRAINT chk_Email CHECK (Email LIKE '%_@_%._%') # The '%' char checks for 0 or more chars; '_' checks for exactly 1 character
	# @TODO: BEFORE INSERT, check that CreditCard is not greater than 9999999999999999 (can't be more than 16 digits)
);

CREATE TABLE Account (
	ID INT UNSIGNED AUTO_INCREMENT,
	CustomerID INT(9) UNSIGNED ZEROFILL NOT NULL,	# Account has participation constraint and must belong to a customer (HasAccount relationship)
	Subscription ENUM('Limited', 'Unlimited', 'Unlimited+', 'Unlimited++') NOT NULL DEFAULT 'Limited', # ENUM Domain
	Created DATE,		# DATEs are formatted like so: '2000-12-31'
	PRIMARY KEY (ID),
	FOREIGN KEY (CustomerID) REFERENCES Customer(ID)
		ON DELETE NO ACTION
		ON UPDATE CASCADE
);

CREATE TABLE Employee ( # IsA Person
	SSN INT(9) UNSIGNED ZEROFILL AUTO_INCREMENT, # References Person(ID)
	StartDate DATE,	# Start of employment
	Position ENUM('Manager', 'Customer Rep'),	# @TODO: Do we need to implement this attribute or is it all determined by permissions?
	HourlyRate FLOAT NOT NULL DEFAULT 20.00,
	PRIMARY KEY (SSN),
	FOREIGN KEY (SSN) REFERENCES Person(ID)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT chk_Pay CHECK (HourlyRate >= 9.00) # Make sure employees don't get paid below minimum wage @TODO: make min wage a constant?
	# @TODO: On Employee INSERT, grant permissions to determine whether the user is a customer rep or manager (?)
);

CREATE TABLE Movie (
	ID INT UNSIGNED AUTO_INCREMENT,
	Title VARCHAR(64) NOT NULL,
	Genre ENUM ('Comedy', 'Drama', 'Action', 'Foreign'), # ENUM acts as a domain
	Fee FLOAT DEFAULT 0.00,
	TotalCopies INT UNSIGNED DEFAULT 0,
	Rating INT UNSIGNED,
	PRIMARY KEY (ID),
	CONSTRAINT chk_Rating CHECK (Rating IN (1, 2, 3, 4, 5)), # CONSTRAINT acts as a domain
	CONSTRAINT chk_Fee CHECK (Fee >= 0.0)
);

CREATE TABLE Actor (
	ID INT UNSIGNED AUTO_INCREMENT,
	FirstName VARCHAR(64) NOT NULL,
	LastName VARCHAR(64) NOT NULL,
	Gender ENUM('M','F'), # ENUM acts as a domain
	Age INT UNSIGNED,
	Rating INT UNSIGNED,
	PRIMARY KEY (ID),
	CONSTRAINT chk_Rating CHECK (Rating IN (1, 2, 3, 4, 5)) # CONSTRAINT acts as a domain
);

CREATE TABLE _Order (	# Apparently "Order" is a MySQL keyword...
	ID INT UNSIGNED AUTO_INCREMENT,
	OrderDate DATETIME,		# DATETIMEs are formatted like so: '2000-12-31 23:59:59'
	ReturnDate DATETIME DEFAULT NULL,	# Can be set using SetReturned procedure
	PRIMARY KEY (ID),
	CONSTRAINT chk_Dates CHECK (ReturnDate >= OrderDate)
);



# Represents movies that have been rented by customers
CREATE TABLE Rental (
	OrderID INT UNSIGNED AUTO_INCREMENT,
	AccountID INT UNSIGNED,
	MovieID INT UNSIGNED,
	EmployeeID INT(9) UNSIGNED ZEROFILL,
	PRIMARY KEY (OrderID, AccountID, MovieID, EmployeeID),
	FOREIGN KEY (OrderID) REFERENCES _Order(ID)
		ON DELETE NO ACTION
		ON UPDATE CASCADE,
	FOREIGN KEY (AccountID) REFERENCES Account(ID)
		ON DELETE NO ACTION		# Grader correction from part 1
		ON UPDATE CASCADE,
	FOREIGN KEY (MovieID) REFERENCES Movie(ID)
		ON DELETE NO ACTION		# Grader correction from part 1
		ON UPDATE CASCADE,
	FOREIGN KEY (EmployeeID) REFERENCES Employee(SSN)
		ON DELETE NO ACTION		# Grader correction from part 1
		ON UPDATE CASCADE
	# @TODO: Each Order can only have 1 Rental associated with it
);


# Represents movies that users have added to their Movie Queue (aka Wishlist)
CREATE TABLE Queued (
	AccountID INT UNSIGNED,
	MovieID INT UNSIGNED,
	DateAdded DATETIME,	# Used to sort movies in the queue
	PRIMARY KEY (AccountID, MovieID),
	FOREIGN KEY (AccountID) REFERENCES Account(ID)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	FOREIGN KEY (MovieID) REFERENCES Movie(ID)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);


# Represents a relationship between an actor and a movie they have been
#  casted in.
CREATE TABLE Casted (
	ActorID INT UNSIGNED,
	MovieID INT UNSIGNED,
	Role VARCHAR(128),
	PRIMARY KEY (ActorID, MovieID),
	FOREIGN KEY (ActorID) REFERENCES Actor(ID)
		ON DELETE NO ACTION		# Grader correction from part 1
		ON UPDATE CASCADE,
	FOREIGN KEY (MovieID) REFERENCES Movie(ID)
		ON DELETE NO ACTION		# Grader correction from part 1
		ON UPDATE CASCADE
	# Moved actor rating back to Actor table because part 1 solution specifies it that way
);

# Obtain a sales report (i.e. the overall income from all active subscriptions) for a particular month:
CREATE VIEW SalesReport (AccountID, AccountType, AccountCreated, Income) AS (
	SELECT A1.ID, A1.Subscription, A1.Created, 0.00
    FROM Account A1
    WHERE A1.Subscription = 'Limited')
    UNION
    (SELECT A2.ID, A2.Subscription, A2.Created, 5.00
    FROM Account A2
    WHERE A2.Subscription = 'Unlimited')
    UNION
    (SELECT A3.ID, A3.Subscription, A3.Created, 10.00
    FROM Account A3
    WHERE A3.Subscription = 'Unlimited+')
    UNION
    (SELECT A4.ID, A4.Subscription, A4.Created, 15.00
    FROM Account A4
    WHERE A4.Subscription = 'Unlimited++'
);

# Produce a list of movie rentals by movie name:
CREATE VIEW RentalsByMovie (OrderID, AccountID, EmployeeID, MovieID, Title) AS (
    SELECT R.OrderID, R.AccountID, R.EmployeeID, R.MovieID, M.Title
    FROM Rental R JOIN Movie M ON (R.MovieID = M.ID)
    # WHERE M.Title = 'Movie Title'   # When a manager uses this transaction, title needs to be specified
);

# Produce a list of movie rentals by customer name:
CREATE VIEW RentalsByCustomer (OrderID, AccountID, EmployeeID, MovieID, CustomerName) AS (
    SELECT R.OrderID, R.AccountID, R.EmployeeID, R.MovieID, P.FullName
    FROM Rental R JOIN (SELECT ID, CONCAT(FirstName, ' ', LastName) FullName
	                    FROM Person) P
    # WHERE CustomerName='Customer Name'    # When a manager uses this transaction, customer's full name needs to be specified
);

# Produce a list of movie rentals by movie genre/type:
CREATE VIEW RentalsByGenre (OrderID, AccountID, EmployeeID, MovieID, Genre) AS (
	SELECT R.OrderID, R.AccountID, R.EmployeeID, R.MovieID, M.Genre
	FROM Rental R JOIN Movie M ON (R.MovieID = M.ID)
);

# Determine which customer representative oversaw the most transactions (rentals):
CREATE VIEW RepRentalCount (Count, SSN, FullName) AS (
	SELECT C.RentalCount, E.SSN, P.FullName
	FROM (Employee E JOIN (SELECT ID, CONCAT(FirstName, ' ', LastName) FullName
						   FROM Person) P
					 ON E.SSN = P.ID)
					 JOIN (SELECT COUNT(*) RentalCount, R.EmployeeID ID
					 	   FROM Rental R
						   GROUP BY R.EmployeeID) C
					 ON C.ID = E.SSN
	ORDER BY C.RentalCount DESC		# The first entry in this view is the representative who helped with the most rentals
);

# Produce a list of most active customers:
CREATE VIEW MostActiveCustomers (AccountID, CustomerID, Rating, JoinDate) AS (
	SELECT A.ID, A.CustomerID, C.Rating, A.Created 
	FROM Customer C JOIN Account A ON C.ID = A.CustomerID
	ORDER BY C.Rating DESC, A.Created DESC		# Sort by customer rating
);

# Produce a list of most actively rented movies:
CREATE VIEW PopularMovies (RentalCount, MovieID, Title) AS (
	SELECT R.TotalRentals, M.ID, M.Title
	FROM Movie M JOIN (SELECT COUNT(*) TotalRentals, MovieID
					   FROM Rental
					   GROUP BY MovieID) R ON M.ID = R.MovieID
	ORDER BY R.TotalRentals DESC, M.Title ASC
);





# Produce customer mailing lists:
CREATE VIEW MailingList (AccountID, CustomerID, CustomerName, Email, Subscription) AS (
	SELECT A.ID, C.ID, C.FullName, C.Email, A.Subscription
	FROM Account A JOIN (SELECT C1.ID, CONCAT(P.FirstName, ' ', P.LastName) FullName, C1.Email
						 FROM Customer C1 JOIN Person P ON C1.ID = P.ID) C ON A.CustomerID = C.ID
);



# List of movies each customer has out:
CREATE VIEW CurrentRentals (AccountID, MovieID, Title, OrderDate) AS (
	SELECT AccountID, MovieID, Title, OrderDate
	FROM (Rental JOIN _Order ON OrderID = _Order.ID) JOIN Movie ON (MovieID = Movie.ID)
	WHERE ReturnDate = NULL
	ORDER BY OrderDate ASC
);

# List of movies currently in customer movie queues:
CREATE VIEW MovieQueue (AccountID, CustomerID, MovieID, Title, DateAdded) AS (
	SELECT Q.AccountID, A.CustomerID, Q.MovieID, M.Title, Q.DateAdded
	FROM (Queued Q JOIN Movie M ON (Q.MovieID = M.ID)) JOIN Account A ON (Q.AccountID = A.ID)
	ORDER BY DateAdded ASC
);

# List of all movies each customer has rented:
CREATE VIEW RentalHistory (AccountID, OrderID, MovieID, Title, Genre, Rating, OrderDate, ReturnDate) AS (
	SELECT AccountID, OrderID, MovieID, Title, Genre, Movie.Rating, OrderDate, ReturnDate
	FROM (Rental JOIN _Order ON OrderID = _Order.ID) JOIN Movie ON (MovieID = Movie.ID)
	ORDER BY OrderDate DESC
);

# List of the number of copies available for each movie:
CREATE VIEW AvailableCopies (MovieID, Copies) AS (
	SELECT MovieID, TotalCopies - COUNT(*)
	FROM (Rental JOIN _Order ON OrderID = _Order.ID) JOIN Movie ON (MovieID = Movie.ID)
	WHERE ReturnDate = NULL
	GROUP BY MovieID
);

# List of available movies:
CREATE VIEW AvailableMovies(MovieID, Title, Genre, Rating, AvailableCopies, TotalCopies) AS (
	SELECT MovieID, Title, Genre, Rating, A.Copies, TotalCopies
	FROM Movie JOIN AvailableCopies A ON (ID=A.MovieID)
	WHERE A.Copies > 0
);

# Each actor's first and last name combined as a single string:
CREATE VIEW ActorName (ActorID, FullName) AS (
	SELECT ID, CONCAT(FirstName, ' ', LastName)
	FROM Actor
);

# List of all movies each actor has been in:
CREATE VIEW Roles (ActorID, ActorName, MovieID, Title, Genre, MovieRating) AS (
	SELECT Casted.ActorID, FullName, MovieID, Title, Genre, Movie.Rating
	FROM ((Actor JOIN ActorName ON (Actor.ID = ActorName.ActorID)) JOIN Casted ON (Actor.ID = Casted.ActorID)) JOIN Movie ON (MovieID = Movie.ID)
);


# List of movies that customers currently have loaned:
CREATE VIEW CurrentLoans (AccountID, MovieID, Title, OrderDate) AS (
	SELECT AccountID, MovieID, Title, OrderDate
	FROM (Rental JOIN _Order ON OrderID = _Order.ID) JOIN Movie ON (MovieID = Movie.ID)
	WHERE ReturnDate = NULL
);

# List of all actors casted in each movie:
CREATE VIEW CastList (MovieID, ActorID, FirstName, LastName, Gender, Age, ActorRating) AS (
	SELECT MovieID, ActorID, FirstName, LastName, Gender, Age, Actor.Rating
	FROM (Actor JOIN Casted ON (Actor.ID = ActorID)) JOIN Movie ON (MovieID = Movie.ID)
);

CREATE VIEW Invoice (OrderID, AccountID, OrderDate, ReturnDate, MovieID, RepID) AS (
	SELECT OrderID, AccountID, OrderDate, ReturnDate, MovieID, EmployeeID
	FROM Rental JOIN _Order ON (OrderID = ID)
);

CREATE VIEW PersonName (PersonID, Name) AS (
	SELECT ID, CONCAT(FirstName, ' ', LastName)
	FROM Person
);

CREATE VIEW PersonListName (PersonID, ListName) AS (
	SELECT ID, CONCAT(LastName, ', ', FirstName)
	FROM Person
	ORDER BY LastName, FirstName ASC
);

CREATE VIEW ActorListName (ActorID, ListName) AS (
	SELECT ID, CONCAT(LastName, ', ', FirstName)
	FROM Actor
	ORDER BY LastName, FirstName ASC
);

# Obtains formatted movie royalty fee:
CREATE VIEW MovieFee (MovieID, Price) AS (
	SELECT M.ID, CONCAT('$', FORMAT(M.Fee, 2))
	FROM Movie M
);

# Obtains formatted employee hourly rate:
CREATE VIEW Wage (EmployeeID, Pay) AS (
	SELECT E.SSN, CONCAT('$', FORMAT(E.HourlyRate, 2))
	FROM Employee E
);

# Obtains phone numbers with the format: (000) 000-0000
CREATE VIEW PhoneNumber (PersonID, Telephone) AS (
	SELECT P.ID, INSERT(INSERT(INSERT(CAST(P.Phone AS CHAR(10)), 1, 0, '('), 5, 0, ') '), 10, 0, '-')
	FROM Person P
);

# Obtains phone numbers with the format: 000-000-0000
CREATE VIEW PhoneNumber2 (PersonID, Telephone) AS (
	SELECT P.ID, INSERT(INSERT(CAST(P.Phone AS CHAR(10)), 4, 0, '-'), 8, 0, '-')
	FROM Person P
);

# Obtains formatted SSN:
CREATE VIEW SocialSecurity (PersonID, SSN) AS (
	SELECT P.ID, INSERT(INSERT(CAST(P.ID AS CHAR(9)), 4, 0, '-'), 7, 0, '-')
	FROM Person P
);

# Obtains formatted CC #:
CREATE VIEW CreditCardNum (CustomerID, CC) AS (
	SELECT C.ID, INSERT(INSERT(INSERT(CAST(C.CreditCard AS CHAR(16)), 5, 0, ' '), 10, 0, ' '), 15, 0, ' ')
	FROM Customer C
);

# A person's full home address:
CREATE VIEW FullAddress(PersonID, FullAddr) AS (
	SELECT P.ID, CONCAT(P.Address, '\n', P.City, ', ', P.State, ' ', P.Zip)
	FROM Person P
);

# A person's mailing address (full name and full address):
CREATE VIEW MailingAddress(PersonID, MailAddr) AS (
	SELECT P.ID, CONCAT(P.FirstName, ' ', P.LastName, '\n', P.Address, '\n', P.City, ', ', P.State, ' ', P.Zip)
	FROM Person P
);

# Checks that an employee began working before they helped with an order:
DELIMITER $$
CREATE PROCEDURE EmployeeExistsBeforeOrder (IN New_EmployeeID INT(9) UNSIGNED ZEROFILL, New_OrderID INT UNSIGNED)
BEGIN
	IF (SELECT DATE(OrderDate)
		FROM _Order
		WHERE New_OrderID = ID)
		<
		(SELECT StartDate
			FROM Employee
			WHERE New_EmployeeID = Employee.SSN
		)
	THEN 
		SIGNAL SQLSTATE 'E0451'
            SET MESSAGE_TEXT = 'Date conflict: Order date precedes Employee start date.';
    END IF;
END;
$$
DELIMITER ;


# Checks that a customer's account was created before they placed an order:
DELIMITER $$
CREATE PROCEDURE AccountExistsBeforeOrder (IN New_AccountID INT UNSIGNED, New_OrderID INT UNSIGNED)
BEGIN
	IF  (SELECT DATE(OrderDate)
		FROM _Order O
		WHERE New_OrderID = O.ID)
		<
		(SELECT A.Created
			FROM Account A
			WHERE New_AccountID = A.ID
		)
	THEN 
		SIGNAL SQLSTATE 'E0451'
            SET MESSAGE_TEXT = 'Date conflict: Order date precedes Customer\'s account creation.';
    END IF;
END;
$$
DELIMITER ;


# Checks that an account was created before they put a movie in their queue:
DELIMITER $$
CREATE PROCEDURE AccountExistsBeforeQueue (IN New_AccountID INT UNSIGNED, New_DateAdded DATETIME)
BEGIN
	IF DATE(New_DateAdded) < (SELECT A.Created
			FROM Account A
			WHERE New_AccountID = A.ID
		)
	THEN 
		SIGNAL SQLSTATE 'E0451'
            SET MESSAGE_TEXT = 'Date conflict: Date of queue insertion precedes Customer\'s account creation.';
    END IF;
END;
$$
DELIMITER ;


# Checks that an order's OrderDate precedes the ReturnDate:
DELIMITER $$
CREATE PROCEDURE CantReturnBeforeRenting (New_OrderDate DATETIME, New_ReturnDate DATETIME)
BEGIN
	IF	 (New_ReturnDate != NULL) AND
		New_ReturnDate < New_OrderDate
	THEN 
		SIGNAL SQLSTATE 'E0451'
            SET MESSAGE_TEXT = 'Date conflict: Date of return precedes date when order was placed.';
    END IF;
END;
$$
DELIMITER ;


# Checks that an account isn't renting 2 copies of the same movie at the same time:
DELIMITER $$
CREATE PROCEDURE CantHaveTwoCopies (
	IN New_OrderID INT UNSIGNED, New_AccountID INT UNSIGNED, New_MovieID INT UNSIGNED)
BEGIN
	IF 	(NULL = (SELECT ReturnDate
				FROM _Order O1
				WHERE O1.ID = New_OrderID))
		AND
		EXISTS (SELECT *
			FROM Rental R1 JOIN _Order O2 ON (R1.OrderID = O2.ID)
			WHERE
				New_AccountID = R1.AccountID AND
				New_MovieID = R1.MovieID AND
				O2.ReturnDate = NULL AND
				New_OrderID != O2.ID
		)
	THEN 
		SIGNAL SQLSTATE 'E0928'
            SET MESSAGE_TEXT = 'Rental conflict: Customer is already renting a copy of this movie.';
    END IF;
END;
$$
DELIMITER ;


# Checks that customer can't rent a movie if no copies are available:
DELIMITER $$
CREATE PROCEDURE CantRentUnavailable (IN New_OrderID INT UNSIGNED, New_MovieID INT UNSIGNED)
BEGIN
	IF 	(NULL = (SELECT O1.ReturnDate
				FROM _Order O1
				WHERE New_OrderID = O1.ID))
				AND (
				(SELECT TotalCopies
				FROM Movie M
				WHERE M.ID = New_MovieID
				)
				<=
				(SELECT COUNT(*)
				FROM Rental R JOIN _Order O2 ON (R.OrderID = O2.ID)
				WHERE New_MovieID = R.MovieID AND
				O2.ReturnDate = NULL AND
				New_OrderID != O2.ID
				))
	THEN 
		SIGNAL SQLSTATE 'E0928'
            SET MESSAGE_TEXT = 'Rental conflict: There are no available copies of this movie.';
    END IF;
END;
$$
DELIMITER ;


# Returns a movie (if the loan is still active):
DELIMITER $$
CREATE PROCEDURE SetReturned (OrderID INT UNSIGNED)
BEGIN
	UPDATE _Order O
	SET O.ReturnDate = IFNULL(O.ReturnDate, NOW()) # Fill in return date
	WHERE O.ID = OrderID;
END;
$$
DELIMITER ;


# If a movie is rented and not expired, delete from Queued:
DELIMITER $$
CREATE PROCEDURE DeleteFromQueue (IN New_AccountID INT UNSIGNED, New_MovieID INT UNSIGNED, New_OrderID INT UNSIGNED)
BEGIN
	IF	(NULL = (SELECT ReturnDate
				FROM _Order
				WHERE New_OrderID = ID))
	THEN
		DELETE FROM Queued WHERE Queued.MovieID = New_MovieID AND Queued.AccountID = New_AccountID;
	END IF;
END;
$$
DELIMITER ;


# Make sure there is always at least 1 manager:
DELIMITER $$
CREATE PROCEDURE ManagerExistsOnUpdate (IN Old_EmployeeID INT(9) UNSIGNED ZEROFILL, New_Position ENUM('Manager', 'Customer Rep'), Old_Position ENUM('Manager', 'Customer Rep'))  # @TODO: Add this procedure/trigger for Person (with extra check that the person is a manager)
BEGIN
	IF	('Manager' != New_Position) AND ('Manager' = Old_Position)
		AND NOT EXISTS 	(SELECT *
						FROM Employee E
						WHERE E.SSN != Old_EmployeeID AND E.Position = 'Manager')
			
	THEN
		SIGNAL SQLSTATE 'E1991'
            SET MESSAGE_TEXT = 'Staff conflict: Company requires at least 1 employee to retain \'Manager\' status at all times.';
	END IF;
END;
$$
DELIMITER ;

# Make sure there is always at least 1 manager:
DELIMITER $$
CREATE PROCEDURE ManagerExistsOnDelete (IN EmployeeID INT(9) UNSIGNED ZEROFILL, Pos ENUM('Manager', 'Customer Rep'))
BEGIN
	IF	('Manager' = Pos) AND
		NOT EXISTS 	(SELECT *
						FROM Employee E
						WHERE E.SSN != EmployeeID AND E.Position = 'Manager')
			
	THEN
		SIGNAL SQLSTATE 'E1991'
            SET MESSAGE_TEXT = 'Staff conflict: Company requires at least 1 employee to retain \'Manager\' status at all times.';
	END IF;
END;
$$
DELIMITER ;

# Table to hold variables used by Person triggers:
CREATE TABLE PersonData (
	OnlyOne ENUM('Can\'t INSERT on this table.') NOT NULL
					DEFAULT 'Can\'t INSERT on this table.',
	ID ENUM('1') NOT NULL DEFAULT '1',
	AUTO_INC INT(9) UNSIGNED ZEROFILL NOT NULL DEFAULT 1,
	PRIMARY KEY(OnlyOne),
	UNIQUE KEY(ID)
);
INSERT INTO PersonData () VALUES (); # Initialize the singleton PersonData table, which holds persistent variables for the Person table


# Gets the next sequential unused PersonData AUTO_INC value for Person IDs:
DELIMITER $$
CREATE PROCEDURE GetNextPersonID (IN new_PersonID INT(9) UNSIGNED ZEROFILL, current_PersonIndex INT(9) UNSIGNED ZEROFILL)
BEGIN
	WHILE current_PersonIndex=new_PersonID DO
	SET current_PersonIndex = current_PersonIndex + 1;
	SET new_PersonID = IF(EXISTS(SELECT P.ID FROM Person P WHERE P.ID=current_PersonIndex), current_PersonIndex, current_PersonIndex+1);
	UPDATE PersonData
	SET AUTO_INC = current_PersonIndex
	WHERE ID='1';
	END WHILE;
END;
$$
DELIMITER ;


# Pre-INSERT trigger for Rental:
DELIMITER $$
CREATE TRIGGER Rental_PreInsert_Checks BEFORE INSERT ON Rental
FOR EACH ROW BEGIN
	CALL CantRentUnavailable(NEW.OrderID, NEW.MovieID);
	CALL CantHaveTwoCopies(NEW.OrderID, NEW.AccountID, NEW.MovieID);
	CALL AccountExistsBeforeOrder (NEW.AccountID, NEW.OrderID);
	CALL EmployeeExistsBeforeOrder(NEW.EmployeeID, NEW.OrderID);
END;
$$
DELIMITER ;
# Post-INSERT trigger for Rental:
DELIMITER $$
CREATE TRIGGER Rental_PostInsert_Checks AFTER INSERT ON Rental
FOR EACH ROW BEGIN
	CALL DeleteFromQueue(NEW.AccountID, NEW.MovieID, NEW.OrderID);
END;
$$
DELIMITER ;
# Pre-UPDATE trigger for Rental:
DELIMITER $$
CREATE TRIGGER Rental_PreUpdate_Checks BEFORE UPDATE ON Rental
FOR EACH ROW BEGIN
	CALL CantRentUnavailable(NEW.OrderID, NEW.MovieID);
	CALL CantHaveTwoCopies(NEW.OrderID, NEW.AccountID, NEW.MovieID);
	CALL AccountExistsBeforeOrder (NEW.AccountID, NEW.OrderID);
	CALL EmployeeExistsBeforeOrder(NEW.EmployeeID, NEW.OrderID);
END;
$$
DELIMITER ;
# Post-INSERT trigger for Rental:
DELIMITER $$
CREATE TRIGGER Rental_PostUpdate_Checks AFTER UPDATE ON Rental
FOR EACH ROW BEGIN
	CALL DeleteFromQueue(NEW.AccountID, NEW.MovieID, NEW.OrderID);
END;
$$
DELIMITER ;




# Pre-INSERT trigger for Queued:
DELIMITER $$
CREATE TRIGGER Queued_PreInsert_Checks BEFORE INSERT ON Queued
FOR EACH ROW BEGIN
	CALL AccountExistsBeforeQueue(NEW.AccountID, NEW.DateAdded);
	SET NEW.DateAdded = IFNULL(NEW.DateAdded, NOW()); # Fill in queued date
END;
$$
DELIMITER ;
# Pre-UPDATE trigger for Queued:
DELIMITER $$
CREATE TRIGGER Queued_PreUpdate_Checks BEFORE UPDATE ON Queued
FOR EACH ROW BEGIN
	CALL AccountExistsBeforeQueue(NEW.AccountID, NEW.DateAdded);
END;
$$
DELIMITER ;




# Pre-UPDATE trigger for _Order:
DELIMITER $$
CREATE TRIGGER Order_PreUpdate_Checks BEFORE UPDATE ON _Order
FOR EACH ROW BEGIN
	CALL CantReturnBeforeRenting(NEW.OrderDate, NEW.ReturnDate);
END;
$$
DELIMITER ;
# Pre-INSERT trigger for _Order:
DELIMITER $$
CREATE TRIGGER Order_PreInsert_Checks BEFORE INSERT ON _Order
FOR EACH ROW BEGIN
	CALL CantReturnBeforeRenting(NEW.OrderDate, NEW.ReturnDate);
	SET NEW.OrderDate = IFNULL(NEW.OrderDate, NOW()); # Fill in order date
END;
$$
DELIMITER ;




# Pre-INSERT trigger for Employee:
DELIMITER $$
CREATE TRIGGER Employee_PreInsert_Checks BEFORE INSERT ON Employee
FOR EACH ROW BEGIN
	# Fill in start date:
	SET NEW.StartDate = IFNULL(NEW.StartDate, CURDATE());
END;
$$
DELIMITER ;
# Pre-UPDATE trigger for Employee:
DELIMITER $$
CREATE TRIGGER Employee_PreUpdate_Checks BEFORE UPDATE ON Employee
FOR EACH ROW BEGIN
	CALL ManagerExistsOnUpdate(OLD.SSN, NEW.Position, OLD.Position);
END;
$$
DELIMITER ;
# Pre-DELETE trigger for Employee:
DELIMITER $$
CREATE TRIGGER Employee_PreDelete_Checks BEFORE DELETE ON Employee
FOR EACH ROW BEGIN
	CALL ManagerExistsOnDelete(OLD.SSN, OLD.Position);
END;
$$
DELIMITER ;




# Pre-INSERT trigger for Account:
DELIMITER $$
CREATE TRIGGER Account_PreInsert_Checks BEFORE INSERT ON Account
FOR EACH ROW BEGIN
	# Fill in account creation date:
	SET NEW.Created = IFNULL(NEW.Created, CURDATE());
END;
$$
DELIMITER ;

# Pre-INSERT trigger for Person:
DELIMITER $$
CREATE TRIGGER Person_PreInsert_Checks BEFORE INSERT ON Person
FOR EACH ROW BEGIN
	DECLARE current_person_index INT;
	SET current_person_index = (SELECT AUTO_INC FROM PersonData WHERE ID='1');
	SET NEW.ID = IF(NEW.ID=0, current_person_index, NEW.ID);
	CALL GetNextPersonID(NEW.ID, current_person_index);
END;
$$
DELIMITER ;
# Pre-UPDATE trigger for Person:
DELIMITER $$
CREATE TRIGGER Person_PreUpdate_Checks BEFORE UPDATE ON Person
FOR EACH ROW BEGIN
	DECLARE current_person_index INT;
	SET current_person_index = (SELECT AUTO_INC FROM PersonData WHERE ID='1');
	SET NEW.ID = IF(NEW.ID=0, current_person_index, NEW.ID);
	CALL GetNextPersonID(NEW.ID, current_person_index);
END;
$$
DELIMITER ;



# Add a movie:
DELIMITER $$
CREATE PROCEDURE AddMovie (IN new_Title VARCHAR(64), new_Genre ENUM ('Comedy', 'Drama', 'Action', 'Foreign'), new_Fee FLOAT, new_TotalCopies INT UNSIGNED)
BEGIN
	START TRANSACTION;
        INSERT INTO Movie (Title, Genre, Fee, TotalCopies)
        VALUES (new_Title, new_Genre, new_Fee, new_TotalCopies);
    COMMIT;
END;
$$
DELIMITER ;

# Edit a movie:
DELIMITER $$
CREATE PROCEDURE EditMovie (IN MovieID INT UNSIGNED, _Attribute VARCHAR(64), new_Value VARCHAR(256))
BEGIN
    START TRANSACTION;
        SET @editmovie_str = CONCAT('UPDATE Movie SET ', _Attribute, '=', new_Value, ' WHERE ID=', MovieID);
        PREPARE editmovie_stmt FROM @editmovie_str;
        EXECUTE editmovie_stmt;
        DEALLOCATE PREPARE editmovie_stmt;
    COMMIT;
END;
$$
DELIMITER ;

# Delete a movie:
DELIMITER $$
CREATE PROCEDURE DeleteMovie (IN MovieID INT UNSIGNED)
BEGIN
    START TRANSACTION;
        DELETE FROM Movie
        WHERE ID=MovieID;
    COMMIT;
END;
$$
DELIMITER ;

# Add an Actor:
DELIMITER $$
CREATE PROCEDURE AddActor (IN new_FirstName VARCHAR(64), new_LastName VARCHAR(64), new_Gender ENUM ('M', 'F'), new_Age INT UNSIGNED, new_Rating INT UNSIGNED)
BEGIN
	START TRANSACTION;
        INSERT INTO Actor (FirstName, LastName, Gender, Age, Rating)
        VALUES (new_FirstName, new_LastName, new_Gender, new_Age, new_Rating);
    COMMIT;
END;
$$
DELIMITER ;

# Edit an Actor:
DELIMITER $$
CREATE PROCEDURE EditActor (IN ActorID INT UNSIGNED, _Attribute VARCHAR(64), new_Value VARCHAR(256))
BEGIN
    START TRANSACTION;
        SET @editActor_str = CONCAT('UPDATE Actor SET ', _Attribute, '=', new_Value, ' WHERE ID=', ActorID);
        PREPARE editActor_stmt FROM @editActor_str;
        EXECUTE editActor_stmt;
        DEALLOCATE PREPARE editActor_stmt;
    COMMIT;
END;
$$
DELIMITER ;

# Delete an Actor:
DELIMITER $$
CREATE PROCEDURE DeleteActor (IN ActorID INT UNSIGNED)
BEGIN
    START TRANSACTION;
        DELETE FROM Actor
        WHERE ID=ActorID;
    COMMIT;
END;
$$
DELIMITER ;

# Add an Actor to the cast of a Movie:
DELIMITER $$
CREATE PROCEDURE AddRole (IN new_ActorID INT UNSIGNED, new_MovieID INT UNSIGNED)
BEGIN
	START TRANSACTION;
        INSERT INTO Casted (ActorID, MovieID)
        VALUES (new_ActorID, new_MovieID);
    COMMIT;
END;
$$
DELIMITER ;

# Edit a casting role:
DELIMITER $$
CREATE PROCEDURE EditRole (IN ActorID INT UNSIGNED, MovieID INT UNSIGNED, _Attribute VARCHAR(64), new_Value VARCHAR(256))
BEGIN
    START TRANSACTION;
        SET @editCasted_str = CONCAT('UPDATE Casted SET ', _Attribute, '=', new_Value, ' WHERE ActorID=', ActorID, ' AND MovieID=', MovieID);
        PREPARE editCasted_stmt FROM @editCasted_str;
        EXECUTE editCasted_stmt;
        DEALLOCATE PREPARE editCasted_stmt;
    COMMIT;
END;
$$
DELIMITER ;

# Delete a casting role:
DELIMITER $$
CREATE PROCEDURE DeleteRole (IN Actor INT UNSIGNED, Movie INT UNSIGNED)
BEGIN
    START TRANSACTION;
        DELETE FROM Casted
        WHERE ActorID=Actor AND MovieID=Movie;
    COMMIT;
END;
$$
DELIMITER ;




# Add an Employee:
DELIMITER $$
CREATE PROCEDURE AddEmployee (IN    new_Position ENUM('Manager', 'Customer Rep'), new_SSN INT UNSIGNED, new_FirstName VARCHAR(64),
                                    new_LastName VARCHAR(64), new_Address VARCHAR(64), new_City VARCHAR(64), new_State CHAR(2),
                                    new_Zip INT(5) UNSIGNED, new_Phone BIGINT(10) UNSIGNED, new_StartDate DATE, new_Wage FLOAT)
BEGIN
    DECLARE current_person_index INT; # Needed if a customer exists with the new Employee's SSN
    SET new_SSN = IF(new_SSN=0, (SELECT AUTO_INC FROM PersonData LIMIT 1), new_SSN);
	START TRANSACTION;
    IF NOT EXISTS (SELECT * FROM Person WHERE ID = new_SSN) THEN
        INSERT INTO Person (ID, LastName, FirstName, Address, City, State, Zip, Phone)
        VALUES (new_SSN, new_LastName, new_FirstName, new_Address, new_City, UPPER(new_State), new_Zip, new_Phone);
    ELSEIF NOT EXISTS(SELECT * FROM Employee WHERE SSN=new_SSN) AND (
           new_FirstName != (SELECT FirstName from Person WHERE ID = new_SSN) OR    # Customer exists with the needed SSN; change the customer's ID:
           new_LastName != (SELECT LastName from Person WHERE ID = new_SSN)) THEN 
	    SET current_person_index = (SELECT AUTO_INC FROM PersonData WHERE ID='1'); # Get first free Person ID
        UPDATE Person SET ID=current_person_index WHERE ID=new_SSN; # Change the customer's CustomerID to the free Person ID
        INSERT INTO Person (ID, LastName, FirstName, Address, City, State, Zip, Phone)
        VALUES (new_SSN, new_LastName, new_FirstName, new_Address, new_City, UPPER(new_State), new_Zip, new_Phone);
    END IF;
    COMMIT;
    START TRANSACTION;
    INSERT INTO Employee (SSN, Position, StartDate, HourlyRate) VALUES (new_SSN, new_Position, new_StartDate, new_Wage);
    COMMIT;
END;
$$
DELIMITER ;

# Add a Manager:
DELIMITER $$
CREATE PROCEDURE AddManager (IN    new_SSN INT UNSIGNED, new_FirstName VARCHAR(64), new_LastName VARCHAR(64), new_Address VARCHAR(64),
                                    new_City VARCHAR(64), new_State CHAR(2), new_Zip INT(5) UNSIGNED, new_Phone BIGINT(10) UNSIGNED,
                                    new_StartDate DATE, new_Wage FLOAT)
BEGIN
    DECLARE current_person_index INT; # Needed if a customer exists with the new Employee's SSN
    SET new_SSN = IF(new_SSN=0, (SELECT AUTO_INC FROM PersonData LIMIT 1), new_SSN);
	START TRANSACTION;
    IF NOT EXISTS (SELECT * FROM Person WHERE ID = new_SSN) THEN
        INSERT INTO Person (ID, LastName, FirstName, Address, City, State, Zip, Phone)
        VALUES (new_SSN, new_LastName, new_FirstName, new_Address, new_City, UPPER(new_State), new_Zip, new_Phone);
    ELSEIF NOT EXISTS(SELECT * FROM Employee WHERE SSN=new_SSN) AND (
           new_FirstName != (SELECT FirstName from Person WHERE ID = new_SSN) OR    # Customer exists with the needed SSN; change the customer's ID:
           new_LastName != (SELECT LastName from Person WHERE ID = new_SSN)) THEN 
	    SET current_person_index = (SELECT AUTO_INC FROM PersonData WHERE ID='1'); # Get first free Person ID
        UPDATE Person SET ID=current_person_index WHERE ID=new_SSN; # Change the customer's CustomerID to the free Person ID
        INSERT INTO Person (ID, LastName, FirstName, Address, City, State, Zip, Phone)
        VALUES (new_SSN, new_LastName, new_FirstName, new_Address, new_City, UPPER(new_State), new_Zip, new_Phone);
    END IF;
    COMMIT;
    START TRANSACTION;
    INSERT INTO Employee (SSN, Position, StartDate, HourlyRate) VALUES (new_SSN, 'Manager', new_StartDate, new_Wage);
    COMMIT;
END;
$$
DELIMITER ;

# Add a Customer Rep:
DELIMITER $$
CREATE PROCEDURE AddCustomerRep (IN new_SSN INT UNSIGNED, new_FirstName VARCHAR(64), new_LastName VARCHAR(64), new_Address VARCHAR(64),
                                    new_City VARCHAR(64), new_State CHAR(2), new_Zip INT(5) UNSIGNED, new_Phone BIGINT(10) UNSIGNED,
                                    new_StartDate DATE, new_Wage FLOAT)
BEGIN
    DECLARE current_person_index INT; # Needed if a customer exists with the new Employee's SSN
    SET new_SSN = IF(new_SSN=0, (SELECT AUTO_INC FROM PersonData LIMIT 1), new_SSN);
	START TRANSACTION;
    IF NOT EXISTS (SELECT * FROM Person WHERE ID = new_SSN) THEN
        INSERT INTO Person (ID, LastName, FirstName, Address, City, State, Zip, Phone)
        VALUES (new_SSN, new_LastName, new_FirstName, new_Address, new_City, UPPER(new_State), new_Zip, new_Phone);
    ELSEIF NOT EXISTS(SELECT * FROM Employee WHERE SSN=new_SSN) AND (
           new_FirstName != (SELECT FirstName from Person WHERE ID = new_SSN) OR    # Customer exists with the needed SSN; change the customer's ID:
           new_LastName != (SELECT LastName from Person WHERE ID = new_SSN)) THEN 
	    SET current_person_index = (SELECT AUTO_INC FROM PersonData WHERE ID='1'); # Get first free Person ID
        UPDATE Person SET ID=current_person_index WHERE ID=new_SSN; # Change the customer's CustomerID to the free Person ID
        INSERT INTO Person (ID, LastName, FirstName, Address, City, State, Zip, Phone)
        VALUES (new_SSN, new_LastName, new_FirstName, new_Address, new_City, UPPER(new_State), new_Zip, new_Phone);
    END IF;
    COMMIT;
    START TRANSACTION;
    INSERT INTO Employee (SSN, Position, StartDate, HourlyRate) VALUES (new_SSN, 'Customer Rep', new_StartDate, new_Wage);
    COMMIT;
END;
$$
DELIMITER ;


# Edit Employee data:
DELIMITER $$
CREATE PROCEDURE EditEmployee (IN EmployeeSSN INT UNSIGNED, _Attribute VARCHAR(64), new_Value VARCHAR(256))
BEGIN
    START TRANSACTION;
        IF _Attribute IN ('ID', 'FirstName', 'LastName', 'Address', 'City', 'State', 'Zip', 'Phone') THEN
            SET @editEmployee_str = CONCAT('UPDATE Person SET ', _Attribute, '=', new_Value, ' WHERE ID=', EmployeeSSN);
            PREPARE editEmployee_stmt FROM @editEmployee_str;
            EXECUTE editEmployee_stmt;
            DEALLOCATE PREPARE editEmployee_stmt;
        ELSE
            SET @editEmployee_str = CONCAT('UPDATE Employee SET ', _Attribute, '=', new_Value, ' WHERE SSN=', EmployeeSSN);
            PREPARE editEmployee_stmt FROM @editEmployee_str;
            EXECUTE editEmployee_stmt;
            DEALLOCATE PREPARE editEmployee_stmt;
        END IF;
    COMMIT;
END;
$$
DELIMITER ;

# Delete an Employee:
DELIMITER $$
CREATE PROCEDURE DeleteEmployee (IN EmployeeSSN INT UNSIGNED)
BEGIN
    IF EXISTS(SELECT * FROM Employee WHERE SSN = EmployeeSSN) THEN
        START TRANSACTION;
            DELETE FROM Person
            WHERE ID=EmployeeSSN;
        COMMIT;
    ELSE
        SIGNAL SQLSTATE 'EI928'
            SET MESSAGE_TEXT = 'Invalid Parameter: Employee does not exist.';
    END IF;
END;
$$
DELIMITER ;




# Add a customer:
DELIMITER $$
CREATE PROCEDURE AddCustomer (IN new_FirstName VARCHAR(64), new_LastName VARCHAR(64), new_Address VARCHAR(64),
                                    new_City VARCHAR(64), new_State CHAR(2), new_Zip INT(5) UNSIGNED, new_Phone BIGINT(10) UNSIGNED,
                                    new_Email VARCHAR(64), new_CreditCard BIGINT(16) UNSIGNED ZEROFILL)
BEGIN
	START TRANSACTION;
        INSERT INTO Person (FirstName, LastName, Address, City, State, Zip, Phone)
        VALUES (new_FirstName, new_LastName, new_Address, new_City, new_State, new_Zip, new_Phone);

        INSERT INTO Customer (Email, CreditCard, ID)
        VALUES (new_Email, new_CreditCard, (SELECT ID
                                            FROM Person P
                                            WHERE P.LastName = new_LastName
                                            AND P.FirstName = new_FirstName
                                            AND P.Address = new_Address
                                            AND P.City = new_City
                                            AND P.State = new_State
                                            AND P.Zip = new_Zip));
    COMMIT;
END;
$$
DELIMITER ;

# Edit Customer info:
DELIMITER $$
CREATE PROCEDURE EditCustomer (IN CustomerID INT UNSIGNED, _Attribute VARCHAR(64), new_Value VARCHAR(256))
BEGIN
    START TRANSACTION;
        IF _Attribute IN ('ID', 'FirstName', 'LastName', 'Address', 'City', 'State', 'Zip', 'Phone') THEN
            SET @editCustomer_str = CONCAT('UPDATE Person SET ', _Attribute, '=', new_Value, ' WHERE ID=', CustomerID);
            PREPARE editCustomer_stmt FROM @editCustomer_str;
            EXECUTE editCustomer_stmt;
            DEALLOCATE PREPARE editCustomer_stmt;
        ELSE
            SET @editCustomer_str = CONCAT('UPDATE Customer SET ', _Attribute, '=', new_Value, ' WHERE ID=', CustomerID);
            PREPARE editCustomer_stmt FROM @editCustomer_str;
            EXECUTE editCustomer_stmt;
            DEALLOCATE PREPARE editCustomer_stmt;
        END IF;
    COMMIT;
END;
$$
DELIMITER ;

# Delete a Customer:
DELIMITER $$
CREATE PROCEDURE DeleteCustomer (IN CustomerID INT UNSIGNED)
BEGIN
    IF EXISTS(SELECT * FROM Customer WHERE ID = CustomerID) THEN
        START TRANSACTION;
            DELETE FROM Person
            WHERE ID=CustomerID;
        COMMIT;
    ELSE
        SIGNAL SQLSTATE 'EI928'
            SET MESSAGE_TEXT = 'Invalid Parameter: Customer does not exist.';
    END IF;
END;
$$
DELIMITER ;


# Record an Order:
DELIMITER $$
CREATE PROCEDURE CreateOrder(IN new_OrderDate DATETIME, new_AccountID INT UNSIGNED, new_MovieID INT UNSIGNED, new_EmployeeID INT(9) UNSIGNED ZEROFILL)
BEGIN
    START TRANSACTION;
        INSERT INTO _Order (OrderDate)
        VALUES (new_OrderDate); # If new_OrderDate is NULL, the current date/time is generated for this record

        INSERT INTO Rental (AccountID, MovieID, EmployeeID, OrderID)
        VALUES (new_AccountID, new_MovieID, new_EmployeeID, (SELECT LAST_INSERT_ID()));
    COMMIT;
END;
$$
DELIMITER ;

# Edit an Order:
DELIMITER $$
CREATE PROCEDURE EditOrder (IN _OrderID INT UNSIGNED, _Attribute VARCHAR(64), new_Value VARCHAR(256))
BEGIN
    START TRANSACTION;
        IF _Attribute IN ('ID', 'OrderDate', 'ReturnDate') THEN
            SET @editOrder_str = CONCAT('UPDATE _Order SET ', _Attribute, '=', new_Value, ' WHERE ID=', _OrderID);
            PREPARE editOrder_stmt FROM @editOrder_str;
            EXECUTE editOrder_stmt;
            DEALLOCATE PREPARE editOrder_stmt;
        ELSE
            SET @editOrder_str = CONCAT('UPDATE Rental SET ', _Attribute, '=', new_Value, ' WHERE OrderID=', _OrderID, ' LIMIT 1');
            PREPARE editOrder_stmt FROM @editCustomer_str;
            EXECUTE editOrder_stmt;
            DEALLOCATE PREPARE editOrder_stmt;
        END IF;
    COMMIT;
END;
$$
DELIMITER ;

# Delete an Order:
DELIMITER $$
CREATE PROCEDURE DeleteOrder (IN _OrderID INT UNSIGNED)
BEGIN
    IF EXISTS(SELECT * FROM Rental WHERE OrderID = _OrderID) THEN
        START TRANSACTION;
            DELETE FROM Rental
            WHERE OrderID=_OrderID;
        COMMIT;
    END IF;
    START TRANSACTION;
        DELETE FROM _Order
        WHERE ID=_OrderID;
    COMMIT;
END;
$$
DELIMITER ;


# Create a customer account:
DELIMITER $$
CREATE PROCEDURE CreateAccount(IN new_CustomerID INT(9) UNSIGNED ZEROFILL, new_Subscription ENUM('Limited', 'Unlimited', 'Unlimited+', 'Unlimited++'), new_Created DATE)
BEGIN
    START TRANSACTION;
        INSERT INTO Account(CustomerID, Subscription, Created)
        VALUES (new_CustomerID, new_Subscription, new_Created); # If new_Created is NULL, the current date/time is generated for this record
    COMMIT;
END;
$$
DELIMITER ;

# Edit a customer Account:
DELIMITER $$
CREATE PROCEDURE EditAccount (IN AccountID INT UNSIGNED, _Attribute VARCHAR(64), new_Value VARCHAR(256))
BEGIN
    START TRANSACTION;
        SET @editAccount_str = CONCAT('UPDATE Account SET ', _Attribute, '=', new_Value, ' WHERE ID=', AccountID);
        PREPARE editAccount_stmt FROM @editAccount_str;
        EXECUTE editAccount_stmt;
        DEALLOCATE PREPARE editAccount_stmt;
    COMMIT;
END;
$$
DELIMITER ;

# Delete a customer Account:
DELIMITER $$
CREATE PROCEDURE DeleteAccount (IN AccountID INT UNSIGNED)
BEGIN
    START TRANSACTION;
        DELETE FROM Account
        WHERE ID=AccountID;
    COMMIT;
END;
$$
DELIMITER ;





# Get the current AUTO_INCREMENT value for a given table:
DELIMITER $$
CREATE PROCEDURE GetAutoInc (IN _Table VARCHAR(64), OUT AUTO_INC_VAL BIGINT UNSIGNED)
BEGIN
	SET AUTO_INC_VAL = (SELECT AUTO_INCREMENT
                            FROM  INFORMATION_SCHEMA.TABLES
                            WHERE TABLE_SCHEMA = DATABASE()
                            AND   TABLE_NAME   = _Table);
    SELECT AUTO_INC_VAL;
END;
$$
DELIMITER ;

# Reset the current AUTO_INCREMENT value for a given table:
DELIMITER $$
CREATE PROCEDURE ResetAutoInc (IN _Table VARCHAR(64))
BEGIN
    SET @resetautoinc_str = CONCAT('ALTER TABLE ', _Table, ' AUTO_INCREMENT=1');
    PREPARE resetautoinc_stmt FROM @resetautoinc_str;
    EXECUTE resetautoinc_stmt;
    DEALLOCATE PREPARE resetautoinc_stmt;
END;
$$
DELIMITER ;

# Set the current AUTO_INCREMENT value for a given table:
DELIMITER $$
CREATE PROCEDURE SetAutoInc (IN _Table VARCHAR(64), new_AUTO_INC BIGINT UNSIGNED)
BEGIN
    SET @setautoinc_str = CONCAT('ALTER TABLE ', _Table, ' AUTO_INCREMENT=', new_AUTO_INC);
    PREPARE setautoinc_stmt FROM @setautoinc_str;
    EXECUTE setautoinc_stmt;
    DEALLOCATE PREPARE setautoinc_stmt;
END;
$$
DELIMITER ;


