-- This file contains example queries in PostgreSQL dialect.

-------------------------------
   ---- COHORT ANALYSIS ----
-------------------------------

# Has anyone ever made a cohort analysis pivot table on a quarterly rather than monthly basis?
# I'm working on that in SQL (MySQL 5.7.12) and I can get each of the quarters (Q2 '23, Q3 '23, etc.) 
# in the column label, but I'm actually wondering now if each of the instances across the row headers should represent billing months or billing quarters## The only reason I'm making this quarterly cohort analysis anyway is because a client asked for it 
# in addition to the regular monthly cohort analysis?

SELECT
    -- This column calculates the quarter in which the delivery occurred, formatted as 'Q[Quarter]-YYYY'
    concat('Q', ceil(month(fdf.delivered_at::date) / 3), '-', year(fdf.delivered_at::date)) as quarter_occurred,
    
    -- This column calculates the tenure of the delivery in quarters
    datediff('quarter', first_delivered_fill_delivered_at::date, fdf.DELIVERED_AT::date) as quarter_tenure,
    
    -- This column counts the number of distinct user IDs who were served and also provided feedback (NPS)
    count(distinct CASE WHEN first_delivered_fill_delivered_at::date = delivered_at::date THEN dp.user_id END) as nps_served,
    
    -- This column counts the total number of distinct user IDs served
    count(distinct dp.user_id) as total_patients
FROM
    analytics.core.fct_delivered_fills fdf
GROUP BY
    1, 2, 3;

-------------------------------------------------
   ---- RUNNING TOTALS & CUMULATIVE SUMS ----
--------------------------------------------------

-- Solution #1 using self-joins
-- Explanation: This SQL query calculates a cumulative sum of the volume column by adding the previous volume amounts to a running total.

-- Define a common table expression (CTE) named 'cum_sum' to select the market_date and volume from the 'updated_daily_btc' table, ordered by market_date, and limit the result to 10 rows.
WITH cum_sum AS (
  SELECT
    market_date,
    volume
  FROM updated_daily_btc
  ORDER BY market_date
  LIMIT 10
)
-- Select the market_date and volume columns from the 'cum_sum' CTE, and calculate the running total of volume by summing the volumes of all previous rows, using an inner join between 'cum_sum' aliased as 't1' and 't2' with a condition that market_date of 't1' is greater than or equal to market_date of 't2'.
SELECT 
  t1.market_date,
  t1.volume,
  SUM(t2.volume) AS running_total
FROM cum_sum t1
INNER JOIN cum_sum t2
ON t1.market_date >= t2.market_date
    
/*The ON t1.market_date >= t2.market_date line in the SQL query specifies the condition for joining 
the two instances of the cum_sum CTE (common table expression) named t1 and t2. 
In this specific context, t1.market_date >= t2.market_date ensures that for each row in t1, it is 
joined with all the rows in t2 where the market_date value in t1 is greater than or equal to the 
market_date value in t2.*/
GROUP BY 1,2
ORDER BY 1,2;

-- Solution #2 using window functions
-- Explanation: This SQL query calculates the cumulative sum of the 'volume' column from the 'updated_daily_btc' table for the first 10 rows, ordered by 'market_date'.

-- Define a Common Table Expression (CTE) named 'volume_data' to select the 'market_date' and 'volume' columns from the 'updated_daily_btc' table, ordering them by 'market_date', and limiting the result to the first 10 rows.
WITH volume_data AS (
  SELECT
    market_date,
    volume
  FROM updated_daily_btc
  ORDER BY market_date
  LIMIT 10
)

-- Selects 'market_date' and 'volume' from the 'volume_data' CTE, calculating the cumulative sum of 'volume' using a window function.

SELECT
  market_date,
  volume,
  SUM(volume) OVER (ORDER BY market_date) AS cumulative_sum
FROM volume_data;

-- Enhances conciseness and readability by utilizing a WINDOW alias for the window function.

SELECT
  market_date,
  volume,
  SUM(volume) OVER rt
FROM updated_daily_btc
WINDOW rt 
  AS (ORDER BY market_date);
