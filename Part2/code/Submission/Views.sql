# Zhe Lin 109369879
# Sean Pesce 107102508
# Weichao Zhao 109957656
#
# CSE305 Database Project Part 2
# Database Schema - Views (Compilation for submission of Assigment 2)


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









###### Customer-Level Views ######
# (Used for Customer-level transactions)


# Customer's currently held movies (List of movies each customer has out):
CREATE VIEW CurrentRentals (AccountID, MovieID, Title, OrderDate) AS (
	SELECT AccountID, MovieID, Title, OrderDate
	FROM (Rental JOIN _Order ON OrderID = _Order.ID) JOIN Movie ON (MovieID = Movie.ID)
	WHERE ReturnDate = NULL
	ORDER BY OrderDate ASC
);


# Customer's queue of movies they would like to see:
CREATE VIEW MovieQueue (AccountID, CustomerID, MovieID, Title, DateAdded) AS (
	SELECT Q.AccountID, A.CustomerID, Q.MovieID, M.Title, Q.DateAdded
	FROM (Queued Q JOIN Movie M ON (Q.MovieID = M.ID)) JOIN Account A ON (Q.AccountID = A.ID)
	ORDER BY DateAdded ASC
);


# History of all current and past orders a customer has placed:
CREATE VIEW RentalHistory (AccountID, OrderID, MovieID, Title, Genre, Rating, OrderDate, ReturnDate) AS (
	SELECT AccountID, OrderID, MovieID, Title, Genre, Movie.Rating, OrderDate, ReturnDate
	FROM (Rental JOIN _Order ON OrderID = _Order.ID) JOIN Movie ON (MovieID = Movie.ID)
	ORDER BY OrderDate DESC
);


# Movies available of a particular type/genre:
CREATE VIEW AvailableMovies(MovieID, Title, Genre, Rating, AvailableCopies, TotalCopies) AS (
	SELECT MovieID, Title, Genre, Rating, A.Copies, TotalCopies
	FROM Movie JOIN AvailableCopies A ON (ID=A.MovieID)
	WHERE A.Copies > 0
);


# Movies available starring a particular actor or group of actors:
CREATE VIEW Roles (ActorID, ActorName, MovieID, Title, Genre, MovieRating) AS (
	SELECT Casted.ActorID, FullName, MovieID, Title, Genre, Movie.Rating
	FROM ((Actor JOIN ActorName ON (Actor.ID = ActorName.ActorID)) JOIN Casted ON (Actor.ID = Casted.ActorID)) JOIN Movie ON (MovieID = Movie.ID)
);


