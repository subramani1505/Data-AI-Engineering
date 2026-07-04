-- How to use IS NULL or IS NOT NULL in the where clause
insert into employee values(10,'Kapil', null, '2021-08-10', 10000, 'Assam');
insert into employee values(11,'Nikhil', 30, '2021-08-10', null, 'Assam');

select * from employee;

-- get all those employees whos age value is null
select * from employee where age is null;

select * from employee;

-- get all those employees whos salary value is not null
select * from employee where salary is not null;


-- Table and Data for Group By
create table orders_data
(
 cust_id int,
 order_id int,
 country varchar(50),
 state varchar(50)
);


insert into orders_data values(1,100,'USA','Seattle');
insert into orders_data values(2,101,'INDIA','UP');
insert into orders_data values(2,103,'INDIA','Bihar');
insert into orders_data values(4,108,'USA','WDC');
insert into orders_data values(5,109,'UK','London');
insert into orders_data values(4,110,'USA','WDC');
insert into orders_data values(3,120,'INDIA','AP');
insert into orders_data values(2,121,'INDIA','Goa');
insert into orders_data values(1,131,'USA','Seattle');
insert into orders_data values(6,142,'USA','Seattle');
insert into orders_data values(7,150,'USA','Seattle');

select * from orders_data;

-- calculate total order placed country wise
select country, count(*) as order_count_by_each_country 
from orders_data 
group by country;

-- Write a query to find the total salary by each age group 
select * from employee;
select age, sum(salary) as total_salary_by_each_age_group 
from employee 
group by age;

-- calculate different aggregated metrices for salary
select age, 
	   sum(salary) as total_salary_by_each_age_group,
       max(salary) as max_salary_by_each_age_group,
       min(salary) as min_salary_by_each_age_group,
       avg(salary) as avg_salary_by_each_age_group,
       count(*) as total_employees_by_each_age_group
from employee group by age;

-- Group by on multiple columns

select
   country,
   state,
   count(*) as state_wise_order
from orders_data
group by country, state;


-- Use of Having Clause
-- Write a query to find the country where only 1 order was placed
select country 
from orders_data 
group by country 
having count(*)=1;

-- Where Clause and Group By Clause --> What should be the proper sequence??
-- Answer -> Where Clause and then Group By 


-- How to use GROUP_CONCAT
-- Query - Write a query to print distinct states present in the dataset for each country?
select country, 
GROUP_CONCAT(state) as states_in_country 
from orders_data 
group by country;

select country, 
GROUP_CONCAT(distinct state) as states_in_country 
from orders_data 
group by country;

select country, 
GROUP_CONCAT(distinct state order by state desc) as states_in_country 
from orders_data 
group by country;

select country, GROUP_CONCAT(distinct state order by state desc separator '<->') as states_in_country 
from orders_data group by country;

--- Group RollUP

CREATE TABLE payment (payment_amount decimal(8,2), 
payment_date date, 
store_id int);
 
INSERT INTO payment
VALUES
(1200.99, '2018-01-18', 1),
(189.23, '2018-02-15', 1),
(33.43, '2018-03-03', 3),
(7382.10, '2019-01-11', 2),
(382.92, '2019-02-18', 1),
(322.34, '2019-03-29', 2),
(2929.14, '2020-01-03', 2),
(499.02, '2020-02-19', 3),
(994.11, '2020-03-14', 1),
(394.93, '2021-01-22', 2),
(3332.23, '2021-02-23', 3),
(9499.49, '2021-03-10', 3),
(3002.43, '2018-02-25', 2),
(100.99, '2019-03-07', 1),
(211.65, '2020-02-02', 1),
(500.73, '2021-01-06', 3);

--- Write a query to calculate total reveue of each shop
--- per year, also display year wise revenue

SELECT
  SUM(payment_amount),
  YEAR(payment_date) AS 'Payment Year',
  store_id AS 'Store'
FROM payment
GROUP BY YEAR(payment_date), store_id WITH ROLLUP
ORDER BY YEAR(payment_date), store_id;

--- Write a query to calculate total revenue per year

SELECT
  SUM(payment_amount),
  YEAR(payment_date) AS 'Payment Year'
FROM payment
GROUP BY YEAR(payment_date)
ORDER BY YEAR(payment_date);

-- Total payment amount
Select
   total_payment
