The following is a list of INSERT statements that can be used to test the database:



INSERT INTO Movie (ID, Title, Genre, Fee, Copies, Rating)
VALUES (1, 'BvS', 'Comedy', 0.50, 3, 3);
INSERT INTO Movie (ID, Title, Genre, Fee, Copies, Rating)
VALUES (2, 'LoTR', 'Drama', 0.60, 5, 4);
INSERT INTO Movie (ID, Title, Genre, Fee, Copies, Rating)
VALUES (3, 'Hackers', 'Action', 0.70, 8, 5);
INSERT INTO Movie (ID, Title, Genre, Fee, Copies, Rating)
VALUES (4, 'Zoolander', 'Comedy', 1.10, 2, 5);
INSERT INTO Movie (ID, Title, Genre, Fee, Copies, Rating)
VALUES (5, 'A.T.L.', 'Drama', 0.43, 6, 3);
INSERT INTO Movie (ID, Title, Genre, Fee, Copies, Rating)
VALUES (6, 'Crouching Tiger Hidden Dragon', 'Foreign', 0.15, 3, 2);
INSERT INTO Movie (ID, Title, Genre, Fee, Copies, Rating)
VALUES (7, 'Harry Potter', 'Action', 2.34, 5, 5);
INSERT INTO Movie (ID, Title, Genre, Fee, Copies, Rating)
VALUES (8, 'Star Wars', 'Action', 2.50, 1, 3);


INSERT INTO Actor (ID, FirstName, LastName, Gender, Age, Rating)
VALUES (1, 'Sean', 'Pesce', 'M', 25, 4);
INSERT INTO Actor (ID, FirstName, LastName, Gender, Age, Rating)
VALUES (2, 'John', 'Ladt', 'M', 22, 2);
INSERT INTO Actor (ID, FirstName, LastName, Gender, Age, Rating)
VALUES (3, 'Stacy', 'Smith', 'F', 18, 1);
INSERT INTO Actor (ID, FirstName, LastName, Age, Rating)
VALUES (4, 'Richard', 'Papillon', 24, 5);
INSERT INTO Actor (ID, FirstName, LastName, Gender, Age, Rating)
VALUES (5, 'Zhe', 'Lin', 'M', 20, 4);
INSERT INTO Actor (ID, FirstName, LastName, Gender, Age, Rating)
VALUES (6, 'Weichao', 'Zhao', 'M', 20, 4);
INSERT INTO Actor (ID, FirstName, LastName, Gender, Age, Rating)
VALUES (7, 'Will', 'Ferrell', 'M', 45, 3);
INSERT INTO Actor (ID, FirstName, LastName, Gender, Age, Rating)
VALUES (8, 'Glenn', 'Close', 'F', 63, 3);
INSERT INTO Actor (ID, FirstName, LastName, Gender, Age, Rating)
VALUES (9, 'Reese', 'Witherspoon', 'F', 34, 5);
INSERT INTO Actor (ID, FirstName, LastName, Gender, Age, Rating)
VALUES (10, 'Daniel', 'Radcliffe', 'M', 27, 2);
INSERT INTO Actor (ID, FirstName, LastName, Gender, Age, Rating)
VALUES (11, 'Emma', 'Watson', 'F', 26, 4);
INSERT INTO Actor (ID, FirstName, LastName, Gender, Age, Rating)
VALUES (12, 'Rupert', 'Grint', 'M', 26, 2);
INSERT INTO Actor (ID, FirstName, LastName, Gender, Age, Rating)
VALUES (13, 'Ewan', 'McGregor', 'M', 42, 5);
INSERT INTO Actor (ID, FirstName, LastName, Gender, Age, Rating)
VALUES (14, 'Hayden', 'Christiansen', 'M', 30, 1);
INSERT INTO Actor (ID, FirstName, LastName, Gender, Age, Rating)
VALUES (15, 'Mark', 'Hammill', 'M', 67, 4);
INSERT INTO Actor (ID, FirstName, LastName, Gender, Age, Rating)
VALUES (16, 'Natalie', 'Portman', 'F', 33, 5);


