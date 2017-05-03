# Zhe Lin 109369879
# Sean Pesce 107102508
# Weichao Zhao 109957656
#
# CSE305 Database Project Part 3
# Database User Creation Statement Compilation

# This file can be copied and pasted directly into mysql to create the users from the demo data and grant them the correct privileges.

# To grant execute permissions:
# GRANT EXECUTE ON PROCEDURE cse305.procedure TO 'user'@'%';

# Employee database usernames are first initial and last name
# Employee database passwords are last initial and first name

# David Warren (Manager)
CREATE USER 'dwarren'@'%' IDENTIFIED BY 'wdavid';

GRANT EXECUTE ON PROCEDURE cse305.AddMovie TO 'dwarren'@'%';
GRANT EXECUTE ON PROCEDURE cse305.EditMovie TO 'dwarren'@'%';
GRANT EXECUTE ON PROCEDURE cse305.DeleteMovie TO 'dwarren'@'%';
GRANT EXECUTE ON PROCEDURE cse305.AddActor TO 'dwarren'@'%';
GRANT EXECUTE ON PROCEDURE cse305.EditActor TO 'dwarren'@'%';
GRANT EXECUTE ON PROCEDURE cse305.DeleteActor TO 'dwarren'@'%';
GRANT EXECUTE ON PROCEDURE cse305.AddRole TO 'dwarren'@'%';
GRANT EXECUTE ON PROCEDURE cse305.EditRole TO 'dwarren'@'%';
GRANT EXECUTE ON PROCEDURE cse305.DeleteRole TO 'dwarren'@'%';
GRANT EXECUTE ON PROCEDURE cse305.AddEmployee TO 'dwarren'@'%';
GRANT EXECUTE ON PROCEDURE cse305.AddManager TO 'dwarren'@'%';
GRANT EXECUTE ON PROCEDURE cse305.AddCustomerRep TO 'dwarren'@'%';
GRANT EXECUTE ON PROCEDURE cse305.EditEmployee TO 'dwarren'@'%';
GRANT EXECUTE ON PROCEDURE cse305.DeleteEmployee TO 'dwarren'@'%';
GRANT EXECUTE ON PROCEDURE cse305.ViewSales TO 'dwarren'@'%';
GRANT EXECUTE ON PROCEDURE cse305.RentalsByMovie TO 'dwarren'@'%';
GRANT EXECUTE ON PROCEDURE cse305.RentalsByGenre TO 'dwarren'@'%';
GRANT EXECUTE ON PROCEDURE cse305.RentalsByCustomer TO 'dwarren'@'%';
GRANT EXECUTE ON PROCEDURE cse305.MostTransactions TO 'dwarren'@'%';
GRANT EXECUTE ON PROCEDURE cse305.ActiveCustomers TO 'dwarren'@'%';
GRANT EXECUTE ON PROCEDURE cse305.PopularMovies TO 'dwarren'@'%';
GRANT EXECUTE ON PROCEDURE cse305.AddCustomer TO 'dwarren'@'%';
GRANT EXECUTE ON PROCEDURE cse305.EditCustomer TO 'dwarren'@'%';
GRANT EXECUTE ON PROCEDURE cse305.DeleteCustomer TO 'dwarren'@'%';
GRANT EXECUTE ON PROCEDURE cse305.CreateOrder TO 'dwarren'@'%';
GRANT EXECUTE ON PROCEDURE cse305.EditOrder TO 'dwarren'@'%';
GRANT EXECUTE ON PROCEDURE cse305.DeleteOrder TO 'dwarren'@'%';
GRANT EXECUTE ON PROCEDURE cse305.CreateAccount TO 'dwarren'@'%';
GRANT EXECUTE ON PROCEDURE cse305.EditAccount TO 'dwarren'@'%';
GRANT EXECUTE ON PROCEDURE cse305.DeleteAccount TO 'dwarren'@'%';
GRANT EXECUTE ON PROCEDURE cse305.SearchMovieByTitle TO 'dwarren'@'%';
GRANT EXECUTE ON PROCEDURE cse305.SearchMovieByType TO 'dwarren'@'%';
GRANT EXECUTE ON PROCEDURE cse305.SearchMovieByGenre TO 'dwarren'@'%';
GRANT EXECUTE ON PROCEDURE cse305.SearchMovieByActor TO 'dwarren'@'%';


# David Smith (Customer Representative)
CREATE USER 'dsmith'@'%' IDENTIFIED BY 'sdavid';

GRANT EXECUTE ON PROCEDURE cse305.AddCustomer TO 'dsmith'@'%';
GRANT EXECUTE ON PROCEDURE cse305.EditCustomer TO 'dsmith'@'%';
GRANT EXECUTE ON PROCEDURE cse305.DeleteCustomer TO 'dsmith'@'%';
GRANT EXECUTE ON PROCEDURE cse305.CreateOrder TO 'dsmith'@'%';
GRANT EXECUTE ON PROCEDURE cse305.EditOrder TO 'dsmith'@'%';
GRANT EXECUTE ON PROCEDURE cse305.DeleteOrder TO 'dsmith'@'%';
GRANT EXECUTE ON PROCEDURE cse305.CreateAccount TO 'dsmith'@'%';
GRANT EXECUTE ON PROCEDURE cse305.EditAccount TO 'dsmith'@'%';
GRANT EXECUTE ON PROCEDURE cse305.DeleteAccount TO 'dsmith'@'%';
GRANT EXECUTE ON PROCEDURE cse305.SearchMovieByTitle TO 'dsmith'@'%';
GRANT EXECUTE ON PROCEDURE cse305.SearchMovieByType TO 'dsmith'@'%';
GRANT EXECUTE ON PROCEDURE cse305.SearchMovieByGenre TO 'dsmith'@'%';
GRANT EXECUTE ON PROCEDURE cse305.SearchMovieByActor TO 'dsmith'@'%';


