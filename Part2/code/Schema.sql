# Zhe Lin 109369879
# Sean Pesce 107102508
# Weichao Zhao 109957656
#
# CSE305 Database Project Part 2
# Database Schema - Entities & Relationships

# @TODO: Add triggers/procedures for each constraint in this schema (constraints parsed but not supported by MySQL)

##########################
######Entity Tables#######
##########################

CREATE TABLE Person (
	ID CHAR(9),	# This is a customer's ID and an employee's SSN
	LastName VARCHAR(64),
	FirstName VARCHAR(64),
	Address VARCHAR(64),
	City VARCHAR(64),
	# ENUMs also act as domains:
	State ENUM('AK','AL','AR','AZ','CA','CO','CT', # ENUM Domain (for valid state/territory/base abbreviations)
		'DE','FL','GA','HI','IA','ID','IL','IN','KS',
		'KY','LA','MA','MD','ME','MI','MN','MO','MS',
		'MT','NC','ND','NE','NH','NJ','NM','NV','NY',
		'OH','OK','OR','PA','RI','SC','SD','TN','TX',
		'UT','VA','VT','WA','WI','WV','WY',
		'AS','DC','FM','GU','MH','MP','PR','PW','VI', # Territories/federal districts
		'AA','AE','AP'), # Military bases
	Zip CHAR(5),
	Phone CHAR(10),
	PRIMARY KEY (ID),
	UNIQUE KEY NameAddress (LastName, FirstName, Address, City, State, Zip), # There won't be two people with the same name in the same house
	CONSTRAINT chk_ID CHECK (ID RLIKE '^[0-9]{9}$'), # Check that ID is formatted as 9 numbers
	CONSTRAINT chk_Zip CHECK (Zip RLIKE '^[0-9]{5}$'),
	CONSTRAINT chk_Phone CHECK (Phone RLIKE '^[0-9]{10}$')
);

CREATE TABLE Customer ( # IsA Person
	ID CHAR(9),	# References Person(ID)
	Email VARCHAR(64) NOT NULL,
	CreditCard CHAR(16) NOT NULL,
	Rating INT DEFAULT 1, 	# Customer Rating starts low because it is based on usage; new customers have never rented a movie
	PRIMARY KEY (ID),
	FOREIGN KEY (ID) REFERENCES Person(ID)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	# UNIQUE KEY (Email), # Don't allow multiple accounts tied to the same email address	# EDIT: or they can? Part1 solution says customers can have multiple accounts
	CONSTRAINT chk_ID CHECK (ID RLIKE '^[0-9]{9}$'),  # Check that AccountID is formatted as 9 numbers
	CONSTRAINT chk_Rating CHECK (Rating IN (1, 2, 3, 4, 5)),
	CONSTRAINT chk_Email CHECK (Email LIKE '%_@_%._%'), # The '%' char checks for 0 or more chars; '_' checks for exactly 1 character
	CONSTRAINT chk_CC CHECK (CreditCard RLIKE '^[0-9]{16}$') # Check that CC# is composed of only numbers
);

CREATE TABLE Account (
	ID INT,
	CustomerID CHAR(9) NOT NULL,	# Account has participation constraint and must belong to a customer (HasAccount relationship)
	Type ENUM('Limited', 'Unlimited', 'Unlimited+', 'Unlimited++') NOT NULL DEFAULT 'Limited', # ENUM Domain
	Created DATE,		# DATEs are formatted like so: '2000-12-31'
	PRIMARY KEY (ID),
	FOREIGN KEY (CustomerID) REFERENCES Customer(ID)
		ON DELETE NO ACTION
		ON UPDATE CASCADE,
	CONSTRAINT chk_ID CHECK (ID >= 0),
	CONSTRAINT chk_CustID CHECK (CustomerID RLIKE '^[0-9]{9}$')
);

CREATE TABLE Employee ( # IsA Person
	SSN CHAR(9), # References Person(ID)
	StartDate DATE,	# Start of employment
	# Position ENUM('Manager','Customer Rep'),	# @TODO: Do we need to implement this attribute or is it all determined by permissions?
	HourlyRate FLOAT NOT NULL DEFAULT 20.00,
	PRIMARY KEY (SSN),
	FOREIGN KEY (SSN) REFERENCES Person(ID)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT chk_Pay CHECK (HourlyRate >= 9.00), # Make sure employees don't get paid below minimum wage @TODO: make min wage a constant?
	CONSTRAINT chk_SSN CHECK (SSN RLIKE '^[0-9]{9}$') # Check that SSN is formatted as 9 numbers
	# @TODO: On Employee INSERT/UPDATE, if SSN conflicts with some customer's account ID, change customer ID (?)
	# @TODO: On Employee INSERT, grant permissions to determine whether the user is a customer rep or manager (?)
	# @TODO: Make sure there is always at least 1 manager
);

