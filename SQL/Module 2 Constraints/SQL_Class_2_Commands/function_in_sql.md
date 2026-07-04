# 📘 Functions in SQL — Complete Guide from Basics

---

## 🔰 What is a Function in SQL?

A **function** in SQL is a **reusable block of code** that:
- Takes **input** (called parameters/arguments)
- Performs some **logic/calculation**
- **Returns** a single value as output

> Think of it like a **calculator** — you give it numbers, it gives back a result.

---

## 🗂️ Types of Functions in SQL

```
SQL Functions
│
├── 1. Built-in Functions (Pre-defined by SQL)
│   ├── Aggregate Functions     → SUM, COUNT, AVG, MIN, MAX
│   ├── String Functions        → UPPER, LOWER, LENGTH, CONCAT, TRIM
│   ├── Numeric Functions       → ROUND, FLOOR, CEIL, ABS, MOD
│   └── Date/Time Functions     → NOW, CURDATE, DATEDIFF, YEAR, MONTH
│
└── 2. User-Defined Functions (Created by YOU)
    ├── Scalar Function         → Returns a single value
    └── Table-Valued Function   → Returns a table (advanced)
```

---

## 📌 PART 1: Built-in Functions

### 1️⃣ Aggregate Functions
> These functions work on **multiple rows** and return a **single result**.

We'll use the `sales` table you already have:

| sale_id | salesperson | product    | quantity | price_per_unit | sale_date  |
|---------|-------------|------------|----------|----------------|------------|
| 1       | Alice       | Laptop     | 5        | 1000.00        | 2024-05-01 |
| 2       | Bob         | Smartphone | 10       | 600.00         | 2024-05-02 |
| 3       | Alice       | Tablet     | 7        | 300.00         | 2024-05-03 |
| 4       | Charlie     | Smartwatch | 6        | 200.00         | 2024-05-04 |
| 5       | Bob         | Laptop     | 3        | 1000.00        | 2024-05-05 |
| 6       | Alice       | Smartphone | 8        | 600.00         | 2024-05-06 |

```sql
-- COUNT() → Count total number of rows
SELECT COUNT(*) AS total_sales FROM sales;
-- Result: 6

-- SUM() → Add all values in a column
SELECT SUM(quantity) AS total_quantity FROM sales;
-- Result: 39

-- AVG() → Find the average value
SELECT AVG(price_per_unit) AS avg_price FROM sales;
-- Result: 616.67

-- MAX() → Find the maximum value
SELECT MAX(price_per_unit) AS highest_price FROM sales;
-- Result: 1000.00

-- MIN() → Find the minimum value
SELECT MIN(price_per_unit) AS lowest_price FROM sales;
-- Result: 200.00

-- Combining multiple aggregate functions
SELECT 
    COUNT(*)              AS total_records,
    SUM(quantity)         AS total_units_sold,
    AVG(price_per_unit)   AS avg_price,
    MAX(price_per_unit)   AS max_price,
    MIN(price_per_unit)   AS min_price
FROM sales;
```

---

### 2️⃣ String Functions
> These functions work on **text/string** values.

```sql
-- Setup a sample table
CREATE TABLE students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name  VARCHAR(50),
    email      VARCHAR(100)
);

INSERT INTO students (first_name, last_name, email) VALUES
('alice',   'johnson', '  alice@gmail.com  '),
('BOB',     'SMITH',   'BOB@yahoo.com'),
('Charlie', 'Brown',   'charlie@outlook.com');
```

```sql
-- UPPER() → Convert text to UPPERCASE
SELECT UPPER(first_name) AS upper_name FROM students;
-- alice → ALICE,  BOB → BOB,  Charlie → CHARLIE

-- LOWER() → Convert text to lowercase
SELECT LOWER(first_name) AS lower_name FROM students;
-- alice → alice,  BOB → bob,  Charlie → charlie

-- LENGTH() → Get the number of characters in a string
SELECT first_name, LENGTH(first_name) AS name_length FROM students;
-- alice=5, BOB=3, Charlie=7

-- CONCAT() → Join two or more strings together
SELECT CONCAT(first_name, ' ', last_name) AS full_name FROM students;
-- alice johnson, BOB SMITH, Charlie Brown

-- TRIM() → Remove leading and trailing spaces
SELECT TRIM(email) AS clean_email FROM students;
-- '  alice@gmail.com  ' → 'alice@gmail.com'

-- SUBSTRING() → Extract part of a string
-- SUBSTRING(column, start_position, length)
SELECT SUBSTRING(email, 1, 5) AS email_start FROM students;
-- alice, BOB@y, charl

-- REPLACE() → Replace part of a string
SELECT REPLACE(email, '@gmail.com', '@company.com') AS new_email FROM students;

-- REVERSE() → Reverse a string
SELECT REVERSE(first_name) AS reversed_name FROM students;
-- alice → ecila

-- INSTR() → Find the position of a character/word
SELECT first_name, INSTR(email, '@') AS at_position FROM students;
```

