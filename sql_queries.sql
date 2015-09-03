--SQL Create Database Query:
CREATE DATABASE MyDatabase;

--sql - create a sql table
USE mydatabase;

CREATE TABLE orders
(id INT IDENTITY(1,1) PRIMARY KEY, customer VARCHAR(50), day_of_order DATETIME, product VARCHAR(50), quantity INT);

--sql - insert data into your new table
INSERT INTO orders (customer,day_of_order,product, quantity) VALUES('Tizag','8/1/08','Pen',4);

--sql - queries
SELECT * FROM orders;

--fetching first rows
SELECT TOP 1 * FROM Customers;

SELECT id, customer, day_of_order, product, quantity FROM orders;

SELECT * FROM orders WHERE customer = 'Tizag'

SELECT * FROM orders WHERE  day_of_order > '7/31/08'
--Notice how the date value is formatted inside the conditional statement. We passed a value formatted MM/DD/YY, and we've completely neglected the hours, minutes, and seconds values, yet SQL is intelligent enough to understand this. Therefore, our query is successfully executed.

SELECT * FROM orders WHERE  day_of_order > '7/31/08' AND customer = 'Tizag'

--sql - as
--SQL AS temporarily assigns a table column a new name. This grants the SQL developer the ability to make adjustments to the presentation of query results and allow the developer to label results more accurately without permanently renaming table columns.
SELECT day_of_order AS "Date", customer As "Client", product, quantity FROM orders;

SELECT (5 + 12) AS "5 plus 12 is"

--sql - and / or combination
SELECT * FROM orders WHERE (quantity > 2 AND customer = 'Tizag') OR (quantity > 0 AND customer = 'Gerald Garner')

--sql - between
SELECT * FROM orders WHERE day_of_order BETWEEN '7/20/08' AND '8/05/08';

--sql - order by
--ORDER BY is the SQL command used to sort rows as they are returned from a SELECT query. SQL order by command may be added to the end of any select query and it requires at least one table column to be specified in order for SQL to sort the results.
--The default sort order for ORDER BY is an ascending list, [a - z] for characters or [0 - 9] for numbers. As an alternative to the default sorting for our results, which is ASCENDING (ASC), we can instead tell SQL to order the table columns in a DESCENDING (DESC) fashion [z-a].

SELECT * FROM orders WHERE customer = 'Tizag' ORDER BY day_of_order;

SELECT * FROM orders WHERE customer = 'Tizag' ORDER BY day_of_order DESC

--SQL Order by Multiple columns:
--This query should alphabetize by customer, grouping together orders made by the same customer and then by the purchase date. SQL sorts according to how the column names are listed in the ORDER BY clause.
SELECT * FROM orders ORDER BY customer, day_of_order;

--sql - update
UPDATE orders SET quantity = '6' WHERE id = '1' 

UPDATE orders SET quantity = (quantity + 2) WHERE id = '1'

--sql - update multiple rows
UPDATE orders SET quantity = (quantity + 2)

--sql update multiple values
UPDATE orders SET quantity = '11', Product = 'Hanging Files' WHERE id = '1'

--sql - alter
ALTER TABLE orders ADD discount VARCHAR(10);

--sql - alter table: modify column
ALTER TABLE orders
ALTER COLUMN discount DECIMAL(18,2);

--sql - sql alter table: drop
ALTER TABLE orders DROP COLUMN discount;

--sql - distinct
SELECT DISTINCT customer FROM orders WHERE day_of_order BETWEEN '7/31/08' AND '9/1/08';

--sql - subqueries
SELECT MAX(day_of_order) FROM orders

SELECT * FROM orders WHERE day_of_order = (SELECT MAX(day_of_order) FROM orders)

--sql - join
SELECT * FROM orders JOIN inventory ON orders.product = inventory.product;

SELECT orders.customer, orders.day_of_order, orders.product, 
	orders.quantity as number_ordered, inventory.quantity as number_instock, inventory.price
	FROM orders JOIN inventory ON orders.product = inventory.product