CREATE TABLE Movie (
	ID INT,
	Title VARCHAR(64) NOT NULL,
	Genre ENUM ('Comedy', 'Drama', 'Action', 'Foreign'), # ENUM acts as a domain
	Fee FLOAT DEFAULT 0.00,
	TotalCopies INT DEFAULT 0,
	Rating INT,
	PRIMARY KEY (ID),
	CONSTRAINT chk_ID CHECK (ID >= 0),
	CONSTRAINT chk_Rating CHECK (Rating IN (1, 2, 3, 4, 5)), # CONSTRAINT acts as a domain
	CONSTRAINT chk_TotalCopies CHECK (TotalCopies >= 0),
	CONSTRAINT chk_AvailableCopies CHECK (AvailableCopies >= 0),
	CONSTRAINT chk_AvailableVsTotalCopies CHECK (AvailableCopies <= TotalCopies),
	CONSTRAINT chk_Fee CHECK (Fee >= 0.0)
);

CREATE TABLE Actor (
	ID INT,
	FirstName VARCHAR(64) NOT NULL,
	LastName VARCHAR(64) NOT NULL,
	Gender ENUM('M','F'), # ENUM acts as a domain
	Age INT,
	Rating INT,
	PRIMARY KEY (ID),
	CONSTRAINT chk_ID CHECK (ID >= 0),
	CONSTRAINT chk_Rating CHECK (Rating IN (1, 2, 3, 4, 5)), # CONSTRAINT acts as a domain
	CONSTRAINT chk_Age CHECK (Age >= 0)
);

CREATE TABLE _Order (	# Apparently "Order" is a MySQL keyword...
	ID INT,
	OrderDate DATETIME NOT NULL,		# DATETIMEs are formatted like so: '2000-12-31 23:59:59'
	ReturnDate DATETIME DEFAULT NULL,
	PRIMARY KEY (ID),
	CONSTRAINT chk_ID CHECK (ID >= 0),
	CONSTRAINT chk_Dates CHECK (ReturnDate >= OrderDate)
);




#######################
##Relationship Tables##
#######################



# Represents movies that have been rented by customers
CREATE TABLE Rental (
	OrderID INT,
	AccountID INT,
	MovieID INT,
	EmployeeID CHAR(9),
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
		ON UPDATE CASCADE,
	CONSTRAINT chk_EmployeeID CHECK (EmployeeID RLIKE '^[0-9]{9}$')
	# @TODO: Each Order can only have 1 Rental associated with it
);


# Represents movies that users have added to their Movie Queue (aka Wishlist)
CREATE TABLE Queued (
	AccountID INT,
	MovieID INT,
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
	ActorID INT,
	MovieID INT,
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



#######################
#########Views#########
#######################

# List of movies currently in customer movie queues:
CREATE VIEW MovieQueue (AccountID, MovieID, Title, DateAdded) AS (
	SELECT AccountID, MovieID, Title, DateAdded
	FROM Queued JOIN Movie ON (MovieID = ID)
	ORDER BY DateAdded ASC
);

# List of all movies each customer has rented:
CREATE VIEW RentalHistory (AccountID, MovieID, Title, Genre, Rating, OrderDate, ReturnDate) AS (
	SELECT AccountID, MovieID, Title, Genre, Movie.Rating, OrderDate, ReturnDate
	FROM (Rental JOIN _Order ON OrderID = _Order.ID) JOIN Movie ON (MovieID = Movie.ID)
	ORDER BY OrderDate DESC
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

# List of all movies each actor has been in:
CREATE VIEW Roles (ActorID, MovieID, Title, Genre, MovieRating) AS (
	SELECT ActorID, MovieID, Title, Genre, Movie.Rating
	FROM (Actor JOIN Casted ON (Actor.ID = ActorID)) JOIN Movie ON (MovieID = Movie.ID)
);

# List of the number of copies available for each movie:
CREATE VIEW AvailableCopies (MovieID, Copies) AS (
	SELECT MovieID, TotalCopies - COUNT(*)
	FROM (Rental JOIN _Order ON OrderID = _Order.ID) JOIN Movie ON (MovieID = Movie.ID)
	WHERE ReturnDate = NULL
	GROUP BY MovieID
);

# List of movies each customer has out:
CREATE VIEW CurrentRentals (AccountID, MovieID, Title, OrderDate) AS (
	SELECT AccountID, MovieID, Title, OrderDate
	FROM (Rental JOIN _Order ON OrderID = _Order.ID) JOIN Movie ON (MovieID = Movie.ID)
	WHERE ReturnDate = NULL
	ORDER BY OrderDate ASC
);

CREATE VIEW Invoice (OrderID, AccountID, OrderDate, ReturnDate, MovieID) AS (
	SELECT OrderID, AccountID, OrderDate, ReturnDate, MovieID
	FROM Rental JOIN _Order ON (OrderID = ID)
);

# @TODO: Other views:
# Full name
# List name (last, first)
# Formatted phone/cc/ssn/
# Full address
# Formatted money
# Invoice

