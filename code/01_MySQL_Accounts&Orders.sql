#Zhe Lin 
#Sean Pesce 107102508
#Weichao Zhao 
#
#CSE305 Database Project Part 1
#Account & Order Schema


##########################
######Entity Tables#######
##########################

CREATE TABLE Person (
	ID INT,
	LastName VARCHAR(64),
	FirstName VARCHAR(64),
	Address VARCHAR(64),
	City VARCHAR(64),
	State ENUM('AK','AL','AR','AZ','CA','CO','CT', # ENUM Domain (for valid state/territory/base abbreviations)
		'DE','FL','GA','HI','IA','ID','IL','IN','KS',
		'KY','LA','MA','MD','ME','MI','MN','MO','MS',
		'MT','NC','ND','NE','NH','NJ','NM','NV','NY',
		'OH','OK','OR','PA','RI','SC','SD','TN','TX',
		'UT','VA','VT','WA','WI','WV','WY',
		'AS','DC','FM','GU','MH','MP','PR','PW','VI', # Territories/federal districts on this line
		'AA','AE','AP'), # Military bases on this line
	Zip VARCHAR(10),
	Phone VARCHAR(20),
	PRIMARY KEY (ID),
	UNIQUE KEY NameAddress (LastName, FirstName, Address, City, State, Zip) # There won't be two people with the same name in the same house
	# @todo: check that zip/phone are all digits?
);

CREATE TABLE Customer (
	AccountID INT,
	Email VARCHAR(64) NOT NULL,
	AccountType ENUM('Limited', 'Unlimited', 'Unlimited+', 'Unlimited++') NOT NULL DEFAULT 'Limited', # ENUM Domain
	AccountCreated DATE,
	CreditCard CHAR(16) NOT NULL,
	Rating INT DEFAULT 1,
	PRIMARY KEY (AccountID),
	FOREIGN KEY (AccountID) REFERENCES Person(ID)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	UNIQUE KEY (Email),
	CONSTRAINT chk_Rating CHECK (Rating IN (1, 2, 3, 4, 5)),
	CONSTRAINT chk_Email CHECK (Email LIKE '%_@_%._%'), # The '%' char checks for 0 or more chars; '_' checks for exactly 1 character
	CONSTRAINT chk_CC CHECK (CreditCard RLIKE '^[0-9]{16}$') # Check that CC# is composed of only numbers
);


#######################
##Relationship Tables##
#######################








#######################
#########Views#########
#######################

