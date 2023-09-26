Danny’s Diner 

-- What is the total amount each customer spent at the restaurant?

-- this should show the number of customers we have in our database 

-- we have 2 customers in the members table 

SELECT COUNT (DISTINCT customer_id)
FROM dannys_diner.members;

-- we have 3 customers in the sales table 
SELECT COUNT (DISTINCT customer_id)
FROM dannys_diner.sales;

-- this should show number of meals in our menu

SELECT *
FROM dannys_diner.menu;

--- number of customers in members table should be equal to number of customers in sales table

SELECT COUNT (DISTINCT customer_id)
FROM dannys_diner.sales;

--- Hypothesis 1: number of customers in members table should be equal to number of customers in sales table
--- Hypothesis 2: each customer will have multiple orders in the sales table i.e. a 1-n relationship
--- Hypothesis 3: There will be a multiple records per unique customer_id in the dvd_rentals.rental table

-- first generate group by counts on the target_column_values column
WITH counts_base AS (
SELECT
  customer_id AS target_column_values, 
  COUNT(*) AS row_counts
FROM dannys_diner.sales
GROUP BY target_column_values
)
-- summarize the group by counts above by grouping again on the row_counts from counts_base CTE part
SELECT
  row_counts, -- represents the count of occurrences of each customer_id
  COUNT(target_column_values) as count_of_target_values -- unique customer_id values for each row_counts
FROM counts_base
GROUP BY row_counts
ORDER BY row_counts;

SELECT customer_id, COUNT(*)
FROM dannys_diner.sales
GROUP BY customer_id;

-- This shows us that there are 1 specific customer ordered 3 times while the other 2 customers ordered 6 times respectively.
-- As a result, we can indeed confirm that there are multiple rows per customer_id value in our dannys_diner.sales table.
-- The main query shows that we have 2 customer ids with 6 records each and 1 customer id with 3 records. This confirms the 

-- first generate group by counts on the target_column_values column
WITH counts_base AS (
SELECT 
  product_id AS target_column_values,
  COUNT(*) AS row_counts
FROM dannys_diner.sales
  GROUP BY product_id
  )
SELECT 
   row_counts,
   COUNT(target_column_values) AS count_of_target_values
FROM counts_base
GROUP BY row_counts;

-- The main query shows that we have 2 customer ids with 6 records each and 1 customer id with 3 records. This confirms the 

-- Reverse Engineering: What is the total amount each customer spent at the restaurant?


SELECT t1.customer_id,
       SUM(t2.price)
FROM 

-- What is the purpose of joining these two tables?

-- Summing total purchases of all customers (CLV) who have purchased at restaurant. 
-- We need to keep all of the customer ids from dannys_diner.members table and 
-- match up each record with its corresponding order_date i.e. order from 
-- dannys_diner.sales table value from the dannys_diner.sales table.
-- So we can either do a left or inner join. 

-- 3.1.2. 2 Key Analytical Questions
--- As there are a few unknowns that we need to address as we are matching the 
--- order_date foreign key between the members and sales tables.

-- How many records exist per customer_id value in members or sales tables? i.e. How many records exist per foreign key value in left and right tables?

-- In sales table, there should be 1 to many relationship: one customer_id will be related to many different orders. 
-- In members table, there should be 1 to 1 relationship: one unique customer_id will be related to each row. 

-- Issues with database: each order should ideally have a unique order ID. There is no primary key here since order date
-- is not unique.

-- Since we know that the sales table contains every single order for each customer - it makes sense logically that each valid order record in the sales table should have a relevant customer_id record as each row represents a specific customer who ordered a specific meal.

-- Additionally - it also makes sense that a specific meal might be ordered by multiple customers on the same day.

-- Now when we think about the menu table - it should follow that every item should have a unique product_id.

-- From these 2 key pieces of real life insight - we can generate some hypotheses about our 2 datasets.

-- The number of unique customer_id records will be equal in both the sales and members tables. 
-- There will be a multiple records per unique customer_id in the sales table
-- There will be multiple product_id records per unique customer_id value in the dannys_diner.sales table

-- How many overlapping and missing unique foreign key values are there between the two tables?

SELECT * FROM dannys_diner.sales;

-- how many foreign keys only exist in the left table and not in the right?

SELECT
  COUNT(DISTINCT members.customer_id)
FROM dannys_diner.members
WHERE NOT EXISTS (
  SELECT customer_id
  FROM dannys_diner.sales
  WHERE members.customer_id = sales.customer_id
);

-- how many foreign keys only exist in the right table and not in the left?
-- note the table reference changes
SELECT
  COUNT(DISTINCT sales.customer_id)