From
(SELECT
  SUM(payment_amount) as total_payment,
  YEAR(payment_date) AS Payment_Year,
  store_id AS Store
FROM payment
GROUP BY YEAR(payment_date), store_id WITH ROLLUP
ORDER BY YEAR(payment_date), store_id) temp 
Where Payment_Year is null and Store is null;

-- Total payment per year
Select
   Payment_Year,
   total_payment
From
(SELECT
  SUM(payment_amount) as total_payment,
  YEAR(payment_date) AS Payment_Year,
  store_id AS Store
FROM payment
GROUP BY YEAR(payment_date), store_id WITH ROLLUP
ORDER BY YEAR(payment_date), store_id) temp 
Where Payment_Year is not null and Store is null;

-- Total payment per year for each shop
Select
   Payment_Year,
   Store,
   total_payment
From
(SELECT
  SUM(payment_amount) as total_payment,
  YEAR(payment_date) AS Payment_Year,
  store_id AS Store
FROM payment
GROUP BY YEAR(payment_date), store_id WITH ROLLUP
ORDER BY YEAR(payment_date), store_id) temp 
Where Payment_Year is not null and Store is not null;

-- Subqueries in SQL
create table employees
(
    id int,
    name varchar(50),
    salary int
);

insert into employees values(1,'Shashank',5000),(2,'Amit',5500),(3,'Rahul',7000),(4,'Rohit',6000),(5,'Nitin',4000),(6,'Sunny',7500);

select * from employees;

-- Write a query to print all those employee records who are getting more salary than 'Rohit'

-- Wrong solution -> select * from employees where salary > 6000; 
select * 
from employees 
where salary > (select salary from employees where name='Rohit');

-- Use of IN and NOT IN
-- Write a query to print all orders which were placed in 'Seattle' or 'Goa'
select * from orders_data;

SELECT * 
FROM orders_data 
WHERE state in ('Seattle', 'Goa');

create table customer_order_data
(
    order_id int,
    cust_id int,
    supplier_id int,
    cust_country varchar(50)
);

insert into customer_order_data values(101,200,300,'USA'),(102,201,301,'INDIA'),(103,202,302,'USA'),(104,203,303,'UK');

create table supplier_data
(
    supplier_id int,
    sup_country varchar(50)
);

insert into supplier_data values(300,'USA'),(303,'UK');

-- write a query to find all customer order data where all coustomers are from same countries 
-- as the suppliers
select * from customer_order_data where cust_country in 
(select distinct sup_country from supplier_data);

-- Another example of Sub-Query
select *
from (select
	   country,
	   count(*) as country_wise_order
	from orders_data
	group by country) result
where country_wise_order=1;

-- Case When in SQL

Select
	*,
    Case 
		when marks>90 then 'A+'
        when marks>=80 and marks<90 then 'A'
        when marks>=70 and marks<80 then 'B+'
        when marks>=60 and marks<70 then 'B'
        else 'C'
	End as grade
From students;

-- Uber SQL Interview questions
create table tree
(
    node int,
    parent int
);

insert into tree values (5,8),(9,8),(4,5),(2,9),(1,5),(3,9),(8,null);

select * from tree;

select node,
       CASE
            when node not in (select distinct parent from tree where parent is not null) then 'LEAF'
            when parent is null then 'ROOT'
            else 'INNER'
       END as node_type
from tree;

-- Examples for join
create table orders
(
    order_id int,
    cust_id int,
    order_dat date, 
    shipper_id int
);

create table customers
(
    cust_id int,
    cust_name varchar(50),
    country varchar(50)
);

create table shippers
(
    ship_id int,
    shipper_name varchar(50)
);

insert into orders values(10308, 2, '2022-09-15', 3);
insert into orders values(10309, 30, '2022-09-16', 1);
insert into orders values(10310, 41, '2022-09-19', 2);

insert into customers values(1, 'Neel', 'India');
insert into customers values(2, 'Nitin', 'USA');
insert into customers values(3, 'Mukesh', 'UK');

insert into shippers values(3,'abc');
insert into shippers values(1,'xyz');

select * from orders;
select * from customers;
select * from shippers;

-- perform inner JOIN
-- get the customer informations for each order order, if value of customer is present in orders TABLE
select 
o.*, c.*
from orders o
inner join customers c on o.cust_id = c.cust_id;

-- Left Join
select 
o.*, c.*
from orders o
left join customers c on o.cust_id = c.cust_id;

-- Right Join
select 
o.*, c.*
from orders o
right join customers c on o.cust_id = c.cust_id;