--sql - right join
--RIGHT JOIN is another method of JOIN we can use to join together tables, but its behavior is slightly different. We still need to join the tables together based on a conditional statement. The difference is that instead of returning ONLY rows where a join occurs, SQL will list EVERY row that exists on the right side, (The JOINED table).
--By specifying RIGHT JOIN, we have told SQL to join together the tables even if no matches are found in the conditional statement. All records that exist in the table on the right side of the conditional statement (ON orders.product = inventory.product) will be returned and NULL values will be placed on the left if no matches are found.
SELECT * FROM orders RIGHT JOIN inventory ON orders.product = inventory.product


--sql - left join
--SQL LEFT JOIN works exactly the same way as RIGHT JOIN except that they are opposites. NULL values will appear on the right instead of the left and all rows from the table on the left hand side of the conditional will be returned.
SELECT * FROM orders LEFT JOIN inventory ON orders.product = inventory.product

--sql - in
--SQL IN is an operator used to pull data matching a list of values.
SELECT * FROM orders WHERE customer IN ('Gerald Garner','A+Maintenance');

SELECT * FROM inventory WHERE product in 
     (SELECT product FROM orders WHERE customer IN ('Gerald Garner','A+Maintenance'));
	 
--sql - not in
SELECT * FROM inventory WHERE product NOT IN 
     (SELECT product FROM orders WHERE customer IN ('Gerald Garner','A+Maintenance'));
	 
--sql - case
--SQL CASE is a very unique conditional statement providing if/then/else logic for any ordinary SQL command, such as SELECT or UPDATE. It then provides when-then-else functionality (WHEN this condition is met THEN do_this).
SELECT product, 'Status' = CASE
        WHEN quantity > 0 THEN 'in stock'
        ELSE 'out of stock'
        END 
		FROM inventory;

--sql - group by
--SQL GROUP BY aggregates (consolidates and calculates) column values into a single record value. GROUP BY requires a list of table columns on which to run the calculations. At first, this behavior will resemble the SELECT DISTINCT
SELECT customer FROM orders GROUP BY customer;

SELECT customer, SUM(quantity) AS "Total Items" FROM orders GROUP BY customer;

SELECT day_of_order, product, SUM(quantity) as "Total" FROM orders GROUP BY day_of_order,product ORDER BY day_of_order;

--sql - having
--The SQL HAVING clause is "like a WHERE clause for aggregated data." It's used with conditional statements, just like WHERE, to filter results. One thing to note is that any column name appearing in the HAVING clause must also appear in the GROUP BY clause.
SELECT day_of_order, product, SUM(quantity) as "Total" FROM orders
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

DELETE FROM orders WHERE customer = 'A+Maintenance';

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
SELECT * FROM employees UNION SELECT * FROM employees2;

--sql - union all
--UNION ALL selects all rows from each table and combines them into a single table. The difference between UNION and UNION ALL is that UNION ALL will not eliminate duplicate rows. Instead, it just pulls all rows from all tables fitting your query specifics and combines them into a table.
SELECT * FROM employees UNION ALL SELECT * FROM employees2;

AVG() -- Returns the average value of a stated column.
COUNT(*) -- Returns a count of the number of rows of table.
SUM() -- Returns the sum of a given column.
Using one of the following functions also returns a numeric value:
GetDate() -- Returns the current date/time.
Current_Timestamp -- Returns the current timestamp.

--SQL Code:
USE mydatabase;

SELECT COUNT(*) AS "Number of Orders" FROM orders;

SELECT SUM(quantity)AS "Total Number of Items Purchased" FROM orders;

SELECT AVG(quantity) AS "Average Number of Items Purchased" FROM orders;

SELECT COUNT(*) AS "Number of Orders",
SUM(quantity)AS "Total Number of Items Purchased",
AVG(quantity)AS "Average Number of Items Purchased"
FROM orders;