FROM dannys_diner.sales
WHERE NOT EXISTS (
  SELECT customer_id
  FROM dannys_diner.members
  WHERE members.customer_id = sales.customer_id
);

-- Ok - we’ve spotted a single inventory_id record. Let’s inspect further:

SELECT *
FROM dannys_diner.sales
WHERE NOT EXISTS (
  SELECT customer_id
  FROM dannys_diner.members
  WHERE members.customer_id = sales.customer_id
);

-- This single record might seem off at first - but let’s revisit what the inventory data actually represents.

-- It is linked to a specific customer_id record in our members table. This is a glaring omission.
-- In a real world problem - we would try to validate this hypothesis by talking with other business 
-- stakeholders or database manager to confirm and resolve the issue.

-- What is the purpose of joining these two tables?

-- We need to keep all of the sales records from dannys_diner.sales table using a left join
-- given the omission of customer C in the members table.

-- What is the total amount each customer spent at the restaurant?

SELECT t1.customer_id cust_id, 
       SUM(t2.price) total_spend
FROM dannys_diner.sales t1
JOIN dannys_diner.menu t2
ON t1.product_id=t2.product_id
GROUP BY t1.customer_id
ORDER BY t1.customer_id;

-- How many days has each customer visited the restaurant?

SELECT 
t1.customer_id,
COUNT(DISTINCT t1.order_date)
FROM dannys_diner.sales t1
GROUP BY t1.customer_id

-- What was the first item from the menu purchased by each customer?

WITH ordered_sales AS (
  SELECT
    sales.customer_id,
    RANK() OVER (
      PARTITION BY sales.customer_id
      ORDER BY sales.order_date
    ) AS order_rank,
    menu.product_name
  FROM dannys_diner.sales
  INNER JOIN dannys_diner.menu
    ON sales.product_id = menu.product_id
)
SELECT DISTINCT
  customer_id,
  product_name
FROM ordered_sales
WHERE order_rank = 1;


-- What is the most purchased item on the menu and how many times was it purchased by all customers?

SELECT 
  t1.product_name,
  COUNT(t2.order_date) AS no_of_purchases
FROM dannys_diner.menu t1
JOIN dannys_diner.sales t2 ON t1.product_id=t2.product_id
GROUP BY t1.product_id, t1.product_name
ORDER BY no_of_purchases DESC
LIMIT 1;

-- Which item was the most popular for each customer?

SELECT 
  t2.customer_id,
  t1.product_id,
  t1.product_name,
  COUNT(t2.order_date) AS no_of_orders
FROM dannys_diner.menu t1
JOIN dannys_diner.sales t2 ON t1.product_id=t2.product_id
GROUP BY t1.product_id, t1.product_name, t2.customer_id
ORDER BY t2.customer_id, no_of_orders DESC

-- What was the first item from the menu purchased by each customer after they became a member?

SELECT 
  MIN(DISTINCT t2.order_date) AS date_of_first_order_as_member,
  t3.join_date,
  t3.customer_id,
  t1.product_id,
  t1.product_name
FROM dannys_diner.menu t1
JOIN dannys_diner.sales t2 ON t1.product_id = t2.product_id
JOIN dannys_diner.members t3 ON t2.customer_id = t3.customer_id
WHERE t2.order_date >= t3.join_date
GROUP BY t3.customer_id, t1.product_id, t1.product_name, t3.join_date
ORDER BY t3.customer_id, date_of_first_order_as_member;

-- Which item was purchased just before the customer became a member?

SELECT 
  MAX(DISTINCT t2.order_date) AS date_of_last_order_before_joining,
  t3.join_date,
  t3.customer_id,
  t1.product_id,
  t1.product_name
FROM dannys_diner.menu t1
JOIN dannys_diner.sales t2 ON t1.product_id = t2.product_id
JOIN dannys_diner.members t3 ON t2.customer_id = t3.customer_id
WHERE t2.order_date < t3.join_date
GROUP BY t3.customer_id, t1.product_id, t1.product_name, t3.join_date
ORDER BY t3.customer_id, date_of_last_order_before_joining;

-- What is the total items and amount spent for each member before they became a member?

SELECT 
  t3.customer_id,
  SUM(price) AS customer_spend_before_joining
FROM dannys_diner.menu t1
JOIN dannys_diner.sales t2 ON t1.product_id = t2.product_id
JOIN dannys_diner.members t3 ON t2.customer_id = t3.customer_id
WHERE t2.order_date < t3.join_date
GROUP BY t3.customer_id
ORDER BY t3.customer_id;

-- If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

SELECT
  t2.customer_id,
  SUM 
    (CASE 
      WHEN product_name = 'sushi' THEN price * 20
      ELSE price * 10
    END) AS points