INSERT INTO Casted (ActorID, MovieID, Role)
VALUES (2, 1, 'Batman');
INSERT INTO Casted (ActorID, MovieID, Role)
VALUES (2, 2, 'Aragorn');
INSERT INTO Casted (ActorID, MovieID, Role)
VALUES (1, 2, 'Gimli');
INSERT INTO Casted (ActorID, MovieID, Role)
VALUES (3, 1, 'Harley Quinn');
INSERT INTO Casted (ActorID, MovieID, Role)
VALUES (10, 1, 'Penguin');
INSERT INTO Casted (ActorID, MovieID, Role)
VALUES (7, 2, 'Orc');
INSERT INTO Casted (ActorID, MovieID, Role)
VALUES (15, 3, 'Zer0 Cool');
INSERT INTO Casted (ActorID, MovieID, Role)
VALUES (5, 3, 'Agent Ray');
INSERT INTO Casted (ActorID, MovieID, Role)
VALUES (6, 3, 'Hal');
INSERT INTO Casted (ActorID, MovieID, Role)
VALUES (4, 4, 'Hansel');
INSERT INTO Casted (ActorID, MovieID, Role)
VALUES (7, 4, 'Mugatu');
INSERT INTO Casted (ActorID, MovieID, Role)
VALUES (9, 4, 'Katinka');
INSERT INTO Casted (ActorID, MovieID, Role)
VALUES (5, 4, 'Derek Zoolander');
INSERT INTO Casted (ActorID, MovieID, Role)
VALUES (11, 5, 'New New');
INSERT INTO Casted (ActorID, MovieID, Role)
VALUES (13, 5, 'Teddy');
INSERT INTO Casted (ActorID, MovieID, Role)
VALUES (16, 5, 'Star');
INSERT INTO Casted (ActorID, MovieID, Role)
VALUES (2, 5, 'Esquire');
INSERT INTO Casted (ActorID, MovieID, Role)
VALUES (8, 5, 'Waitress');
INSERT INTO Casted (ActorID, MovieID, Role)
VALUES (15, 6, 'Sir Te');
INSERT INTO Casted (ActorID, MovieID, Role)
VALUES (10, 7, 'Harry Potter');
INSERT INTO Casted (ActorID, MovieID, Role)
VALUES (11, 7, 'Hermione Granger');
INSERT INTO Casted (ActorID, MovieID, Role)
VALUES (12, 7, 'Ron Weasley');
INSERT INTO Casted (ActorID, MovieID, Role)
VALUES (3, 7, 'Mermaid');
INSERT INTO Casted (ActorID, MovieID, Role)
VALUES (13, 8, 'Obi Wan Kenobi');
INSERT INTO Casted (ActorID, MovieID, Role)
VALUES (14, 8, 'Anakin Skywalker');
INSERT INTO Casted (ActorID, MovieID, Role)
VALUES (15, 8, 'Luke Skywalker');
INSERT INTO Casted (ActorID, MovieID, Role)
VALUES (8, 8, 'Tatooine Scavenger');
INSERT INTO Casted (ActorID, MovieID, Role)
VALUES (2, 8, 'Jabba The Hutt');
INSERT INTO Casted (ActorID, MovieID, Role)
VALUES (4, 8, 'Greedo');


INSERT INTO Person (ID, LastName, FirstName, Address, City, State, Zip, Phone)
VALUES (1, 'Jones', 'Jim', '5 Dipset St', 'Harlem', 'NY', '11999', '5163332222');
INSERT INTO Person (ID, LastName, FirstName, Address, City, State, Zip, Phone)
VALUES (2, 'Harris', 'Clifford', '4 Dope Ct', 'Atlanta', 'GA', '11709', '4042149567');
INSERT INTO Person (ID, LastName, FirstName, Address, City, State, Zip, Phone)
VALUES (3, 'Taylor', 'Jayceon', '187 Homicide Dr', 'Compton', 'CA', '11900', '3452792751');
INSERT INTO Person (ID, LastName, FirstName, Address, City, State, Zip, Phone)
VALUES (4, 'Ross', 'Rick', '95 Survival Ave', 'Miami', 'FL', '12462', '8365915726');
INSERT INTO Person (ID, LastName, FirstName, Address, City, State, Zip, Phone)
VALUES (5, 'Carter', 'Dwayne', '43 Goon Lane', 'New Orleans', 'LA', '14526', '5046258729');
INSERT INTO Person (ID, LastName, FirstName, Address, City, State, Zip, Phone)
VALUES (6, 'Lamar', 'Kendrick', '12 ADHD Ave', 'Compton', 'CA', '11900', '3452627745');
INSERT INTO Person (ID, LastName, FirstName, Address, City, State, Zip, Phone)
VALUES (7, 'Smith', 'Will', '74 Jiggy St', 'Miami', 'FL', '12462', '8368274222');


