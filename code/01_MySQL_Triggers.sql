#Zhe Lin 109369879
#Sean Pesce 107102508
#Weichao Zhao 109957656
#
#CSE305 Database Project Part 1
#Triggers



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


# Checks that customer isn't renting 2 copies of the same movie at the same time:
DELIMITER $$
CREATE PROCEDURE CantHaveTwoCopies (
	IN New_LoanStatus ENUM('Expired', 'Active'), New_CustomerID INT, New_MovieID INT)
BEGIN
	IF 	New_LoanStatus = 'Active' AND
		1 <= (SELECT COUNT(*)
			FROM Rented R1
			WHERE
				New_CustomerID = R1.CustomerID AND
				New_MovieID = R1.MovieID AND
				R1.LoanStatus = 'Active'
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
CREATE PROCEDURE CantRentUnavailable (IN New_MovieID INT, New_LoanStatus ENUM('Expired', 'Active'))
BEGIN
	IF 	New_LoanStatus = 'Active' AND
		1 > (SELECT AvailableCopies
			FROM Movie M
			WHERE New_MovieID = M.ID
		)
	THEN 
		SIGNAL SQLSTATE 'E0928'
            SET MESSAGE_TEXT = 'Rental conflict: There are no available copies of this movie.';
    END IF;
END;
$$
DELIMITER ;




############################
##########Triggers##########
############################

# Pre-INSERT trigger for Rented:
DELIMITER $$
CREATE TRIGGER Rented_PreInsert_Checks BEFORE INSERT ON Rented
FOR EACH ROW BEGIN
	CALL CantRentUnavailable(NEW.MovieID, NEW.LoanStatus);
	CALL CantHaveTwoCopies(NEW.LoanStatus, NEW.CustomerID, NEW.MovieID);
	CALL CustomerExistsBeforeOrder (NEW.CustomerID, NEW.OrderDate);
	CALL EmployeeExistsBeforeOrder(NEW.EmployeeID, NEW.OrderDate);
END;
$$
DELIMITER ;
# Pre-UPDATE trigger for Rented:
DELIMITER $$
CREATE TRIGGER Rented_PreUpdate_Checks BEFORE UPDATE ON Rented
FOR EACH ROW BEGIN
	CALL CantRentUnavailable(NEW.MovieID, NEW.LoanStatus);
	CALL CantHaveTwoCopies(NEW.LoanStatus, NEW.CustomerID, NEW.MovieID);
	CALL CustomerExistsBeforeOrder (NEW.CustomerID, NEW.OrderDate);
	CALL EmployeeExistsBeforeOrder(NEW.EmployeeID, NEW.OrderDate);
END;
$$
DELIMITER ;


# Pre-INSERT trigger for Queued:
DELIMITER $$
CREATE TRIGGER Queued_PreInsert_Checks BEFORE INSERT ON Queued
FOR EACH ROW BEGIN
	CALL CustomerExistsBeforeQueue(NEW.CustomerID, NEW.DateAdded);
END;
$$
DELIMITER ;
# Pre-UPDATE trigger for Queued:
DELIMITER $$
CREATE TRIGGER Queued_PreUpdate_Checks BEFORE UPDATE ON Queued
FOR EACH ROW BEGIN
	CALL CustomerExistsBeforeQueue(NEW.CustomerID, NEW.DateAdded);
END;
$$
DELIMITER ;



# @TODO: Available copies can't be more than total

# @TODO: If customer rents a movie, delete it from their queue (if it exists)

# @TODO: Other triggers?


