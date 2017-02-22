#Zhe Lin 
#Sean Pesce 107102508
#Weichao Zhao 
#
#CSE305 Database Project Part 1
#Employee, Customer Account & Order Schema

# @TODO: Add Zhe and Weichao SBU Student ID Numbers in header

##########################
######Entity Tables#######
##########################

CREATE TABLE Person (
	ID INT,
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
	Zip VARCHAR(10),
	Phone VARCHAR(20),
	PRIMARY KEY (ID),
	UNIQUE KEY NameAddress (LastName, FirstName, Address, City, State, Zip), # There won't be two people with the same name in the same house
	CONSTRAINT chk_Zip CHECK (Zip RLIKE '^[0-9]{5}$'),
	CONSTRAINT chk_Phone CHECK (Phone RLIKE '^[0-9]{10}$')
);

CREATE TABLE Customer ( # IsA Person
	AccountID INT, # References Person(ID)
	Email VARCHAR(64) NOT NULL,
	AccountType ENUM('Limited', 'Unlimited', 'Unlimited+', 'Unlimited++') NOT NULL DEFAULT 'Limited', # ENUM Domain
	AccountCreated DATE, # DATEs are formatted like so: '1000-01-01'
	CreditCard CHAR(16) NOT NULL,
	Rating INT DEFAULT 1,
	PRIMARY KEY (AccountID),
	FOREIGN KEY (AccountID) REFERENCES Person(ID)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	UNIQUE KEY (Email), # Don't allow multiple accounts tied to the same email address
	CONSTRAINT chk_Rating CHECK (Rating IN (1, 2, 3, 4, 5)),
	CONSTRAINT chk_Email CHECK (Email LIKE '%_@_%._%'), # The '%' char checks for 0 or more chars; '_' checks for exactly 1 character
	CONSTRAINT chk_CC CHECK (CreditCard RLIKE '^[0-9]{16}$') # Check that CC# is composed of only numbers
);

CREATE TABLE Employee ( # IsA Person
	ID INT, # References Person(ID)
	SSN CHAR(9),
	StartDate DATE,	# Start of employment
	HourlyRate FLOAT NOT NULL DEFAULT 20.00,
	PRIMARY KEY (ID),
	FOREIGN KEY (ID) REFERENCES Person(ID)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	UNIQUE KEY (SSN), # No two people have the same SSN
	CONSTRAINT chk_Pay CHECK (HourlyRate >= 9.00), # Make sure employees don't get paid below minimum wage @TODO: make min wage a constant?
	CONSTRAINT chk_SSN CHECK (SSN RLIKE '^[0-9]{9}$') # Check that SSN is composed of only numbers
);


#######################
##Relationship Tables##
#######################

# Represents movies that have been rented by customers
CREATE TABLE Rented (
	OrderID INT,
	CustomerID INT NOT NULL,
	MovieID INT,
	EmployeeID INT,
	OrderDate DATETIME, # DATETIMEs are formatted like so: '1000-01-01 00:00:00'
	LoanStatus ENUM('Expired', 'Active') NOT NULL DEFAULT 'Active', # If a rental is 'Active', the customer still has the movie out
	PRIMARY KEY (OrderID),
	FOREIGN KEY (CustomerID) REFERENCES Customer(AccountID)
		ON DELETE CASCADE	# If customer account is deleted, delete this order record
		ON UPDATE CASCADE,
	FOREIGN KEY (MovieID) REFERENCES Movie(ID)
		ON DELETE SET NULL
		ON UPDATE CASCADE,
	FOREIGN KEY (EmployeeID) REFERENCES Employee(ID)
		ON DELETE SET NULL
		ON UPDATE CASCADE,
	UNIQUE KEY (CustomerID, MovieID, OrderDate) # Can't rent multiple copies of the same movie at the same time
);


# Represents movies that users have added to their Movie Queue (aka Wishlist)
CREATE TABLE Queued (
	CustomerID INT,
	MovieID INT,
	DateAdded DATETIME,	# Used to sort movies in the queue
	PRIMARY KEY (CustomerID, MovieID),
	FOREIGN KEY (CustomerID) REFERENCES Customer(AccountID)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	FOREIGN KEY (MovieID) REFERENCES Movie(ID)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);



#######################
#########Views#########
#######################

CREATE VIEW MovieQueue (CustomerID, MovieID, DateAdded) AS (
	SELECT CustomerID, MovieID, DateAdded
	FROM Queued JOIN Customer ON (CustomerID = AccountID)
	ORDER BY DateAdded ASC
);

CREATE VIEW RentalHistory (CustomerID, MovieID, Title, Genre, Rating, OrderDate, LoanStatus) AS (
	SELECT CustomerID, MovieID, Title, Genre, Movie.Rating, OrderDate, LoanStatus
	FROM Rented JOIN Movie ON (MovieID = ID)
	ORDER BY OrderDate DESC
);

# List of movies that customers currently have loaned:
CREATE VIEW CurrentLoans (CustomerID, MovieID, Title, OrderDate) AS (
	SELECT CustomerID, MovieID, Title, OrderDate
	FROM Rented JOIN Movie ON (MovieID = ID)
	WHERE LoanStatus = 'Active'
);

# @TODO: Other views?



############################
#########Assertions#########
############################
# NOTE: MySQL doesn't support assertions. These were replaced with triggers.

# Asserts that an employee began working before they helped with any orders:
CREATE ASSERTION EmployeeExistsForOrder CHECK (
	NOT EXISTS (
		SELECT OrderDate, StartDate
		FROM Rented JOIN Employee ON (EmployeeID = Employee.ID)
		WHERE DATE(OrderDate) < StartDate
	)
);

# Asserts that a customer's account was created before they placed any orders:
CREATE ASSERTION CustomerExistsForOrder CHECK (
	NOT EXISTS (
		SELECT OrderDate, AccountCreated
		FROM Rented JOIN Customer ON (CustomerID = AccountID)
		WHERE DATE(OrderDate) < AccountCreated
	)
);

# Asserts that a customer's account was created before they put any movies in their queue:
CREATE ASSERTION CustomerExistsForQueue CHECK (
	NOT EXISTS (
		SELECT DateAdded, AccountCreated
		FROM Queued JOIN Customer ON (CustomerID = AccountID)
		WHERE DATE(DateAdded) < AccountCreated
	)
);

# Asserts that customer isn't renting 2 of the same movie at the same time:
CREATE ASSERTION CustomersCantRentMultipleCopiesOfSameMovie CHECK (
	NOT EXISTS (
		SELECT CustomerID, MovieID, OrderID
		FROM Rented R1
		WHERE EXISTS (
			SELECT CustomerID, MovieID, OrderID
			FROM Rented R2
			WHERE
				R2.LoanStatus = 'Active' AND
				R2.CustomerID = R1.CustomerID AND
				R2.MovieID = R1.MovieID AND
				NOT (R2.OrderID = R1.OrderID)
		)
	)
);