INSERT INTO Customer (AccountID, Email, AccountType, AccountCreated, CreditCard, Rating)
VALUES (1, 'ballin@dip.com', 'Limited', '2007-02-23', '1234765482345693', 1);
INSERT INTO Customer (AccountID, Email, AccountType, AccountCreated, CreditCard, Rating)
VALUES (3, 'blooded@blackwallst.com', 'Unlimited+', '2005-07-02', '8293728304927123', 4);
INSERT INTO Customer (AccountID, Email, AccountType, AccountCreated, CreditCard, Rating)
VALUES (7, 'wildwest@mib.org', 'Unlimited', '1999-09-25', '3823740572384561', 3);
INSERT INTO Customer (AccountID, Email, AccountType, AccountCreated, CreditCard, Rating)
VALUES (2, 'psc@grandhustle.net', 'Unlimited++', '1980-09-25', '2647526019092345', 5);


INSERT INTO Employee (ID, SSN, StartDate, HourlyRate)
VALUES (4, '823825724', '2006-11-11', 21.23);
INSERT INTO Employee (ID, SSN, StartDate, HourlyRate)
VALUES (5, '134163028', '1987-09-27', 26.64);
INSERT INTO Employee (ID, SSN, StartDate, HourlyRate)
VALUES (6, '134163028', '2010-04-16', 17.76);


INSERT INTO Rented (OrderID, CustomerID, MovieID, EmployeeID, OrderDate, LoanStatus)
VALUES (1, 2, 2, 4, '2009-01-28 06:15:26', 'Expired');
INSERT INTO Rented (OrderID, CustomerID, MovieID, EmployeeID, OrderDate, LoanStatus)
VALUES (2, 2, 6, 6, '2010-05-20 12:56:24', 'Expired');
INSERT INTO Rented (OrderID, CustomerID, MovieID, EmployeeID, OrderDate, LoanStatus)
VALUES (3, 2, 3, 4, '2013-10-05 03:20:10', 'Expired');
INSERT INTO Rented (OrderID, CustomerID, MovieID, EmployeeID, OrderDate, LoanStatus)
VALUES (4, 2, 4, 5, '2017-02-08 22:03:01', 'Active');
INSERT INTO Rented (OrderID, CustomerID, MovieID, EmployeeID, OrderDate, LoanStatus)
VALUES (5, 1, 6, 6, '2006-11-01 10:26:42', 'Expired');
INSERT INTO Rented (OrderID, CustomerID, MovieID, EmployeeID, OrderDate, LoanStatus)
VALUES (6, 3, 8, 4, '2012-04-14 09:36:12', 'Expired');
INSERT INTO Rented (OrderID, CustomerID, MovieID, EmployeeID, OrderDate, LoanStatus)
VALUES (7, 3, 7, 4, '2014-01-05 17:57:32', 'Expired');
INSERT INTO Rented (OrderID, CustomerID, MovieID, EmployeeID, OrderDate, LoanStatus)
VALUES (8, 3, 1, 5, '2015-12-30 20:46:11', 'Expired');
INSERT INTO Rented (OrderID, CustomerID, MovieID, EmployeeID, OrderDate, LoanStatus)
VALUES (9, 7, 8, 6, '2002-05-12 01:59:13', 'Expired');
INSERT INTO Rented (OrderID, CustomerID, MovieID, EmployeeID, OrderDate, LoanStatus)
VALUES (10, 7, 5, 5, '2017-02-07 05:45:23', 'Active');


INSERT INTO Queued (CustomerID, MovieID, DateAdded)
VALUES (1, 1, '2015-01-28 16:03:57');
INSERT INTO Queued (CustomerID, MovieID, DateAdded)
VALUES (1, 8, '2011-11-02 11:24:34');
INSERT INTO Queued (CustomerID, MovieID, DateAdded)
VALUES (1, 7, '2012-07-16 07:32:05');
INSERT INTO Queued (CustomerID, MovieID, DateAdded)
VALUES (1, 3, '2014-09-28 23:14:45');
INSERT INTO Queued (CustomerID, MovieID, DateAdded)
VALUES (3, 2, '2016-04-17 02:10:05');
INSERT INTO Queued (CustomerID, MovieID, DateAdded)
VALUES (7, 3, '2009-10-10 08:39:26');
INSERT INTO Queued (CustomerID, MovieID, DateAdded)
VALUES (7, 2, '2014-06-08 13:03:48');

