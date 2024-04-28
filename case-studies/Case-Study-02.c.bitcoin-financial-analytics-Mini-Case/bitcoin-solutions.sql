-- What is the average daily volume of Bitcoin for the last 7 days?
-- Create a 1/0 flag if a specific day is higher than the last 7 days volume average

WITH daily_volume_data AS (
SELECT
  market_date,
  volume,
  AVG(volume) OVER (ORDER BY market_date 
                    RANGE BETWEEN '7 DAYS' PRECEDING AND '1 DAY' PRECEDING) AS past_weekly_avg_volume

FROM updated_daily_btc
)
SELECT 
  market_date,
  volume,
  CASE 
    WHEN volume > past_weekly_avg_volume THEN 1
    ELSE 0
    END AS volume_flag
FROM daily_volume_data
ORDER BY market_date DESC
LIMIT 10;

/* This is a good example of a moving window. This allows us to perform calculations, such as averaging, 
aggregating, or calculating trends, over a specific time period relative to each data point in the dataset, 
providing valuable insights into the trends and patterns present in the data over time. 

To calculate the past_weekly_avg_volume, we consider the volumes of the previous 7 days (including '2014-09-18' but excluding '2014-09-11', because we're calculating the average up to the day before '2014-09-18').

For example The volumes for the previous 7 days are:

'2014-09-12': NULL (no data available for this day)
'2014-09-13': NULL (no data available for this day)
'2014-09-14': NULL (no data available for this day)
'2014-09-15': NULL (no data available for this day)
'2014-09-16': NULL (no data available for this day)
'2014-09-17': 21056800
'2014-09-18': 34483200

The average of these volumes is:
(21056800+34483200)/2 = 27770000


*/
