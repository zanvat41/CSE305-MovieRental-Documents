# Zhe Lin 109369879
# Sean Pesce 107102508
# Weichao Zhao 109957656
#
# CSE305 Database Project Part 2
# Database Schema - Procedures & Triggers



############################
#########Procedures#########
############################


# Checks that an employee began working before they helped with an order:
DELIMITER $$
CREATE PROCEDURE EmployeeExistsBeforeOrder (IN New_EmployeeID INT, New_OrderDate DATETIME)
BEGIN
	IF DATE(New_OrderDate) < (SELECT StartDate
			FROM Employee
			WHERE New_EmployeeID = Employee.ID
		)
	THEN 
		SIGNAL SQLSTATE 'E0451'
            SET MESSAGE_TEXT = 'Date conflict: Order date precedes Employee start date.';
    END IF;
END;
$$
DELIMITER ;


# Checks that a customer's account was created before they placed an order:
DELIMITER $$
CREATE PROCEDURE CustomerExistsBeforeOrder (IN New_CustomerID INT, New_OrderDate DATETIME)
BEGIN
	IF DATE(New_OrderDate) < (SELECT AccountCreated
			FROM Customer
			WHERE New_CustomerID = AccountID
		)
	THEN 
		SIGNAL SQLSTATE 'E0451'
            SET MESSAGE_TEXT = 'Date conflict: Order date precedes Customer\'s account creation.';
    END IF;
END;
$$
DELIMITER ;


# Checks that a customer's account was created before they put a movie in their queue:
DELIMITER $$
CREATE PROCEDURE CustomerExistsBeforeQueue (IN New_CustomerID INT, New_DateAdded DATETIME)
BEGIN
	IF DATE(New_DateAdded) < (SELECT AccountCreated
			FROM Customer
			WHERE New_CustomerID = AccountID
		)
	THEN 
		SIGNAL SQLSTATE 'E0451'
            SET MESSAGE_TEXT = 'Date conflict: Date of queue insertion precedes Customer\'s account creation.';
    END IF;
END;
$$
DELIMITER ;


# Checks that an order's OrderDate precedes the ReturnDate:
DELIMITER $$
CREATE PROCEDURE CantReturnBeforeRenting (IN New_OrderID INT, New_OrderDate DATETIME, New_ReturnDate DATETIME)
BEGIN
	IF	 (New_ReturnDate != NULL) AND
		New_ReturnDate < New_OrderDate
	THEN 
		SIGNAL SQLSTATE 'E0451'
            SET MESSAGE_TEXT = 'Date conflict: Date of return precedes date when order was placed.';
    END IF;
END;
$$
DELIMITER ;


# Checks that customer isn't renting 2 copies of the same movie at the same time:
DELIMITER $$
CREATE PROCEDURE CantHaveTwoCopies (
	IN New_OrderID INT, New_ReturnDate DATETIME, New_CustomerID INT, New_MovieID INT)
BEGIN
	IF 	New_ReturnDate = NULL AND
		EXISTS (SELECT *
			FROM Rental R1
			WHERE
				New_CustomerID = R1.CustomerID AND
				New_MovieID = R1.MovieID AND
				R1.ReturnDate = NULL AND
				New_OrderID != R1.OrderID
		)
	THEN 
		SIGNAL SQLSTATE 'E0928'
            SET MESSAGE_TEXT = 'Rental conflict: Customer is already renting a copy of this movie.';
    END IF;
END;
$$
DELIMITER ;


# Checks that customer can't rent a movie if no copies are available:
DELIMITER $$
CREATE PROCEDURE CantRentUnavailable (IN New_OrderID INT, New_MovieID INT, New_ReturnDate DATETIME)
BEGIN
	IF 	New_ReturnDate = NULL AND (
			(SELECT TotalCopies
			FROM Movie
			WHERE MovieID = New_MovieID
			)
		 	<=
		 	(SELECT COUNT(*)
			FROM Rental R
			WHERE New_MovieID = R.MovieID AND
			R.ReturnDate = NULL AND
			New_OrderID != R.OrderID
			))
	THEN 
		SIGNAL SQLSTATE 'E0928'
            SET MESSAGE_TEXT = 'Rental conflict: There are no available copies of this movie.';
    END IF;
