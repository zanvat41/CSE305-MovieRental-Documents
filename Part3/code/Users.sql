# Zhe Lin 109369879
# Sean Pesce 107102508
# Weichao Zhao 109957656
#
# CSE305 Database Project Part 3
# Database User Creation Statement Compilation

# This file can be copied and pasted directly into mysql to create the users from the demo data and grant them the correct privileges.

# To grant execute permissions:
# GRANT EXECUTE ON PROCEDURE cse305db.procedure TO 'user'@'%';

# Employee database usernames are first initial and last name
# Employee database passwords are last initial and first name

# David Warren (Manager)
CREATE USER 'dwarren'@'%' IDENTIFIED BY 'wdavid';

GRANT EXECUTE ON PROCEDURE cse305db.AddMovie TO 'dwarren'@'%';
GRANT EXECUTE ON PROCEDURE cse305db.EditMovie TO 'dwarren'@'%';
GRANT EXECUTE ON PROCEDURE cse305db.DeleteMovie TO 'dwarren'@'%';
GRANT EXECUTE ON PROCEDURE cse305db.AddActor TO 'dwarren'@'%';
GRANT EXECUTE ON PROCEDURE cse305db.EditActor TO 'dwarren'@'%';
GRANT EXECUTE ON PROCEDURE cse305db.DeleteActor TO 'dwarren'@'%';
GRANT EXECUTE ON PROCEDURE cse305db.AddRole TO 'dwarren'@'%';
GRANT EXECUTE ON PROCEDURE cse305db.EditRole TO 'dwarren'@'%';
GRANT EXECUTE ON PROCEDURE cse305db.DeleteRole TO 'dwarren'@'%';
GRANT EXECUTE ON PROCEDURE cse305db.AddEmployee TO 'dwarren'@'%';
GRANT EXECUTE ON PROCEDURE cse305db.AddManager TO 'dwarren'@'%';
GRANT EXECUTE ON PROCEDURE cse305db.AddCustomerRep TO 'dwarren'@'%';
GRANT EXECUTE ON PROCEDURE cse305db.EditEmployee TO 'dwarren'@'%';
GRANT EXECUTE ON PROCEDURE cse305db.DeleteEmployee TO 'dwarren'@'%';
GRANT EXECUTE ON PROCEDURE cse305db.ViewSales TO 'dwarren'@'%';
GRANT EXECUTE ON PROCEDURE cse305db.RentalsByMovie TO 'dwarren'@'%';
GRANT EXECUTE ON PROCEDURE cse305db.RentalsByGenre TO 'dwarren'@'%';
GRANT EXECUTE ON PROCEDURE cse305db.RentalsByCustomer TO 'dwarren'@'%';
GRANT EXECUTE ON PROCEDURE cse305db.MostTransactions TO 'dwarren'@'%';
GRANT EXECUTE ON PROCEDURE cse305db.ActiveCustomers TO 'dwarren'@'%';
GRANT EXECUTE ON PROCEDURE cse305db.PopularMovies TO 'dwarren'@'%';
GRANT EXECUTE ON PROCEDURE cse305db.AddCustomer TO 'dwarren'@'%';
GRANT EXECUTE ON PROCEDURE cse305db.EditCustomer TO 'dwarren'@'%';
GRANT EXECUTE ON PROCEDURE cse305db.DeleteCustomer TO 'dwarren'@'%';
GRANT EXECUTE ON PROCEDURE cse305db.CreateOrder TO 'dwarren'@'%';
GRANT EXECUTE ON PROCEDURE cse305db.EditOrder TO 'dwarren'@'%';
GRANT EXECUTE ON PROCEDURE cse305db.DeleteOrder TO 'dwarren'@'%';
GRANT EXECUTE ON PROCEDURE cse305db.CreateAccount TO 'dwarren'@'%';
GRANT EXECUTE ON PROCEDURE cse305db.EditAccount TO 'dwarren'@'%';
GRANT EXECUTE ON PROCEDURE cse305db.DeleteAccount TO 'dwarren'@'%';


# David Smith (Customer Representative)
CREATE USER 'dsmith'@'%' IDENTIFIED BY 'sdavid';

GRANT EXECUTE ON PROCEDURE cse305db.AddCustomer TO 'dsmith'@'%';
GRANT EXECUTE ON PROCEDURE cse305db.EditCustomer TO 'dsmith'@'%';
GRANT EXECUTE ON PROCEDURE cse305db.DeleteCustomer TO 'dsmith'@'%';
GRANT EXECUTE ON PROCEDURE cse305db.CreateOrder TO 'dsmith'@'%';
GRANT EXECUTE ON PROCEDURE cse305db.EditOrder TO 'dsmith'@'%';
GRANT EXECUTE ON PROCEDURE cse305db.DeleteOrder TO 'dsmith'@'%';
GRANT EXECUTE ON PROCEDURE cse305db.CreateAccount TO 'dsmith'@'%';
GRANT EXECUTE ON PROCEDURE cse305db.EditAccount TO 'dsmith'@'%';
GRANT EXECUTE ON PROCEDURE cse305db.DeleteAccount TO 'dsmith'@'%';


