Create database gds_de_v1;

use gds_de_v1;

create table if not exists employee(
    id int,
    name VARCHAR(50),
    address VARCHAR(50),
    city VARCHAR(50)
);

insert into employee values(1, 'Shashank', 'RJPM', 'Lucknow');

select * from employee;

--- add new column named DOB in the TABLE
alter table table_name add column column_name column_type;
alter table employee add DOB date; -- adding the new column date of birth 

select * from employee;


--- modify existing column in a TABLE or change datatype of name column or increase lenght of name column
alter table table_name modify column column_name column_type;
alter table employee modify column name varchar(100);

--- delete existing column from given TABLE or remove city column from employee table
alter table table_name drop column column_name --- Dropping the column from the table -- we can drop multiple columns at a time by using comma separation
alter table employee drop column city;

select * from employee;


--- rename the column name to full_name
alter table table_name rename column old_coulmn to new_name;
alter table employee rename column name to full_name;

create table if not exists employee_new(
    id int,
    name VARCHAR(50),
    age int,
    hiring_date date,
    salary int,
    city varchar(50)
);

insert into employee_new values(1,'Shashank', 24, '2021-08-10', 10000, 'Lucknow');

insert into employee_new values(2,'Rahul', 25, '2021-08-10', 20000, 'Khajuraho');

insert into employee_new values(3,'Sunny', 22, '2021-08-11', 11000, 'Banaglore');

insert into employee_new values(5,'Amit', 25, '2021-08-11', 12000, 'Noida');

insert into employee_new values(6,'Puneet', 26, '2021-08-12', 50000, 'Gurgaon');

--- add unique integrity constraint on id COLUMN

alter table employee_new add constraint id_unique UNIQUE(id);

insert into employee_new values(1,'XYZ', 25, '2021-08-10', 50000, 'Gurgaon');

--- drop constraint from existing TABLE
alter table employee_new drop constraint id_unique;

insert into employee_new values(1,'XYZ', 25, '2021-08-10', 50000, 'Gurgaon');

--- create table with Primary_Key

Create table guests
(
    id int, 
    name varchar(50), 
    age int,
    ---Primary Key (id) 
    constraint pk Primary Key (id) -- Define the primary key constraint
);

insert into guests values(1,'Shashank',29);

--- Try to insert duplicate value for primary key COLUMN
insert into guests values(1,'Rahul',28);

--- Try to insert null value for primary key COLUMN
insert into guests values(null,'Rahul',28);

--- To check difference between Primary Key and Unique
alter table guests add constraint age_unq UNIQUE(age); 

select * from guests;

insert into guests values(2,'Rahul',28);
insert into guests values(3,'Amit',28);
insert into guests values(3,'Amit',null);

select * from guests;

insert into guests values(4,'Charan',null);
insert into guests values(5,'Deepak',null);


--- create tables for Foreign Key demo
create table customer
(
    cust_id int,
    name VARCHAR(50), 
    age int,
    constraint pk Primary Key (cust_id) -- Define the primary key constraint 
);

create table orders
(
    order_id int,
    amount int,
    customer_id int,
    constraint pk Primary Key (order_id),
    constraint fk Foreign Key (customer_id) REFERENCES customer(cust_id) -- Define the foreign key constraint 
);

insert into customer values(1,"Shashank",29);
insert into customer values(2,"Rahul",30);

select * from customer;

insert into orders values(1001, 20, 1);
insert into orders values(1002, 30, 2);

select * from orders;

--- It will not allow to insert because referncial integrity will violate
insert into orders values(1004, 35, 5);

--- Differen between Drop & Truncate Command

select * from guests;
truncate table guests;

select * from guests;
drop table guests;

--- Operations with Select Command

select * from employee_new;


drop table employee_new;


create table if not exists employee_new(
    id int,
    name VARCHAR(50),
    age int,
    hiring_date date,
    salary int,
    city varchar(50)
);

insert into employee_new values(1,'Shashank', 24, '2021-08-10', 10000, 'Lucknow');
insert into employee_new values(2,'Rahul', 25, '2021-08-10', 20000, 'Khajuraho');
insert into employee_new values(3,'Sunny', 22, '2021-08-11', 11000, 'Bangalore');
insert into employee_new values(5,'Amit', 25, '2021-08-11', 12000, 'Noida');
insert into employee_new values(1,'Puneet', 26, '2021-08-12', 50000, 'Gurgaon');


select * from employee_new;

--- how to count total records
select count(*) from employee_new;


--- alias declaration
select count(*) as total_row_count from employee_new; -- new name to the column using alias operator


--- display all columns in the final result
select * from employee_new;


--- display specific columns in the final result
select name, salary from employee_new;


--- aliases for mutiple columns
select name as employee_name, salary as employee_salary from employee_new;


select * from employee_new;

--- print unique hiring_dates from the employee table when employees joined it
select Distinct(hiring_date) as distinct_hiring_dates from employee_new;


select * from employee_new;

--- How many unique age values in the table??

select  count(distinct(age)) as total_unique_ages from employee_new;

--- Increment salary of each employee by 20% and display final result with new salary
SELECT  id,
        name,
        salary as old_salary, 
        (salary + salary * 0.2) as new_salary
FROM employee_new;


-- Syntax for update command
select * from employee_new;

--- Upadtes will be made for all rows
UPDATE table_name SET column_name in some Condition;
UPDATE employee_new SET age = 20;

select * from employee_new;

--- update the salary of employee after giving 20% increment
UPDATE employee_new SET salary = salary + salary * 0.2;

--- update command for multiple columns
UPDATE employee_new SET salary = salary + salary * 0.2, age = 25;

select * from employee_new;


