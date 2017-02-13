#Zhe Lin 
#Sean Pesce 107102508
#Weichao Zhao 
#
#CSE305 Database Project Part 1
#Triggers



############################
#########Procedures#########
############################


# Checks that an employee began working before they helped with an order:
# Procedure:
DELIMITER $$
CREATE PROCEDURE EmployeeExistsBeforeOrder (IN EmployeeID INT, OrderDate DATETIME)
BEGIN
	IF DATE(OrderDate) < (SELECT StartDate
			FROM Employee
			WHERE EmployeeID = Employee.ID
		)
	THEN 
		SIGNAL SQLSTATE 'E0451'
            SET MESSAGE_TEXT = 'Date conflict: Order date precedes Employee start date.';
    END IF;
END;
$$
DELIMITER ;


# Checks that a customer's account was created before they placed an order:
# Procedure:
DELIMITER $$
CREATE PROCEDURE CustomerExistsBeforeOrder (IN CustomerID INT, OrderDate DATETIME)
BEGIN
	IF DATE(OrderDate) < (SELECT AccountCreated
			FROM Customer
			WHERE CustomerID = AccountID
		)
	THEN 
		SIGNAL SQLSTATE 'E0451'
            SET MESSAGE_TEXT = 'Date conflict: Order date precedes Customer\'s account creation.';
    END IF;
END;
$$
DELIMITER ;


# Checks that a customer's account was created before they put a movie in their queue:
# Procedure:
DELIMITER $$
CREATE PROCEDURE CustomerExistsBeforeQueue (IN CustomerID INT, DateAdded DATETIME)
BEGIN
	IF DATE(DateAdded) < (SELECT AccountCreated
			FROM Customer
			WHERE CustomerID = AccountID
		)
	THEN 
		SIGNAL SQLSTATE 'E0451'
            SET MESSAGE_TEXT = 'Date conflict: Date of queue insertion precedes Customer\'s account creation.';
    END IF;
END;
$$
DELIMITER ;


# Checks that customer isn't renting 2 copies of the same movie at the same time:
# Procedure:
DELIMITER $$
CREATE PROCEDURE CantHaveTwoCopies (
	IN LoanStatus ENUM('Expired', 'Active'), CustomerID INT, MovieID INT)
BEGIN
	IF 1 <= (SELECT COUNT(*)
			FROM Rented R1
			WHERE
				LoanStatus = 'Active' AND
				CustomerID = R1.CustomerID AND
				MovieID = R1.MovieID AND
				R1.LoanStatus = 'Active'
		)
	THEN 
		SIGNAL SQLSTATE 'E0928'
            SET MESSAGE_TEXT = 'Rental conflict: Customer is already renting a copy of this movie.';
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



# @TODO: if less than 1 copy available, cant create Rented instance with 'Active'

# @TODO: Available copies can't be more than total


