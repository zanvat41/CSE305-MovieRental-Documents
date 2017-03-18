# Zhe Lin 109369879
# Sean Pesce 107102508
# Weichao Zhao 109957656
#
# CSE305 Database Project Part 2
# Database Insert Statements



####################################################################
##################### CUSTOMERS & EMPLOYEES ########################
####################################################################


### Customers ###

INSERT INTO Person (ID, LastName, FirstName, Address, City, State, Zip, Phone)
VALUES (111111111, 'Yang', 'Shang', '123 Success Street',  'Stony Brook', 'NY', 11790, 5166328959);

INSERT INTO Customer (ID, Email, CreditCard, Rating)
VALUES (111111111, 'syang@cs.sunysb.edu', 1234567812345678, 1); # Shang Yang



INSERT INTO Person (ID, LastName, FirstName, Address, City, State, Zip, Phone)
VALUES (222222222, 'Du', 'Victor', '456 Fortune Road',  'Stony Brook', 'NY', 11790, 5166324360);

INSERT INTO Customer (ID, Email, CreditCard, Rating)
VALUES (222222222, 'vicdu@cs.sunysb.edu', 5678123456781234, 1); # Victor Du



INSERT INTO Person (ID, LastName, FirstName, Address, City, State, Zip, Phone)
VALUES (333333333, 'Smith', 'John', '789 Peace Blvd.',  'Los Angeles', 'CA', 93536, 3154434321);

INSERT INTO Customer (ID, Email, CreditCard, Rating)
VALUES (333333333, 'jsmith@ic.sunysb.edu', 2345678923456789, 1); # John Smith



INSERT INTO Person (ID, LastName, FirstName, Address, City, State, Zip, Phone)
VALUES (444444444, 'Phillip', 'Lewis', '135 Knowledge Lane',  'Stony Brook', 'NY', 11794, 5166668888);

INSERT INTO Customer (ID, Email, CreditCard, Rating)
VALUES (444444444, 'pml@cs.sunysb.edu', 6789234567892345, 1); # Lewis Phillip



### Employees ###

INSERT INTO Person (ID, LastName, FirstName, Address, City, State, Zip, Phone)
VALUES (123456789, 'Smith', 'David', '123 College road',  'Stony Brook', 'NY', 11790, 5162152345);

INSERT INTO Employee (SSN, StartDate, Position, HourlyRate)
VALUES (123456789, '2005-11-01', 'Customer Rep', 60.00); # David Smith



INSERT INTO Person (ID, LastName, FirstName, Address, City, State, Zip, Phone)
VALUES (789123456, 'Warren', 'David', '456 Sunken Street',  'Stony Brook', 'NY', 11794, 6316329987); # Manager

INSERT INTO Employee (SSN, StartDate, Position, HourlyRate)
VALUES (789123456, '2006-02-02', 'Manager', 50.00); # David Warren (Manager)





####################################################################
######################## ACTORS & MOVIES ###########################
####################################################################

### Movies ###

INSERT INTO Movie (ID, Title, Genre, Fee, TotalCopies, Rating)
VALUES (1, 'The Godfather', 'Drama', 10000.00, 3, 5);

INSERT INTO Movie (ID, Title, Genre, Fee, TotalCopies, Rating)
VALUES (2, 'Shawshank Redemption', 'Drama', 1000.00, 2, 4);

INSERT INTO Movie (ID, Title, Genre, Fee, TotalCopies, Rating)
VALUES (3, 'Borat', 'Comedy', 500.00, 1, 3);



### Actors / Roles ###

INSERT INTO Actor (ID, FirstName, LastName, Gender, Age, Rating)
VALUES (1, 'Al', 'Pacino', 'M', 63, 5);

INSERT INTO Casted (ActorID, MovieID, Role)
VALUES (1, 1, NULL); # The Godfather

INSERT INTO Casted (ActorID, MovieID, Role)
VALUES (1, 3, NULL); # Borat



INSERT INTO Actor (ID, FirstName, LastName, Gender, Age, Rating)
VALUES (2, 'Tim', 'Robbins', 'M', 53, 2);

INSERT INTO Casted (ActorID, MovieID, Role)
VALUES (2, 1, NULL); # The Godfather





####################################################################
####################### ACCOUNTS & ORDERS ##########################
####################################################################



### Accounts ###


INSERT INTO Account (ID, CustomerID, Subscription, Created)
VALUES (1, 444444444, 'Unlimited+', '2006-10-01'); # Lewis Phillip's account

# INSERT INTO Queued (AccountID, MovieID, DateAdded)
# VALUES (1, 1, NULL); # The Godfather

# INSERT INTO Queued (AccountID, MovieID, DateAdded)
# VALUES (1, 3, NULL); # Borat



INSERT INTO Account (ID, CustomerID, Subscription, Created)
VALUES (2, 222222222, 'Limited', '2006-10-15'); # Victor Du's account

# INSERT INTO Queued (AccountID, MovieID, DateAdded)
# VALUES (2, 2, NULL); # Shawshank Redemption

# INSERT INTO Queued (AccountID, MovieID, DateAdded)
# VALUES (2, 3, NULL); # Borat



### Orders/Rentals ###

INSERT INTO _Order (ID, OrderDate, ReturnDate)
VALUES (1, '2009-11-11 10:00:00', '2009-11-14 00:00:00'); # Lewis Phillip rented The Godfather

INSERT INTO Rental (OrderID, AccountID, MovieID, EmployeeID)
VALUES (1, 1, 1, 123456789); # Lewis Phillip rented The Godfather



INSERT INTO _Order (ID, OrderDate, ReturnDate)
VALUES (2, '2009-11-11 18:15:00', NULL); # Victor Du rented Borat

INSERT INTO Rental (OrderID, AccountID, MovieID, EmployeeID)
VALUES (2, 2, 3, 789123456); # Victor Du rented Borat



INSERT INTO _Order (ID, OrderDate, ReturnDate)
VALUES (3, '2009-11-12 09:30:00', NULL); # Lewis Phillip rented Borat

INSERT INTO Rental (OrderID, AccountID, MovieID, EmployeeID)
VALUES (3, 1, 3, 789123456); # Lewis Phillip rented Borat



INSERT INTO _Order (ID, OrderDate, ReturnDate)
VALUES (4, '2009-11-21 22:22:00', NULL); # Victor Du rented The Shawshank Redemption

INSERT INTO Rental (OrderID, AccountID, MovieID, EmployeeID)
VALUES (4, 2, 2, 123456789); # Victor Du rented The Shawshank Redemption