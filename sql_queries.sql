--fetching first rows
SELECT TOP 1 * FROM Customers;

--sql - alter
ALTER TABLE orders ADD discount VARCHAR(10);

--sql - alter table: modify column
ALTER TABLE orders
ALTER COLUMN discount DECIMAL(18,2);

--sql - sql alter table: drop
ALTER TABLE orders
DROP COLUMN discount;

--sql - distinct
SELECT DISTINCT customer
FROM orders
WHERE day_of_order BETWEEN '7/31/08' AND '9/1/08';

--sql - subqueries
SELECT MAX(day_of_order)
FROM orders

SELECT *
FROM orders
WHERE day_of_order = (SELECT MAX(day_of_order) FROM orders)

--sql - join
SELECT *
FROM orders
JOIN inventory
ON orders.product = inventory.product;

SELECT orders.customer,
orders.day_of_order,
orders.product,
orders.quantity as number_ordered,
inventory.quantity as number_instock,
inventory.price
FROM orders
JOIN inventory
ON orders.product = inventory.product

--sql - right join
--RIGHT JOIN is another method of JOIN we can use to join together tables, but its behavior is slightly different. We still need to join the tables together based on a conditional statement. The difference is that instead of returning ONLY rows where a join occurs, SQL will list EVERY row that exists on the right side, (The JOINED table).
--By specifying RIGHT JOIN, we have told SQL to join together the tables even if no matches are found in the conditional statement. All records that exist in the table on the right side of the conditional statement (ON orders.product = inventory.product) will be returned and NULL values will be placed on the left if no matches are found.
SELECT *
FROM orders
RIGHT JOIN inventory
ON orders.product = inventory.product


--sql - left join
--SQL LEFT JOIN works exactly the same way as RIGHT JOIN except that they are opposites. NULL values will appear on the right instead of the left and all rows from the table on the left hand side of the conditional will be returned.
SELECT *
FROM orders
LEFT JOIN inventory
ON orders.product = inventory.product

--sql - in
--SQL IN is an operator used to pull data matching a list of values.
SELECT *
FROM orders
WHERE customer IN ('Gerald Garner','A+Maintenance');

SELECT *
FROM inventory
WHERE product in 
     (SELECT product
     FROM orders
     WHERE customer IN ('Gerald Garner','A+Maintenance'));
	 
--sql - not in
SELECT *
FROM inventory
WHERE product NOT IN 
     (SELECT product
     FROM orders
     WHERE customer IN ('Gerald Garner','A+Maintenance'));
	 
--sql - case
--SQL CASE is a very unique conditional statement providing if/then/else logic for any ordinary SQL command, such as SELECT or UPDATE. It then provides when-then-else functionality (WHEN this condition is met THEN do_this).
SELECT product,
      'Status' = CASE
        WHEN quantity > 0 THEN 'in stock'
        ELSE 'out of stock'
        END
FROM inventory;

--sql - group by
--SQL GROUP BY aggregates (consolidates and calculates) column values into a single record value. GROUP BY requires a list of table columns on which to run the calculations. At first, this behavior will resemble the SELECT DISTINCT
SELECT customer
FROM orders
GROUP BY customer;

SELECT customer, SUM(quantity) AS "Total Items"
FROM orders
GROUP BY customer;

SELECT day_of_order,
  product,
  SUM(quantity) as "Total"
FROM orders
GROUP BY day_of_order,product
ORDER BY day_of_order;

--sql - having
--The SQL HAVING clause is "like a WHERE clause for aggregated data." It's used with conditional statements, just like WHERE, to filter results. One thing to note is that any column name appearing in the HAVING clause must also appear in the GROUP BY clause.
SELECT day_of_order,
  product,
  SUM(quantity) as "Total"
FROM orders
GROUP BY day_of_order,product,quantity
HAVING quantity > 7
ORDER BY day_of_order;

