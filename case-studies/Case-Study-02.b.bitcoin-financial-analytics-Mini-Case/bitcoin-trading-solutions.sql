-- Look at the dataset

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

SELECT
  market_date,
  high_price,
  low_price
FROM
  trading.daily_btc;

-- Run query to see table.

-- Which date had the most volume traded and what was the close_price for that day?

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
  
-- The market date with the highest volume traded is 2021-01-11 with a volume of 123,320,567,399 bitcoins traded.

-- How many days had a low_price price which was 10% less than the open_price?

SELECT
  COUNT(market_date) AS num_days_with_10_percent_less_low_price
FROM
  trading.daily_btc
WHERE
  low_price <= 0.9 * open_price;
  
-- 79 days have a low_price price which was 10% less than the open price.

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