--- How to filter data using WHERE Clauses
select * from employee_new where hiring_date = '2021-08-10';


select * from employee_new;

--- Update the salary of employees who joined the company on 2021-08-10 to 80000
update employee_new SET salary = 80000 where hiring_date = '2021-08-10';

select * from employee_new;


--- how to delete specific records from table using delete command
--- delete records of those employess who joined company on 2021-08-10

delete from employee_new where hiring_date = '2021-08-10';


select * from employee_new;

--- How to apply auto increment
create table auto_inc_exmp
(
  id int auto_increment,
  -- id int Generated always as Identity, # in postgessql
  name varchar(20),
  primary key (id)
);

insert into auto_inc_exmp(name) values('Shashank');
insert into auto_inc_exmp(name) values('Rahul');
insert into auto_inc_exmp(id,name) values(5,'Amit'); -- For this we will get an syntx error : we cannot provide the value for auto increment column 
insert into auto_inc_exmp(name) values('Nikhil');

select * from auto_inc_exmp;

--- Use of limit 
select * from employee_new;
select * from employee_new limit 2;


-- sorting data in mysql by using 'Order By'
select * from employee_new;

-- arrage data in ascending order
select * from employee_new order by name;


-- arrage data in descending order
select * from employee_new order by name desc;

-- display employee data in desc order of salary and if salaries are same for more than one employees
-- arrange their data in ascedinding order of name

select * from employee_new order by salary desc, name asc;

-- when we ignore multilevel ordering
select * from employee_new order by salary desc;

-- Write a query to find the employee who is getting maximum salary?
select * from employee_new order by salary desc limit 1;


-- Write a query to find the employee who is getting minium salary?
select * from employee_new order by salary limit 1;


-- Write a query to find the employee who is getting minium salary?
select * from employee_new order by salary limit 1;

-- Conditional Operators ->    < , > , <= , >= 
-- Logical Operator -> AND, OR, NOT

select * from employee_new;

-- list all employees who are getting salary more than 20000
select * from employee_new where salary>20000;

-- list all employees who are getting salary more than or equal to 20000
select * from employee_new where salary>=20000;

-- list all employees who are getting less than 20000
select * from employee_new where salary<20000;

-- list all employees who are getting salary less than or equal to 20000
select * from employee_new where salary<=20000;


-- filter the record where age of employees is equal to 20
select * from employee_new where age=20;

-- filter the record where age of employees is not equal to 20
-- we can use != or we can use <>
select * from employee_new where age != 20;
select * from employee_new where age <> 20;

-- find those employees who joined the company on 2021-08-11 and their salary is less than 11500
select * from employee_new where hiring_date = '2021-08-11' and salary<11500;

-- find those employees who joined the company after 2021-08-11 or  their salary is less than 20000
select * from employee_new where hiring_date > '2021-08-11' or salary<20000;

-- how to use Between operation in where clause
-- get all employees data who joined the company between hiring_date 2021-08-05 to 2021-08-11
select * from employee_new where hiring_date between '2021-08-05' and '2021-08-11';

-- get all employees data who are getting salary in the range of 10000 to 28000
select * from employee_new where salary between 10000 and 28000;

-- how to use LIKE operation in where clause
-- % -> Zero, one or more than one characters
-- _ -> only one character

-- get all those employees whose name starts with 'S'
select * from employee_new where name like 'S%';

-- get all those employees whose name starts with 'Sh'
select * from employee_new where name like 'Sh%';

-- get all those employees whose name ends with 'l'
select * from employee_new where name like '%l';

-- get all those employees whose name starts with 'S' and ends with 'k'
select * from employee_new where name like 'S%k';

-- Get all those employees whose name will have exact 5 characters
select * from employee_new where name like '_____';

-- Return all those employees whose name contains atleast 5 characters
select * from employee_new where name like '%_____';
select * from employee_new where name like '_____%';
select * from employee_new where name like '%_____%';


-- Example for Functions in MySQL

CREATE TABLE sales (
    sale_id INT AUTO_INCREMENT PRIMARY KEY,
    salesperson VARCHAR(100),
    product VARCHAR(100),
    quantity INT,
    price_per_unit DECIMAL(10, 2),
    sale_date DATE
);

INSERT INTO sales (salesperson, product, quantity, price_per_unit, sale_date) VALUES
('Alice', 'Laptop', 5, 1000.00, '2024-05-01'),
('Bob', 'Smartphone', 10, 600.00, '2024-05-02'),
('Alice', 'Tablet', 7, 300.00, '2024-05-03'),
('Charlie', 'Smartwatch', 6, 200.00, '2024-05-04'),
('Bob', 'Laptop', 3, 1000.00, '2024-05-05'),
('Alice', 'Smartphone', 8, 600.00, '2024-05-06');

-- Create function

DELIMITER $$
CREATE function calculate_revenue(sales_person_name VARCHAR(100))
returns decimal (10,2)
DETERMINISTIC
BEGIN
DECLARE total_revenue DECIMAL(10,2);
SELECT SUM(quantity * price) INTO total_revenue
FROM sales 
where sales_person = salesperson_name;
RETURN total_revenue;


END $$
DELIMITER ;





DELIMITER $$

CREATE FUNCTION calculate_total_revenue(salesperson_name VARCHAR(100)) 
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE total_revenue DECIMAL(10, 2);
    
    SELECT SUM(quantity * price_per_unit) INTO total_revenue
    FROM sales
    WHERE salesperson = salesperson_name;
    
    RETURN total_revenue;
END $$

DELIMITER ;

SELECT 
    DISTINCT salesperson, 
    calculate_total_revenue(salesperson) AS total_revenue
FROM 
    sales;