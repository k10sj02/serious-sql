
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


order_year	department_id		gross_revenue
2023		1			250000			
2023		2			300000
2023		3			5000
