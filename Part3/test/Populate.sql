# Zhe Lin 109369879
# Sean Pesce 107102508
# Weichao Zhao 109957656
#
# CSE305 Database Project Part 3
# Database Population Statement Compilation

# This file can be copied and pasted directly into mysql to populate a pre-built database with the provided Demo Data.

CALL AddCustomer('Shang', 'Yang', '123 Success Street', 'Stony Brook', 'NY', 11790, 5166328959, 'syang@cs.sunysb.edu', 1234567812345678);
CALL AddCustomer('Victor', 'Du', '456 Fortune Road', 'Stony Brook', 'NY', 11790, 5166324360, 'vicdu@cs.sunysb.edu', 5678123456781234);
CALL AddCustomer('John', 'Smith', '789 Peace Blvd.', 'Los Angeles', 'CA', 93536, 3154434321, 'jsmith@ic.sunysb.edu', 2345678923456789);
CALL AddCustomer('Lewis', 'Philip', '135 Knowledge Lane', 'Stony Brook', 'NY', 11794, 5166668888, 'pml@cs.sunysb.edu', 6789234567892345);

CALL EditCustomer(1, 'ID', 111111111);
CALL EditCustomer(2, 'ID', 222222222);
CALL EditCustomer(3, 'ID', 333333333);
CALL EditCustomer(4, 'ID', 444444444);

CALL CreateAccount(444444444, 'Unlimited+', '2006-10-01');
CALL CreateAccount(222222222, 'Limited', '2006-10-15');

CALL AddEmployee('Customer Rep', 123456789, 'David', 'Smith', '123 College road', 'Stony Brook', 'NY', 11790, 5162152345, '2005-11-01', 60.00);
CALL AddEmployee('Manager', 789123456, 'David', 'Warren', '456 Sunken Street', 'Stony Brook', 'NY', 11794, 6316329987, '2006-02-02', 50.00);

CALL AddMovie('The Godfather', 'Drama', 10000.00, 3);
CALL AddMovie('Shawshank Redemption',  'Drama', 1000.00, 2);
CALL AddMovie('Borat', 'Comedy', 500.00, 1);

CALL EditMovie(1, 'Rating', 5);
CALL EditMovie(2, 'Rating', 4);
CALL EditMovie(3, 'Rating', 3);

CALL AddActor('Al', 'Pacino', 'M', 63, 5);
CALL AddActor('Tim', 'Robbins', 'M', 53, 2);

CALL AddRole(1, 1);
CALL AddRole(1, 3);
CALL AddRole(2, 1);

CALL CreateOrder('2009-11-11 10:00:00', 1, 1, 123456789);
CALL CreateOrder('2009-11-11 18:15:00', 2, 3, 123456789);
CALL CreateOrder('2009-11-12 09:30:00', 1, 3, 123456789);
CALL CreateOrder('2009-11-21 22:22:00', 2, 2, 123456789);

CALL EditOrder(1, 'ReturnDate', '\'2009-11-14 00:00:00\'');


