# Zhe Lin 109369879
# Sean Pesce 107102508
# Weichao Zhao 109957656
#
# CSE305 Database Project Part 3
# Database User Creation Statement Compilation

# This file can be copied and pasted directly into mysql to create the users from the demo data and grant them the correct privileges.

# To grant execute permissions:
# GRANT EXECUTE ON PROCEDURE cse305.procedure TO 'user'@'localhost';

# Employee database usernames are first initial and last name
# Employee database passwords are last initial and first name

# David Warren (Manager)
CREATE USER 'dwarren'@'localhost' IDENTIFIED BY 'wdavid';

GRANT EXECUTE ON PROCEDURE cse305.AddMovie TO 'dwarren'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305.EditMovie TO 'dwarren'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305.DeleteMovie TO 'dwarren'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305.AddActor TO 'dwarren'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305.EditActor TO 'dwarren'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305.DeleteActor TO 'dwarren'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305.AddRole TO 'dwarren'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305.EditRole TO 'dwarren'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305.DeleteRole TO 'dwarren'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305.AddEmployee TO 'dwarren'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305.AddManager TO 'dwarren'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305.AddCustomerRep TO 'dwarren'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305.EditEmployee TO 'dwarren'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305.DeleteEmployee TO 'dwarren'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305.ViewSales TO 'dwarren'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305.RentalsByMovie TO 'dwarren'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305.RentalsByGenre TO 'dwarren'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305.RentalsByCustomer TO 'dwarren'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305.MostTransactions TO 'dwarren'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305.ActiveCustomers TO 'dwarren'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305.PopularMovies TO 'dwarren'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305.AddCustomer TO 'dwarren'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305.EditCustomer TO 'dwarren'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305.DeleteCustomer TO 'dwarren'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305.CreateOrder TO 'dwarren'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305.EditOrder TO 'dwarren'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305.DeleteOrder TO 'dwarren'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305.CreateAccount TO 'dwarren'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305.EditAccount TO 'dwarren'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305.DeleteAccount TO 'dwarren'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305.SearchMovieByTitle TO 'dwarren'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305.SearchMovieByType TO 'dwarren'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305.SearchMovieByGenre TO 'dwarren'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305.SearchMovieByActor TO 'dwarren'@'localhost';


# David Smith (Customer Representative)
CREATE USER 'dsmith'@'localhost' IDENTIFIED BY 'sdavid';

GRANT EXECUTE ON PROCEDURE cse305.AddCustomer TO 'dsmith'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305.EditCustomer TO 'dsmith'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305.DeleteCustomer TO 'dsmith'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305.CreateOrder TO 'dsmith'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305.EditOrder TO 'dsmith'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305.DeleteOrder TO 'dsmith'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305.CreateAccount TO 'dsmith'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305.EditAccount TO 'dsmith'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305.DeleteAccount TO 'dsmith'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305.SearchMovieByTitle TO 'dsmith'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305.SearchMovieByType TO 'dsmith'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305.SearchMovieByGenre TO 'dsmith'@'localhost';
GRANT EXECUTE ON PROCEDURE cse305.SearchMovieByActor TO 'dsmith'@'localhost';


