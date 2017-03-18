# Zhe Lin 109369879
# Sean Pesce 107102508
# Weichao Zhao 109957656
#
# CSE305 Database Project Part 2
# Database Schema - Views



#######################
#########Views#########
#######################



###### Manager-Level Views ######

# Obtain a sales report (i.e. the overall income from all active subscriptions) for a particular month:
CREATE VIEW SalesReport (AccountID, AccountType, Income) AS (
	SELECT A1.ID, A1.Subscription, 0.00
    FROM Account A1
    WHERE A1.Subscription = 'Limited')
    UNION
    (SELECT A2.ID, A2.Subscription, 5.00
    FROM Account A2
    WHERE A2.Subscription = 'Unlimited')
    UNION
    (SELECT A3.ID, A3.Subscription, 10.00
    FROM Account A3
    WHERE A3.Subscription = 'Unlimited+')
    UNION
    (SELECT A4.ID, A4.Subscription, 15.00
    FROM Account A4
    WHERE A4.Subscription = 'Unlimited++'
);

# Produce a list of movie rentals by movie name:
CREATE VIEW RentalsByMovie (Title, OrderID, AccountID, EmployeeID, MovieID) AS (
    SELECT M.Title, R.OrderID, R.AccountID, R.EmployeeID, R.MovieID
    FROM Rental R JOIN Movie M ON (R.MovieID = M.ID)
    # WHERE M.Title = 'Movie Title'   # When a manager uses this transaction, title needs to be specified
);

# Produce a list of movie rentals by customer name:
CREATE VIEW RentalsByCustomer (CustomerName, OrderID, AccountID, EmployeeID, MovieID) AS (
    SELECT P.FullName, R.OrderID, R.AccountID, R.EmployeeID, R.MovieID
    FROM Rental R JOIN (SELECT ID, CONCAT(FirstName, ' ', LastName) FullName
	                    FROM Person) P
    # WHERE CustomerName='Customer Name'    # When a manager uses this transaction, customer's full name needs to be specified
);

# Produce a list of movie rentals by movie genre/type:
CREATE VIEW RentalsByGenre (Genre, OrderID, AccountID, EmployeeID, MovieID) AS (
	SELECT M.Genre, R.OrderID, R.AccountID, R.EmployeeID, R.MovieID
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
CREATE VIEW MostActiveCustomer (AccountID, CustomerID, Rating, JoinDate) AS (
	SELECT A.ID, A.CustomerID, C.Rating, A.Created 
	FROM Customer C JOIN Account A ON C.ID = A.CustomerID
	ORDER BY A.CustomerID DESC, A.Created DESC		# Sort by customer rating
);

# Produce a list of most actively rented movies:
CREATE VIEW PopularMovies (RentalCount, MovieID, Title) AS (
	SELECT R.TotalRentals, M.ID, M.Title
	FROM Movie M JOIN (SELECT COUNT(*) TotalRentals, MovieID
					   FROM Rental
					   GROUP BY MovieID) R ON M.ID = R.MovieID
	ORDER BY R.TotalRentals DESC
);


###### Other Views ######

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

