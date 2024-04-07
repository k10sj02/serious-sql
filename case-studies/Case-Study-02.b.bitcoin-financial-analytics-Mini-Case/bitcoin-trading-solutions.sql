-- Look at the dataset (EDA)

SELECT
  *
FROM
  trading.daily_btc -- ORDER BY market_date
-- WHERE 
  -- market_date = '2016-01-01'
LIMIT
  5;
  
-- What is the earliest and latest market_date values?

SELECT
  MIN(market_date) AS earliest_market_date,
  MAX(market_date) AS latest_market_date
FROM
  trading.daily_btc;
  
-- The earliest market date value is 2014-09-17 and the latest market date value is 2021-02-24.
  
-- What was the historic all-time high and low values for the close_price and their dates?

-- SOLUTION 1 (with subqueries) --

SELECT
  market_date,
  close_price AS extreme_price,
  'Highest' AS price_type
FROM
  trading.daily_btc
WHERE
  close_price = (SELECT MAX(close_price) FROM trading.daily_btc)

UNION

SELECT
  market_date,
  close_price AS extreme_price,
  'Lowest' AS price_type
FROM
  trading.daily_btc
WHERE
  close_price = (SELECT MIN(close_price) FROM trading.daily_btc);


-- SOLUTION 2 (using sorting functions) --

(
SELECT
    market_date,
    close_price
FROM
    trading.daily_btc
ORDER BY
    close_price DESC NULLS LAST
LIMIT 1
)
UNION
(
SELECT
    market_date,
    close_price
FROM
    trading.daily_btc
ORDER BY
    close_price
LIMIT 1
);

-- market_date   | close_price
-- --------------------------
-- 2015-01-14    | 178.102997
-- 2021-02-21    | 57539.945313

-- Which date had the most volume traded and what was the close_price for that day?

-- SOLUTION 1 (with sorting functions) --

SELECT
  market_date,
  MAX(volume) AS volume
FROM
  trading.daily_btc
GROUP BY
  market_date
ORDER BY
  volume DESC NULLS LAST
LIMIT
  1;

-- SOLUTION 2 (with subqueries) --

SELECT market_date,
       close_price,
      volume
FROM trading.daily_btc
WHERE volume = (SELECT MAX(volume) FROM trading.daily_btc);
  
-- The market date with the highest volume traded is 2021-01-11 with a volume of 123,320,567,399 bitcoins traded and a close price of $35566.66.

-- How many days had a `low_price` price which was 10% less than the `open_price` 
-- what percentage of the total number of trading days is this rounded to the nearest integer?

SELECT
  COUNT(market_date) AS num_days_with_10_percent_less_low_price
FROM
  trading.daily_btc
WHERE
  low_price <= 0.9 * open_price;

WITH cte AS (
  SELECT
    SUM(
        CASE
        WHEN low_price < 0.9 * open_price THEN 1
        ELSE 0
        END
) AS low_days,
    COUNT(*) AS total_days
    FROM trading.daily_btc
    WHERE volume IS NOT NULL
)
  SELECT
      low_days,
      ROUND(100 * low_days / total_days) AS _percentage
      FROM cte;
  
-- 79 days have a low_price price which was 10% less than the open price i.e. 3% of trading days have a price lower than the open_price.

  -- What percentage of days have a higher close_price than open_price?

WITH btc_price_history AS
(
  SELECT
    COUNT(*) AS num_days_with_higher_close_price_than_open_price
  FROM
    trading.daily_btc
  WHERE
    close_price > open_price
)
SELECT
  num_days_with_higher_close_price_than_open_price,
  (SELECT COUNT (*) FROM trading.daily_btc) AS total_days,
  (num_days_with_higher_close_price_than_open_price :: FLOAT / (SELECT COUNT(*) FROM trading.daily_btc)) * 100 AS percentage
FROM
  btc_price_history;
  
-- 54.5% of days have a higher close price than opening price.

-- What was the largest difference between high_price and low_price and which date did it occur?

SELECT 
  market_date,
  high_price - low_price AS hi_price_lo_price_range
FROM trading.daily_btc
ORDER BY hi_price_lo_price_range DESC NULLS LAST;

-- The largest difference occurred on 2021-02-23 and was 8914.339844. 


-- If you invested $10,000 on the 1st January 2016 - how much is your investment worth in 1st of February 2021? Use the close_price for this calculation

SELECT 
    initial_investment_amount AS initial_investment,
    initial_shares * current_close_price AS current_value
FROM
    (SELECT 
         10000 AS initial_investment_amount,
         (SELECT close_price
          FROM trading.daily_btc
          WHERE market_date = '2016-01-01T00:00:00.000Z') AS initial_close_price) AS initial_investment,
    (SELECT 
         10000 / (
             SELECT close_price
             FROM trading.daily_btc
             WHERE market_date = '2016-01-01T00:00:00.000Z'
         ) AS initial_shares,
         (SELECT close_price
          FROM trading.daily_btc
          WHERE market_date = '2021-02-01T00:00:00.000Z') AS current_close_price) AS investment_value;

-- If you had invested $10,000 your investment would be worth $772151.72 as of 1st of February 2021. A whopping 7621.52% increase! 