-- How to join more than 2 datasets?
-- perform inner JOIN
-- get the customer informations for each order order, if value of customer is present in orders TABLE
-- also get the information of shipper name
select 
o.*, c.*, s.*
from orders o
inner join customers c on o.cust_id = c.cust_id
inner join shippers s on o.shipper_id = s.ship_id;

create table employees_full_data
(
    emp_id int,
    name varchar(50),
    mgr_id int
);

insert into employees_full_data values(1, 'Shashank', 3);
insert into employees_full_data values(2, 'Amit', 3);
insert into employees_full_data values(3, 'Rajesh', 4);
insert into employees_full_data values(4, 'Ankit', 6);
insert into employees_full_data values(6, 'Nikhil', null);

select * from employees_full_data;

-- Write a query to print the all manager's name
SELECT distinct manager.name as ManagerName
FROM employees_full_data employee
JOIN employees_full_data manager
ON employee.mgr_id = manager.emp_id


-- Q.) Produce a list of all customers' names who have never bought anything from the brand "Fabulous"

CREATE TABLE sales (
    product_id INTEGER,
    store_id INTEGER,
    customer_id INTEGER,
    promotion_id INTEGER,
    store_sales DECIMAL(10, 2),
    store_cost DECIMAL(10, 2),
    units_sold DECIMAL(10, 2),
    transaction_date DATE
);

CREATE TABLE products (
    product_id INTEGER,
    product_class_id INTEGER,
    brand_name VARCHAR(100),
    product_name VARCHAR(100),
    is_low_fat_flg TINYINT,
    is_recyclable_flg TINYINT,
    gross_weight DECIMAL(10, 2),
    net_weight DECIMAL(10, 2)
);

CREATE TABLE customers (
    customer_id INTEGER,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    state VARCHAR(50),
    birthdate DATE,
    gender VARCHAR(10)
);

INSERT INTO products (product_id, product_class_id, brand_name, product_name, is_low_fat_flg, is_recyclable_flg, gross_weight, net_weight) VALUES
(1, 101, 'Fabulous', 'Product A', 1, 1, 1.0, 0.9),
(2, 102, 'SuperCool', 'Product B', 1, 1, 1.2, 1.0),
(3, 103, 'Fabulous', 'Product C', 1, 1, 1.5, 1.3),
(4, 104, 'MegaBrand', 'Product D', 0, 1, 2.0, 1.8),
(5, 105, 'Fabulous', 'Product E', 1, 0, 2.5, 2.3),
(6, 106, 'EcoLife', 'Product F', 0, 1, 0.8, 0.7);

INSERT INTO sales (product_id, store_id, customer_id, promotion_id, store_sales, store_cost, units_sold, transaction_date) VALUES
(1, 1, 101, 1, 100.00, 50.00, 1, '2024-01-01'),
(2, 1, 102, 2, 200.00, 80.00, 2, '2024-01-02'),
(3, 1, 103, 1, 300.00, 120.00, 3, '2024-01-03'),
(4, 2, 104, 3, 150.00, 60.00, 1, '2024-01-04'),
(5, 3, 105, 4, 250.00, 100.00, 5, '2024-01-05'),
(6, 3, 101, 2, 180.00, 70.00, 3, '2024-01-06'),
(3, 2, 102, 3, 220.00, 90.00, 4, '2024-01-07'),
(4, 2, 103, 2, 320.00, 150.00, 6, '2024-01-08');

INSERT INTO customers (customer_id, first_name, last_name, state, birthdate, gender) VALUES
(101, 'John', 'Doe', 'California', '1990-01-01', 'Male'),
(102, 'Jane', 'Smith', 'Texas', '1985-05-15', 'Female'),
(103, 'Alice', 'Johnson', 'New York', '1992-07-23', 'Female'),
(104, 'Bob', 'Brown', 'Florida', '1988-10-10', 'Male'),
(105, 'Emily', 'Davis', 'Washington', '1995-03-12', 'Female'),
(106, 'Michael', 'Williams', 'Nevada', '1987-08-30', 'Male'),
(107, 'Chris', 'Taylor', 'Oregon', '1993-11-17', 'Male'),
(108, 'Sophia', 'Martinez', 'Arizona', '1990-05-22', 'Female');

SELECT c.first_name, c.last_name
FROM customers c
WHERE c.customer_id NOT IN (
    SELECT DISTINCT s.customer_id
    FROM sales s
    JOIN products p ON s.product_id = p.product_id
    WHERE p.brand_name = 'Fabulous'
);