FROM dannys_diner.menu t1
JOIN dannys_diner.sales t2 ON t1.product_id = t2.product_id
GROUP BY t2.customer_id
ORDER BY t2.customer_id ASC;

-- Which item was the most popular for each customer?


WITH customer_cte AS (
    SELECT
      sales.customer_id,
      COUNT(sales.order_date) AS item_quantity,
      RANK () OVER (
      PARTITION BY sales.customer_id
      ORDER BY COUNT(sales.order_date)
      ) AS item_rank,
      menu.product_name
    FROM dannys_diner.sales
    JOIN dannys_diner.menu
    ON sales.product_id = menu.product_id
    GROUP BY 
      menu.product_name, 
      sales.customer_id
)
    SELECT DISTINCT(customer_id),
           product_name,
           item_rank,
           item_quantity
    FROM customer_cte
    WHERE item_rank = 1
    ORDER BY customer_id, item_rank ASC;

-- Which item was purchased just after the customer became a member?
WITH cte_member AS (
    SELECT
      t2.order_date,
      t3.join_date,
      t3.customer_id,
      t1.product_name,
      RANK () OVER (
      PARTITION BY t2.customer_id
      ORDER BY t2.order_date) AS order_rank
    FROM dannys_diner.menu t1
    JOIN dannys_diner.sales t2
    ON t1.product_id = t2.product_id
    JOIN dannys_diner.members t3
    ON t2.customer_id = t3.customer_id
    WHERE t2.order_date >= t3.join_date::DATE
  )
  SELECT 
    DISTINCT customer_id,
    order_date,
    product_name,
    order_rank
  FROM cte_member
  WHERE order_rank = 1


  -- What is the total items and amount spent for each member before they became a member?
SELECT
  t3.customer_id,
    COUNT(DISTINCT t2.product_id) AS unique_items,
  SUM(price) AS customer_spend_before_joining
FROM
  dannys_diner.menu t1
  JOIN dannys_diner.sales t2 ON t1.product_id = t2.product_id
  JOIN dannys_diner.members t3 ON t2.customer_id = t3.customer_id
WHERE
  t2.order_date < t3.join_date::DATE
GROUP BY
  t3.customer_id
ORDER BY
  t3.customer_id;


-- If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
SELECT
  t2.customer_id,
  SUM (
    CASE
      WHEN product_name = 'sushi' THEN price * 2 * 10
      ELSE price * 10
    END
  ) AS points
FROM
  dannys_diner.menu t1
  JOIN dannys_diner.sales t2 ON t1.product_id = t2.product_id
GROUP BY
  t2.customer_id
ORDER BY
  t2.customer_id ASC;


WITH dates_cte AS (
  SELECT 
    customer_id, 
    join_date, 
    join_date + 6 AS valid_date, 
    DATE_TRUNC(
      'month', '2021-01-31'::DATE)
      + interval '1 month' 
      - interval '1 day' AS last_date
  FROM dannys_diner.members
)

— Bonus Question 11

SELECT 
  sales.customer_id, 
  SUM(CASE
    WHEN menu.product_name = 'sushi' THEN 2 * 10 * menu.price
    WHEN sales.order_date BETWEEN dates.join_date AND dates.valid_date THEN 2 * 10 * menu.price
    ELSE 10 * menu.price END) AS points
FROM dannys_diner.sales
JOIN dates_cte AS dates
  ON sales.customer_id = dates.customer_id
  AND sales.order_date <= dates.last_date
JOIN dannys_diner.menu
  ON sales.product_id = menu.product_id
GROUP BY sales.customer_id;

https://medium.com/analytics-vidhya/8-week-sql-challenge-case-study-week-1-dannys-diner-2ba026c897ab


  -- Bonus Question 12  

SELECT
  sales.customer_id,
  sales.order_date,
  menu.product_name,
  menu.price,
  (CASE WHEN sales.order_date > members.join_date::DATE THEN 'Y'
    ELSE 'N'
  END) AS member
FROM dannys_diner.sales
INNER JOIN dannys_diner.menu
  ON sales.product_id = menu.product_id
INNER JOIN dannys_diner.members
  ON sales.customer_id = members.customer_id
ORDER BY
  sales.customer_id,
  sales.order_date,
  menu.price DESC;

Insights: 

Customer B spent most before converting to a member. 

Customers took at least 6 days to convert to members after the last order as a customer.
  
Ramen was the most popular meal.

Customer B has visited the restaurant the most with 6 visits in Jan 2021. 

Customer A has the highest customer lifetime value, spending the most ($76) despite having less restaurant visits than Customer B ($74). Customer C has the lowest lifetime value and predictably, never converted to a member.