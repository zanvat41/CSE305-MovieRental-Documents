# Zhe Lin 109369879
# Sean Pesce 107102508
# Weichao Zhao 109957656
#
# CSE305 Database Project Part 3
# Database User Creation Statement Compilation

# This file can be copied and pasted directly into mysql to create the users from the demo data and grant them the correct privileges.

# To grant execute permissions:
# GRANT EXECUTE ON PROCEDURE cse305db.procedure TO 'user'@'localhost';

# Employee database usernames are first initial and last name
# Employee database passwords are last initial and first name

# David Warren (Manager)
CREATE USER 'dwarren'@'localhost' IDENTIFIED BY 'wdavid';

GRANT EXECUTE ON PROCEDURE cse305db.AddMovie TO 'dwarren'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305db.EditMovie TO 'dwarren'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305db.DeleteMovie TO 'dwarren'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305db.AddActor TO 'dwarren'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305db.EditActor TO 'dwarren'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305db.DeleteActor TO 'dwarren'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305db.AddRole TO 'dwarren'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305db.EditRole TO 'dwarren'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305db.DeleteRole TO 'dwarren'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305db.AddEmployee TO 'dwarren'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305db.AddManager TO 'dwarren'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305db.AddCustomerRep TO 'dwarren'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305db.EditEmployee TO 'dwarren'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305db.DeleteEmployee TO 'dwarren'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305db.ViewSales TO 'dwarren'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305db.RentalsByMovie TO 'dwarren'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305db.RentalsByGenre TO 'dwarren'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305db.RentalsByCustomer TO 'dwarren'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305db.MostTransactions TO 'dwarren'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305db.ActiveCustomers TO 'dwarren'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305db.PopularMovies TO 'dwarren'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305db.AddCustomer TO 'dwarren'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305db.EditCustomer TO 'dwarren'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305db.DeleteCustomer TO 'dwarren'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305db.CreateOrder TO 'dwarren'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305db.EditOrder TO 'dwarren'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305db.DeleteOrder TO 'dwarren'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305db.CreateAccount TO 'dwarren'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305db.EditAccount TO 'dwarren'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305db.DeleteAccount TO 'dwarren'@'localhost';


# David Smith (Customer Representative)
CREATE USER 'dsmith'@'localhost' IDENTIFIED BY 'sdavid';

GRANT EXECUTE ON PROCEDURE cse305db.AddCustomer TO 'dsmith'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305db.EditCustomer TO 'dsmith'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305db.DeleteCustomer TO 'dsmith'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305db.CreateOrder TO 'dsmith'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305db.EditOrder TO 'dsmith'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305db.DeleteOrder TO 'dsmith'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305db.CreateAccount TO 'dsmith'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305db.EditAccount TO 'dsmith'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305db.DeleteAccount TO 'dsmith'@'localhost';


