
 Zhe Lin 109369879
# Sean Pesce 107102508
# Weichao Zhao 109957656
#
# CSE305 Database Project Part 2
# Database Schema - Final Transaction Compilation (For Submission)






########################################
###### Manager-Level Transactions ######
########################################


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
DELIMITER $$    # NOTE: We should use this procedure in the write-up for Assignment 2, but we will not be using this in our final implementation
CREATE PROCEDURE AddEmployee (IN    new_Position ENUM('Manager', 'Customer Rep'), new_SSN INT UNSIGNED, new_FirstName VARCHAR(64),
                                    new_LastName VARCHAR(64), new_Address VARCHAR(64), new_City VARCHAR(64), new_State CHAR(2),
                                    new_Zip INT(5) UNSIGNED, new_Phone BIGINT(10) UNSIGNED, new_StartDate DATE, new_Wage FLOAT)
BEGIN
    START TRANSACTION;
    INSERT INTO Person (ID, LastName, FirstName, Address, City, State, Zip, Phone)
    VALUES (new_SSN, new_LastName, new_FirstName, new_Address, new_City, UPPER(new_State), new_Zip, new_Phone);
    INSERT INTO Employee (SSN, Position, StartDate, HourlyRate)
    VALUES (new_SSN, new_Position, new_StartDate, new_Wage);
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


# Obtain a sales report (i.e. the overall income from all active subscriptions) for a particular month:
SELECT SUM(S.Income)
FROM SalesReport S     # See Views
WHERE S.AccountCreated < ?), 2));   # ? Is the first day of the next month



# Produce a comprehensive listing of all movies:
SELECT *
FROM Movie
ORDER BY Title ASC


# Produce a list of movie rentals by movie name/title:
SELECT *
FROM RentalsByMovie     # See Views
WHERE Title = ?;     # ? Is the Title of the Movie


# Produce a list of movie rentals by movie type (genre):
SELECT *
FROM RentalsByGenre     # See Views
WHERE Genre = ?;     # ? Is the Movie Genre ('Comedy', 'Drama', 'Action', 'Foreign')


# Produce a list of movie rentals by Customer name:
SELECT *
FROM RentalsByCustomer      # See Views
WHERE CustomerName = ?;     # ? Is the customer's full name ('FirstName LastName')


# Determine which customer representative oversaw the most transactions (rentals):
SELECT *
FROM RepRentalCount # See Views
LIMIT 1;


# Produce a list of most active customers:
SELECT *
FROM MostActiveCustomers; # See Views


# Produce a list of most actively rented movies:
SELECT *
FROM PopularMovies; # See Views









#############################################
###### Customer Rep-Level Transactions ######
#############################################


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
        VALUES (new_Email, new_CreditCard, LAST_INSERT_ID() );
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
        VALUES (new_OrderDate); # If new_OrderDate is NULL, the current date/time is automatically generated for this record
        INSERT INTO Rental (AccountID, MovieID, EmployeeID, OrderID)
        VALUES (new_AccountID, new_MovieID, new_EmployeeID, LAST_INSERT_ID() );
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



# Produce customer mailing lists:
SELECT *
FROM MailingList    # See Views
WHERE Subscription = ?;     # ? Is the account subscription type ('Limited', 'Unlimited', 'Unlimited+', 'Unlimited++')



# Produce a list of movie suggestions for a given customer, by 1.filtering same actors 2. from neighbors
SELECT M.Title
FROM Movie M, Rental R,Casted C1, Casted C2
WHERE M.ID NOT IN (SELECT MovieID FROM R WHERE R.AccountID = ?) AND # ? is the Account number of the given customer
((C1.MovieID = M.ID AND C2.MovieID = R.MovieID AND C1.ActorID = C2.ActorID) OR
(MovieID IN (SELECT MovieID FROM R WHERE R.AccountID = ?-1 % COUNT(R.AccountID) OR R.AccountID = ?+1 % COUNT(R.AccountID)))
); 







#########################################
###### Customer-Level Transactions ######
#########################################


# Customer's currently held movies:
SELECT MovieID, Title, OrderDate
FROM CurrentRentals CR    # See Views
WHERE CR.AccountID = ?;   # ? Is the customer's account ID


# Customer's queue of movies they would like to see:
SELECT MovieID, Title, DateAdded
FROM MovieQueue MQ    # See Views
WHERE CR.AccountID = ?;   # ? Is the customer's account ID


# Customer's account settings (Subscription type):
SELECT Subscription
FROM Account
WHERE ID = ?;   # ? Is the customer's account ID


# History of all current and past orders a customer has placed:
SELECT OrderID, MovieID, Title, OrderDate, ReturnDate
FROM RentalHistory    # See Views
WHERE AccountID = ?;   # ? Is the customer's account ID


# Movies available of a particular type/genre:
SELECT *
FROM AvailableMovies    # See Views
WHERE Genre = ?;   # ? Is the genre of movie the user wants to see


# Movies available with a particular keyword or set of keywords in the movie name:
SELECT *
FROM AvailableMovies    # See Views
WHERE Title LIKE '%?%';   # ? Is the key word(s) in the title of the movie


# Movies available starring a particular actor or group of actors:
SELECT ActorID, MovieID, Title, Genre, MovieRating
FROM Roles    # See Views
WHERE ActorName = ?;   # ? Is the full name of the actor(s) the user wants to see ('FirstName LastName')


# Best-Seller list of movies (top 10)
SELECT R.Title
FROM RentTimes
LIMIT 10;

# Personalized movie suggestion list (Assuming that customer provide a actor name)
SELECT M.Title
From Movie M, Casted C, Actor A
WHERE M.ID = C.MovieID
AND CONCAT(A.FirstName, ' ', A.LastName) = ? # ? is the actor name provided
AND C.ActorID = A.ID;

# Rate the movies the customer has rented
DELIMITER $$
CREATE PROCEDURE rateRented (IN mvTitle CHAR, rate INT UNSIGNED)
BEGIN
    START TRANSACTION;
		IF mvTitle IN (SELECT Title FROM RentalsByMovie WHERE AccountID = ?) THEN # ? is the account id of the customer		
			UPDATE Movie
			SET Rating = (rate + Rating) / (1 + (SELECT countTimes FROM RentTimes WHERE Title = mvTitle))
			WHERE Title = mvTitle;	
		END IF;
    COMMIT;
END;
$$
DELIMITER ;