--sql - views
--SQL VIEWS are data objects, and like SQL Tables, they can be queried, updated, and dropped. A SQL VIEW is a virtual table containing columns and rows except that the data contained inside a view is generated dynamically from SQL tables and does not physically exist inside the view itself.
--Views can be queried exactly like any other SQL table.
CREATE VIEW virtualInventory
AS 
SELECT * FROM inventory;

--sql - drop view
--Views can also be removed by using the DROP VIEW command.
DROP VIEW virtualInventory;

--sql - dates
SELECT GETDATE();

--Using a built in function, ISDATE() we can do some testing on date values to see if they meet the formatting requirements.


SELECT 
ISDATE('8/24/08') AS "MM/DD/YY",
ISDATE('2004-12-01') AS "YYYY/MM/DD";
--ISDATE() returns a 1 or a 0 indicating a true or false result. In this case, both formats are acceptable date formats as a 1 value was returned.

--sql - month(), day(), year()
--The Month(), Day() and Year() functions all extract corresponding values from a given date.

--SQL Year():
SELECT YEAR(GETDATE()) as "Year";
SELECT YEAR('8/14/04') as "Year";

--SQL Month():
SELECT MONTH(GETDATE()) as "Month";
SELECT MONTH('8/14/04') as "Month";

--SQL Day():
SELECT DAY(GETDATE()) as "Day";
SELECT DAY('8/14/04') as "Day";

--SQL Delete Commands:
--DELETE - Deletes any number of rows from a data object.
--DROP - Removes table columns, tables, and all data objects SQL applications.
--TRUNCATE - Empties out data without removing the object itself.

DELETE 
FROM orders
WHERE customer = 'A+Maintenance';

--sql - truncate
--SQL TRUNCATE is the fastest way to remove all data from a SQL table, leaving nothing but an empty shell. You might choose to use this command when all the data inside of a table needs to be removed but you'd like the table column definitions to remain intact
TRUNCATE TABLE orders;

--sql - drop
--SQL DROP is another command that removes data from the data store. The DROP command must be performed on SQL objects including databases, tables, table columns, and SQL views. Dropping any of these objects removes them completely from your SQL application and all data contained in any of the data objects dropped are lost forever.

DROP TABLE orders;
DROP DATABASE mydatabase;
DROP VIEW viewname;
DROP INDEX orders.indexname;

-- FOR USE WITH ALTER COMMANDS
DROP COLUMN column_name
DROP FOREIGN KEY (foreign_key_name)

--sql - union
--SQL UNION combines two separate SQL queries into one result set.
--In order to perform a UNION the columns of table 1 must match those of table 2. This rule ensures that the result set is consistent as rows are fetched by SQL.
--The result is a complete listing of every employee from the two tables, perhaps representing a list of employees from two different departments.
SELECT * FROM employees
UNION
SELECT * FROM employees2;

--sql - union all
--UNION ALL selects all rows from each table and combines them into a single table. The difference between UNION and UNION ALL is that UNION ALL will not eliminate duplicate rows. Instead, it just pulls all rows from all tables fitting your query specifics and combines them into a table.
SELECT * FROM employees
UNION ALL
SELECT * FROM employees2;

AVG() -- Returns the average value of a stated column.
COUNT(*) -- Returns a count of the number of rows of table.
SUM() -- Returns the sum of a given column.
Using one of the following functions also returns a numeric value:
GetDate() -- Returns the current date/time.
Current_Timestamp -- Returns the current timestamp.

--SQL Code:
USE mydatabase;

SELECT COUNT(*) AS "Number of Orders"
FROM orders;

SELECT SUM(quantity)AS "Total Number of Items Purchased"
FROM orders;

SELECT AVG(quantity) AS "Average Number of Items Purchased"
FROM orders;

SELECT COUNT(*) AS "Number of Orders",
SUM(quantity)AS "Total Number of Items Purchased",
AVG(quantity)AS "Average Number of Items Purchased"
FROM orders;