---

### 3️⃣ Numeric Functions
> These functions perform **mathematical operations**.

```sql
-- ROUND() → Round a number to given decimal places
SELECT ROUND(3.14159, 2);     -- Result: 3.14
SELECT ROUND(3.567, 1);       -- Result: 3.6
SELECT ROUND(avg_price, 0)    -- Round to whole number
FROM (SELECT AVG(price_per_unit) AS avg_price FROM sales) t;

-- CEIL() → Round UP to nearest whole number
SELECT CEIL(4.1);    -- Result: 5
SELECT CEIL(4.9);    -- Result: 5
SELECT CEIL(-4.5);   -- Result: -4

-- FLOOR() → Round DOWN to nearest whole number
SELECT FLOOR(4.9);   -- Result: 4
SELECT FLOOR(4.1);   -- Result: 4
SELECT FLOOR(-4.5);  -- Result: -5

-- ABS() → Return absolute (positive) value
SELECT ABS(-150);    -- Result: 150
SELECT ABS(150);     -- Result: 150

-- MOD() → Return the remainder after division
SELECT MOD(10, 3);   -- Result: 1  (10 / 3 = 3 remainder 1)
SELECT MOD(15, 5);   -- Result: 0  (15 / 5 = 3 remainder 0)

-- POWER() → Raise a number to a power
SELECT POWER(2, 10); -- Result: 1024  (2^10)

-- SQRT() → Square root
SELECT SQRT(144);    -- Result: 12

-- Practical example: Calculate total revenue for each sale
SELECT 
    salesperson,
    product,
    quantity,
    price_per_unit,
    ROUND(quantity * price_per_unit, 2) AS total_revenue
FROM sales;
```

---

### 4️⃣ Date/Time Functions
> These functions work with **dates and times**.

```sql
-- NOW() → Returns current date and time
SELECT NOW();                        -- 2024-05-10 14:30:00

-- CURDATE() → Returns current date only
SELECT CURDATE();                    -- 2024-05-10

-- CURTIME() → Returns current time only
SELECT CURTIME();                    -- 14:30:00

-- YEAR() → Extract the year from a date
SELECT sale_id, sale_date, YEAR(sale_date) AS sale_year FROM sales;

-- MONTH() → Extract the month from a date
SELECT sale_id, sale_date, MONTH(sale_date) AS sale_month FROM sales;

-- DAY() → Extract the day from a date
SELECT sale_id, sale_date, DAY(sale_date) AS sale_day FROM sales;

-- DATEDIFF() → Find the difference (in days) between two dates
SELECT DATEDIFF('2024-12-31', '2024-01-01') AS days_remaining;
-- Result: 365

SELECT sale_id, sale_date,
       DATEDIFF(CURDATE(), sale_date) AS days_since_sale
FROM sales;

-- DATE_ADD() → Add days/months/years to a date
SELECT DATE_ADD('2024-05-01', INTERVAL 30 DAY);    -- 2024-05-31
SELECT DATE_ADD('2024-05-01', INTERVAL 2 MONTH);   -- 2024-07-01
SELECT DATE_ADD('2024-05-01', INTERVAL 1 YEAR);    -- 2025-05-01

-- DATE_FORMAT() → Format a date as a readable string
SELECT DATE_FORMAT(sale_date, '%d-%m-%Y') AS formatted_date FROM sales;
-- 01-05-2024, 02-05-2024, ...

SELECT DATE_FORMAT(sale_date, '%M %d, %Y') AS readable_date FROM sales;
-- May 01, 2024, May 02, 2024, ...
```

---

## 📌 PART 2: User-Defined Functions (UDF)

> A **User-Defined Function** is a function that **YOU write** for your own custom logic.

### ✅ Syntax Structure

```sql
DELIMITER $$

CREATE FUNCTION function_name(parameter1 datatype, parameter2 datatype, ...)
RETURNS return_datatype
DETERMINISTIC
BEGIN
    -- Your logic here
    DECLARE variable_name datatype;
    
    -- SQL statements
    
    RETURN variable_name;
END $$

DELIMITER ;
```

### 🔑 Key Words Explained:

| Keyword        | Meaning                                                              |
|----------------|----------------------------------------------------------------------|
| `DELIMITER $$` | Change the statement terminator so `;` inside the function doesn't end it prematurely |
| `CREATE FUNCTION` | Start creating a new function                                   |
| `RETURNS`      | Declare what type of value the function will return                  |
| `DETERMINISTIC`| Same inputs always give same output (required for most functions)    |
| `BEGIN...END`  | The body of the function                                             |
| `DECLARE`      | Create a local variable inside the function                          |
| `RETURN`       | The value to give back as output                                     |

---

### 🧪 Example 1: Calculate Total Revenue for a Salesperson

This is the corrected version of the function already in your SQL file:

```sql
DELIMITER $$

CREATE FUNCTION calculate_total_revenue(salesperson_name VARCHAR(100)) 
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE total_revenue DECIMAL(10, 2);
    
    -- Calculate: quantity × price_per_unit for each sale, then sum them all
    SELECT SUM(quantity * price_per_unit) INTO total_revenue
    FROM sales
    WHERE salesperson = salesperson_name;
    
    RETURN total_revenue;
END $$

DELIMITER ;

-- ✅ How to CALL/USE the function:
SELECT calculate_total_revenue('Alice') AS alice_revenue;
-- Result: (5×1000) + (7×300) + (8×600) = 5000 + 2100 + 4800 = 11900.00

-- Use it on all salespersons at once:
SELECT 
    DISTINCT salesperson,
    calculate_total_revenue(salesperson) AS total_revenue
FROM sales
ORDER BY total_revenue DESC;
```

---

### 🧪 Example 2: Check if a Number is Even or Odd

```sql
DELIMITER $$

CREATE FUNCTION check_even_odd(num INT)
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(10);
    
    IF MOD(num, 2) = 0 THEN
        SET result = 'Even';
    ELSE
        SET result = 'Odd';
    END IF;
    
    RETURN result;
END $$

DELIMITER ;

-- How to call it:
SELECT check_even_odd(4);   -- Result: Even
SELECT check_even_odd(7);   -- Result: Odd
SELECT check_even_odd(100); -- Result: Even
```

---

### 🧪 Example 3: Calculate Discount Price

```sql
DELIMITER $$

CREATE FUNCTION apply_discount(original_price DECIMAL(10,2), discount_percent DECIMAL(5,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE discounted_price DECIMAL(10,2);
    
    SET discounted_price = original_price - (original_price * discount_percent / 100);
    
    RETURN ROUND(discounted_price, 2);
END $$

DELIMITER ;

-- How to call it:
SELECT apply_discount(1000.00, 10);   -- Result: 900.00  (10% off ₹1000)
SELECT apply_discount(599.99, 20);    -- Result: 479.99  (20% off ₹599.99)

-- Use with the sales table:
SELECT 
    salesperson,
    product,
    price_per_unit AS original_price,
    apply_discount(price_per_unit, 15) AS price_after_15_percent_off
FROM sales;
```

---

### 🧪 Example 4: Classify Salary Level

```sql
DELIMITER $$

CREATE FUNCTION salary_grade(salary_amount DECIMAL(10,2))
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE grade VARCHAR(20);
    
    IF salary_amount >= 50000 THEN
        SET grade = 'High Earner';
    ELSEIF salary_amount >= 20000 THEN
        SET grade = 'Mid Earner';
    ELSE
        SET grade = 'Entry Level';
    END IF;
    
    RETURN grade;
END $$

DELIMITER ;

-- How to call it using the employee_new table:
SELECT 
    name, 
    salary,
    salary_grade(salary) AS salary_category
FROM employee_new;
```

---

## 📌 PART 3: Managing Functions

```sql
-- View all functions in current database
SHOW FUNCTION STATUS WHERE Db = 'gds_de_v1';

-- View the code of an existing function
SHOW CREATE FUNCTION calculate_total_revenue;

-- Drop (delete) a function
DROP FUNCTION IF EXISTS calculate_total_revenue;

-- Drop and recreate (safe way)
DROP FUNCTION IF EXISTS calculate_total_revenue;
-- Then run CREATE FUNCTION again...
```

---

## 📌 PART 4: Functions vs Procedures — Quick Comparison

| Feature             | Function                        | Stored Procedure                    |
|---------------------|---------------------------------|-------------------------------------|
| Returns value?      | ✅ Yes — always returns a value  | ❌ Not required (uses OUT params)    |
| Used in SELECT?     | ✅ Yes                           | ❌ No                               |
| Can have DML?       | ⚠️ Limited                       | ✅ Yes (INSERT/UPDATE/DELETE)        |
| Called with         | `SELECT func_name()`            | `CALL proc_name()`                  |
| Purpose             | Calculations / transformations  | Business logic, multi-step tasks    |

---

## 🏁 Summary — What You Learned

```
Built-in Functions:
  ✅ Aggregate  → COUNT, SUM, AVG, MIN, MAX
  ✅ String     → UPPER, LOWER, CONCAT, TRIM, LENGTH, SUBSTRING
  ✅ Numeric    → ROUND, FLOOR, CEIL, ABS, MOD, POWER
  ✅ Date/Time  → NOW, CURDATE, YEAR, MONTH, DATEDIFF, DATE_FORMAT

User-Defined Functions:
  ✅ CREATE FUNCTION syntax
  ✅ DECLARE variables
  ✅ IF / ELSEIF / ELSE logic
  ✅ RETURN value
  ✅ Calling functions in SELECT
  ✅ DROP FUNCTION
```

---

> 💡 **Pro Tip**: Always use `DROP FUNCTION IF EXISTS function_name;` before recreating a function to avoid errors!
