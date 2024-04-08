
-- MOCK INTERVIEW QUESTIONS --

-- 1. Show the product with the longest average time between the initial order to the time of delivery

SELECT product.product_id AS prod_id, 
	   product.product_name AS prod_name,
	   AVG(DATEDIFF(delivery.delivery_end, order.transaction_time)) AS total_time
FROM product
JOIN order
ON product.product_id = order.product_id
JOIN delivery
ON order.order_id = delivery.order_id
GROUP BY prod_id, prod_name
ORDER BY total_time DESC
LIMIT 1;

-- 2. Show three products with the highest volume of sales: by quantity, by revenue 

SELECT product.product_id AS prod_id,
	   product.product_name AS prod_name,
	   SUM(order.quantity) AS quantity
FROM product
JOIN order
ON product.product_id = order.product_id
GROUP BY prod_id, prod_name
ORDER BY quantity DESC
LIMIT 3;

WITH revenue_table AS (
SELECT product.product_id AS prod_id,
	   product.product_name AS prod_name,

	   -- product_price.product_price AS prod_price,
	   -- order.quantity AS quantity,
	   product_price.product_price * order.quantity AS revenue
FROM product
JOIN order
ON product.product_id = order.product_id
JOIN product_price 
ON product_price.product_id = order.product_id
GROUP BY prod_id, prod_name
ORDER BY revenue DESC
LIMIT 3),

SELECT SUM(revenue) AS sum_rev
FROM revenue_table
GROUP BY prod_id
ORDER BY sum_rev;

Show three products with the highest volumne of sales: by quantity, by revenue : METHOD 2

SELECT 
	product.product_id,
	product_name,
	SUM(order.quantity) AS value,
	'quantity' AS meaning
FROM product
JOIN order ON product.product_id=order.product_id
GROUP BY product.product_id, product_name
ORDER BY order.quantity DESC
LIMIT 3

UNION

SELECT 
	product.product_id,
	product_name,
	product_price * order.quantity AS value,
	'revenue' AS meaning
FROM product
JOIN order ON product.product_id=order.product_id
GROUP BY product.product_id, product_name
ORDER BY revenue DESC
LIMIT 3


--- 3. Show the above for the moving window of the past three days

SELECT product.product_id
		product_name, 
		SUM(order.quantity) AS qty
FROM product 
JOIN order ON product.product_id=order.product_id
WHERE transaction_time >= NOW() - INTERVAL '5 DAY'
		AND transaction_time <= NOW() - INTERVAL '2 DAY'
GROUP BY product.product_id, product_name
ORDER BY order.quantity DESC
LIMIT 3

3. Show the above for the moving window of the past three days - METHOD 2

SELECT product.product_id
		product_name, 
		SUM(order.quantity) AS qty
FROM product 
JOIN order ON product.product_id=order.product_id
WHERE transaction_time BETWEEN NOW() - INTERVAL '5 DAY' 
		AND NOW() - INTERVAL '2 DAY'
GROUP BY product.product_id, product_name
ORDER BY order.quantity DESC
LIMIT 3


-- 4. Show the most grossing department in January this year vs January of the last year

SELECT 
	EXTRACT (year) order.transaction_time AS order_year
	sales_personnel.department_id, 
	SUM(product_price.product_price * order.quantity) AS gross_revenue
FROM product_price
JOIN order ON product_price.product_id = order.product_id
JOIN order.sales_person_id = sales_personnel.person_id
WHERE EXTRACT (month) order_month = 'January'
GROUP BY order_year, sales_personnel.department_id
ORDER BY gross_revenue DESC
LIMIT 1;

SELECT 
	EXTRACT (year) order.transaction_time AS order_year
	sales_personnel.department_id, 
	SUM(product_price.product_price * order.quantity) AS gross_revenue
FROM product_price
JOIN order ON product_price.product_id = order.product_id
JOIN order.sales_person_id = sales_personnel.person_id
WHERE EXTRACT (month) order_month = 'January'
GROUP BY order_year, sales_personnel.department_id
ORDER BY gross_revenue DESC
LIMIT 1;

Show the most grossing department in January this year vs January of the last year: METHOD 2

WITH jan_2023_rankings AS (

SELECT 
	EXTRACT (year) order.transaction_time AS order_year
	sales_personnel.department_id, 
	SUM(product_price.product_price * order.quantity) AS gross_revenue
FROM product_price
JOIN order ON product_price.product_id = order.product_id
JOIN order.sales_person_id = sales_personnel.person_id
WHERE EXTRACT (month) order_month = 'January'
GROUP BY order_year, sales_personnel.department_id
ORDER BY gross_revenue DESC
LIMIT 1
			),

jan_2022_rankings AS(

SELECT 
	EXTRACT (year) order.transaction_time AS order_year
	sales_personnel.department_id, 
	SUM(product_price.product_price * order.quantity) AS gross_revenue
FROM product_price
JOIN order ON product_price.product_id = order.product_id
JOIN order.sales_person_id = sales_personnel.person_id
WHERE EXTRACT (month) order_month = 'January'
GROUP BY order_year, sales_personnel.department_id
ORDER BY gross_revenue DESC
LIMIT 1;
			)

SELECT department_id, gross_revenue

-------------------------------------------------
-- order_year    department_id   gross_revenue --
-- 2023          1               250000        --
-- 2023          2               300000        --
-- 2023          3               5000          --
-------------------------------------------------
	
--- 2. Show three products with the highest volumne of sales: by quantity, by revenue

