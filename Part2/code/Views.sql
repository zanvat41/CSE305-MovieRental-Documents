# Zhe Lin 109369879
# Sean Pesce 107102508
# Weichao Zhao 109957656
#
# CSE305 Database Project Part 2
# Database Schema - Views



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

CREATE VIEW Invoice (OrderID, AccountID, OrderDate, ReturnDate, MovieID, RepID) AS (
	SELECT OrderID, AccountID, OrderDate, ReturnDate, MovieID, EmployeeID
	FROM Rental JOIN _Order ON (OrderID = ID)
);

CREATE VIEW PersonName (PersonID, Name) AS (
	SELECT ID, CONCAT(FirstName, ' ', LastName)
	FROM Person
);

CREATE VIEW ActorName (ActorID, Name) AS (
	SELECT ID, CONCAT(FirstName, ' ', LastName)
	FROM Actor
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
	SELECT P.ID, INSERT(INSERT(INSERT(P.Phone, 1, 0, '('), 5, 0, ') '), 10, 0, '-')
	FROM Person P
);

# Obtains phone numbers with the format: 000-000-0000
CREATE VIEW PhoneNumber2 (PersonID, Telephone) AS (
	SELECT P.ID, INSERT(INSERT(P.Phone, 4, 0, '-'), 8, 0, '-')
	FROM Person P
);

# Obtains formatted SSN:
CREATE VIEW SocialSecurity (PersonID, SSN) AS (
	SELECT P.ID, INSERT(INSERT(P.ID, 4, 0, '-'), 7, 0, '-')
	FROM Person P
);

# Obtains formatted CC #:
CREATE VIEW CreditCardNum (CustomerID, CC) AS (
	SELECT C.ID, INSERT(INSERT(INSERT(C.CreditCard, 5, 0, ' '), 10, 0, ' '), 15, 0, ' ')
	FROM Customer C
);

CREATE VIEW FullAddress(PersonID, FullAddr) AS (
	SELECT P.ID, CONCAT(P.Address, '\n', P.City, ', ', P.State, ' ', P.Zip)
	FROM Person P
);

CREATE VIEW MailingAddress(PersonID, MailAddr) AS (
	SELECT P.ID, CONCAT(P.FirstName, ' ', P.LastName, '\n', P.Address, '\n', P.City, ', ', P.State, ' ', P.Zip)
	FROM Person P
);