END;
$$
DELIMITER ;


# If a movie is rented and not expired, delete from Queued:
DELIMITER $$
CREATE PROCEDURE DeleteFromQueue (IN New_ReturnDate DATETIME, New_CustomerID INT, New_MovieID INT)
BEGIN
		DELETE FROM QUEUED 
		WHERE MovieID = New_MovieID AND
			CustomerID = New_CustomerID;
END;
$$
DELIMITER ;


############################
##########Triggers##########
############################

# Pre-INSERT trigger for Rental:
DELIMITER $$
CREATE TRIGGER Rental_PreInsert_Checks BEFORE INSERT ON Rental
FOR EACH ROW BEGIN
	CALL CantRentUnavailable(NEW.OrderID, NEW.MovieID, NEW.ReturnDate);
	CALL CantHaveTwoCopies(NEW.OrderID, NEW.ReturnDate, NEW.AccountID, NEW.MovieID);
	CALL CustomerExistsBeforeOrder (NEW.AccountID, NEW.OrderDate);
	CALL EmployeeExistsBeforeOrder(NEW.EmployeeID, NEW.OrderDate);
	CALL CantReturnBeforeRenting(NEW.OrderID, NEW.OrderDate, NEW.ReturnDate);
END;
$$
DELIMITER ;
# Post-INSERT trigger for Rental:
DELIMITER $$
CREATE TRIGGER Rental_PostInsert_Checks AFTER INSERT ON Rental
FOR EACH ROW BEGIN
	CALL DeleteFromQueue(NEW.ReturnDate, NEW.AccountID, NEW.MovieID);
END;
$$
DELIMITER ;
# Pre-UPDATE trigger for Rental:
DELIMITER $$
CREATE TRIGGER Rental_PreUpdate_Checks BEFORE UPDATE ON Rental
FOR EACH ROW BEGIN
	CALL CantRentUnavailable(NEW.OrderID, NEW.MovieID, NEW.ReturnDate);
	CALL CantHaveTwoCopies(NEW.OrderID, NEW.ReturnDate, NEW.AccountID, NEW.MovieID);
	CALL CustomerExistsBeforeOrder (NEW.AccountID, NEW.OrderDate);
	CALL EmployeeExistsBeforeOrder(NEW.EmployeeID, NEW.OrderDate);
	CALL CantReturnBeforeRenting(NEW.OrderID, NEW.OrderDate, NEW.ReturnDate);
END;
$$
DELIMITER ;
# Post-INSERT trigger for Rental:
DELIMITER $$
CREATE TRIGGER Rental_PostUpdate_Checks AFTER UPDATE ON Rental
FOR EACH ROW BEGIN
	CALL DeleteFromQueue(NEW.ReturnDate, NEW.AccountID, NEW.MovieID);
END;
$$
DELIMITER ;


# Pre-INSERT trigger for Queued:
DELIMITER $$
CREATE TRIGGER Queued_PreInsert_Checks BEFORE INSERT ON Queued
FOR EACH ROW BEGIN
	CALL CustomerExistsBeforeQueue(NEW.AccountID, NEW.DateAdded);
END;
$$
DELIMITER ;
# Pre-UPDATE trigger for Queued:
DELIMITER $$
CREATE TRIGGER Queued_PreUpdate_Checks BEFORE UPDATE ON Queued
FOR EACH ROW BEGIN
	CALL CustomerExistsBeforeQueue(NEW.AccountID, NEW.DateAdded);
END;
$$
DELIMITER ;



# Pre-INSERT trigger for Movie:
DELIMITER $$
CREATE TRIGGER Movie_PreInsert_Checks BEFORE INSERT ON Movie
FOR EACH ROW BEGIN
	# @TODO
END;
$$
DELIMITER ;
# Pre-UPDATE trigger for Movie:
DELIMITER $$
CREATE TRIGGER Movie_PreUpdate_Checks BEFORE UPDATE ON Movie
FOR EACH ROW BEGIN
	# @TODO
END;
$$
DELIMITER ;
