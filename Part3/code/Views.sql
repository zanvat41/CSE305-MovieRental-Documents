# Zhe Lin 109369879
# Sean Pesce 107102508
# Weichao Zhao 109957656
#
# CSE305 Database Project Part 3
# Database Schema - Views



#######################
#########Views#########
#######################



###### Manager-Level Views ######
# (Used for Manager-level transactions)

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




###### Customer Representative-Level Views ######
# (Used for Customer Rep-level transactions)

# Produce customer mailing lists:
CREATE VIEW MailingList (AccountID, CustomerID, CustomerName, Email, Subscription) AS (
	SELECT A.ID, C.ID, C.FullName, C.Email, A.Subscription
	FROM Account A JOIN (SELECT C1.ID, CONCAT(P.FirstName, ' ', P.LastName) FullName, C1.Email
						 FROM Customer C1 JOIN Person P ON C1.ID = P.ID) C ON A.CustomerID = C.ID
);

# @TODO: "Produce a list of movie suggestions for a given customer" (?? From project spec)




###### Customer-Level Views ######
# Customer-Level transactions are essentially Views because none of the Customer-level transactions alter the database

# List of movies each customer has out:
CREATE VIEW CurrentRentals (AccountID, MovieID, Title, OrderDate) AS (
	SELECT AccountID, MovieID, Title, OrderDate
	FROM (Rental JOIN _Order ON OrderID = _Order.ID) JOIN Movie ON (MovieID = Movie.ID)
	WHERE ReturnDate IS NULL
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

# List of movies with no current rentals (all copies are currently available):
CREATE VIEW MoviesWithAllCopiesAvailable(MovieID, Title, TotalCopies, CurrentRentals, AvailableCopies) AS (
	SELECT M.ID, M.Title, M.TotalCopies, 0, M.TotalCopies
	FROM Movie M JOIN Rental R ON R.MovieID = M.ID
	WHERE NOT EXISTS (SELECT * FROM _Order O JOIN Rental R2 ON O.ID = R2.OrderID WHERE O.ReturnDate IS NULL AND R2.MovieID = M.ID)
);

# List of movies with some current rentals, but some copies available:
CREATE VIEW MoviesWithSomeAvailableCopies(MovieID, Title, TotalCopies, CurrentRentals, AvailableCopies) AS (
	SELECT R.MovieID, M.Title, M.TotalCopies, COUNT(*), M.TotalCopies - COUNT(*)
	FROM (_Order O JOIN Rental R ON O.ID = R.OrderID) JOIN Movie M ON R.MovieID = M.ID
	WHERE O.ReturnDate IS NULL
	GROUP BY R.MovieID
);

# List of available movies and the number of copies available for each of those movies:
CREATE VIEW AvailableMovies(MovieID, Title, TotalCopies, CurrentRentals, AvailableCopies) AS 
	(SELECT *
	FROM MoviesWithAllCopiesAvailable AS List1)
	UNION
	(SELECT *
	FROM MoviesWithSomeAvailableCopies AS List2)
	
;


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


###### General Views ######

# List of movies that customers currently have loaned:
CREATE VIEW CurrentLoans (AccountID, MovieID, Title, OrderDate) AS (
	SELECT AccountID, MovieID, Title, OrderDate
	FROM (Rental JOIN _Order ON OrderID = _Order.ID) JOIN Movie ON (MovieID = Movie.ID)
	WHERE ReturnDate IS NULL
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