SELECT 
	product.product_id,
	product_name,
	SUM(order.quantity) AS value,
	'quantity' AS meaning
FROM product
JOIN order ON product.product_id=order.product_id
GROUP BY product.product_id, product_name
ORDER BY order.quantity DESC
LIMIT 3

UNION

SELECT 
	product.product_id,
	product_name,
	product_price * order.quantity AS value,
	'revenue' AS meaning
FROM product
JOIN order ON product.product_id=order.product_id
GROUP BY product.product_id, product_name
ORDER BY revenue DESC
LIMIT 3

--- 3. Show the above for the moving window of the past three days

SELECT product.product_id
		product_name, 
		SUM(order.quantity) AS qty
FROM product 
JOIN order ON product.product_id=order.product_id
WHERE transaction_time >= NOW() - INTERVAL '5 DAY'
		AND transaction_time <= NOW() - INTERVAL '2 DAY'
GROUP BY product.product_id, product_name
ORDER BY order.quantity DESC
LIMIT 3

-- 3. Show the above for the moving window of the past three days - METHOD 2

SELECT product.product_id
		product_name, 
		SUM(order.quantity) AS qty
FROM product 
JOIN order ON product.product_id=order.product_id
WHERE transaction_time BETWEEN NOW() - INTERVAL '5 DAY' 
		AND NOW() - INTERVAL '2 DAY'
GROUP BY product.product_id, product_name
ORDER BY order.quantity DESC
LIMIT 3

/*

THIS CODE IS BORROWED FROM LEETCODE.COM

+---------------+----------+
| Column Name   | Type     |
+---------------+----------+
| team_id       | int      |
| team_name     | varchar  |
+---------------+----------+
team_id is the column with unique values of this table.
Each row of this table represents a single football team.
 

Table: Matches

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| match_id      | int     |
| host_team     | int     |
| guest_team    | int     | 
| host_goals    | int     |
| guest_goals   | int     |
+---------------+---------+
match_id is the column of unique values of this table.
Each row is a record of a finished match between two different teams. 
Teams host_team and guest_team are represented by their IDs in the Teams table (team_id), and they scored host_goals and guest_goals goals, respectively.
 

You would like to compute the scores of all teams after all matches. Points are awarded as follows:
A team receives three points if they win a match (i.e., Scored more goals than the opponent team).
A team receives one point if they draw a match (i.e., Scored the same number of goals as the opponent team).
A team receives no points if they lose a match (i.e., Scored fewer goals than the opponent team).
Write a solution that selects the team_id, team_name and num_points of each team in the tournament after all described matches.

Return the result table ordered by num_points in decreasing order. In case of a tie, order the records by team_id in increasing order.

The result format is in the following example.

Example 1:

Input: 
Teams table:
+-----------+--------------+
| team_id   | team_name    |
+-----------+--------------+
| 10        | Leetcode FC  |
| 20        | NewYork FC   |
| 30        | Atlanta FC   |
| 40        | Chicago FC   |
| 50        | Toronto FC   |
+-----------+--------------+
Matches table:
+------------+--------------+---------------+-------------+--------------+
| match_id   | host_team    | guest_team    | host_goals  | guest_goals  |
+------------+--------------+---------------+-------------+--------------+
| 1          | 10           | 20            | 3           | 0            |
| 2          | 30           | 10            | 2           | 2            |
| 3          | 10           | 50            | 5           | 1            |
| 4          | 20           | 30            | 1           | 0            |
| 5          | 50           | 30            | 1           | 0            |
+------------+--------------+---------------+-------------+--------------+
Output: 
+------------+--------------+---------------+
| team_id    | team_name    | num_points    |
+------------+--------------+---------------+
| 10         | Leetcode FC  | 7             |
| 20         | NewYork FC   | 3             |
| 50         | Toronto FC   | 3             |
| 30         | Atlanta FC   | 1             |
| 40         | Chicago FC   | 0             |
+------------+--------------+---------------+

*/


-- Drop Database if Exists
DROP DATABASE IF EXISTS FootballScoresDB;

-- Create Database
CREATE DATABASE FootballScoresDB;

-- Drop the teams table with CASCADE option
DROP TABLE IF EXISTS teams CASCADE;

-- Create Teams Table
CREATE TABLE teams (
    team_id INT PRIMARY KEY,
    team_name VARCHAR(255)
);

-- Insert Sample Data into Teams Table
INSERT INTO teams (team_id, team_name)
VALUES 
    (10, 'Leetcode FC'),
    (20, 'NewYork FC'),
    (30, 'Atlanta FC'),
    (40, 'Chicago FC'),
    (50, 'Toronto FC');

-- Drop the teams table with CASCADE option
DROP TABLE IF EXISTS matches CASCADE;

-- Create Matches Table
CREATE TABLE matches (
    match_id INT PRIMARY KEY,
    host_team INT,
    guest_team INT,
    host_goals INT,
    guest_goals INT,
    FOREIGN KEY (host_team) REFERENCES teams(team_id),
    FOREIGN KEY (guest_team) REFERENCES teams(team_id)
);

-- Insert Sample Data into Matches Table
INSERT INTO matches (match_id, host_team, guest_team, host_goals, guest_goals)
VALUES 
    (1, 10, 20, 3, 0),
    (2, 30, 10, 2, 2),
    (3, 10, 50, 5, 1),
    (4, 20, 30, 1, 0),
    (5, 50, 30, 1, 0);
