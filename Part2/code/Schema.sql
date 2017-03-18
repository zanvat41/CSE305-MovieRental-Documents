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
	ID INT(9) UNSIGNED ZEROFILL AUTO_INCREMENT,	# This is a customer's ID and an employee's SSN
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
	Zip INT(5) UNSIGNED ZEROFILL,
	Phone BIGINT(10) UNSIGNED ZEROFILL,
	PRIMARY KEY (ID),
	UNIQUE KEY NameAddress (LastName, FirstName, Address, City, State, Zip) # There won't be two people with the same name in the same house
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
	# @TODO: If account creation date is NULL on insert, make Created=CURDATE()
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
	# @TODO: On Employee INSERT/UPDATE, if SSN conflicts with some customer's account ID, change customer ID (?)
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
	OrderDate DATETIME NOT NULL,		# DATETIMEs are formatted like so: '2000-12-31 23:59:59'
	ReturnDate DATETIME DEFAULT NULL,
	PRIMARY KEY (ID),
	CONSTRAINT chk_Dates CHECK (ReturnDate >= OrderDate)
);




#######################
##Relationship Tables##
#######################



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
	# @TODO: If queued time is NULL on insert, make DateAdded=NOW()
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

