#Zhe Lin 
#Sean Pesce 107102508
#Weichao Zhao 
#
#CSE305 Database Project Part 1


##########################
#########Domains##########
##########################

CREATE DOMAIN Genres VARCHAR(7) CHECK (
	VALUE IN ('Comedy', 'Drama', 'Action', 'Foreign')
);

CREATE DOMAIN Ratings INT CHECK (
	VALUE IN (1, 2, 3, 4, 5)
);

CREATE DOMAIN Genders CHAR CHECK (
	VALUE IN ('M', 'F')
);



##########################
######Entity Tables#######
##########################

CREATE TABLE Movie (
	ID INT,
	Title VARCHAR(64) NOT NULL,
	Genre Genres,
	Fee FLOAT DEFAULT 0.00,
	TotalCopies INT DEFAULT 0,
	AvailableCopies INT DEFAULT 0,
	Rating Ratings,
	PRIMARY KEY (ID),
	CONSTRAINT chk_TotalCopies CHECK (TotalCopies >= 0),
	CONSTRAINT chk_AvailableCopies CHECK (AvailableCopies >= 0),
	CONSTRAINT chk_AvailableVsTotalCopies CHECK (AvailableCopies <= TotalCopies),
	CONSTRAINT chk_Fee CHECK (Fee >= 0.0)
);

CREATE TABLE Actor (
	ID INT,
	FirstName VARCHAR(64) NOT NULL,
	LastName VARCHAR(64) NOT NULL,
	Gender Genders,
	Age INT,
	Rating Ratings,
	PRIMARY KEY (ID),
	CONSTRAINT chk_Age CHECK (Age >= 0)
);



#######################
##Relationship Tables##
#######################

# Represents a relationship between an actor and a movie they have been
#  casted in.
CREATE TABLE Casted (
	ActorID INT,
	MovieID INT,
	Role VARCHAR(128),
	PRIMARY KEY (ActorID, MovieID),
	FOREIGN KEY (ActorID) REFERENCES Actor(ID)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	FOREIGN KEY (MovieID) REFERENCES Movie(ID)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);



#######################
#########Views#########
#######################

# Lists all actors casted in each movie
CREATE VIEW CastList (MovieID, ActorID, FirstName, LastName, Gender, Age, ActorRating) AS (
	SELECT MovieID, ActorID, FirstName, LastName, Gender, Age, Actor.Rating
	FROM (Actor JOIN Casted ON (Actor.ID = ActorID)) JOIN Movie ON (MovieID = Movie.ID)
);

# Lists all movies each actor has been in
CREATE VIEW Roles (ActorID, MovieID, Title, Genre, MovieRating) AS (
	SELECT ActorID, MovieID, Title, Genre, Movie.Rating
	FROM (Actor JOIN Casted ON (Actor.ID = ActorID)) JOIN Movie ON (MovieID = Movie.ID)
);
