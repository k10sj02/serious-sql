# Bitcoin Dataset

### Insights Gleaned:

1. **Market Date Analysis:**
   - Identified the earliest and latest market dates in the dataset as 2014-09-17 and the latest market date as 2021-02-24.
   - Investigated the high and low prices for all market dates.

2. **Volume Analysis:**
   - Determined the date with the highest volume traded and the corresponding volume was 2021-01-11, with a volume of 123,320,567,399 bitcoins.
   - Provided insights into the market's liquidity and trading activity.

3. **Price Movement Analysis:**
   - Calculated the number of days where the low price was 10% less than the open price, indicating potential volatility. Found that 79 days had a low price 10% less than the open price.
   - Analyzed that 54.5% of days had a higher close price than the open price, indicating bullish market sentiments.

4. **Price Range Analysis:**
   - - Identified the largest difference between the high and low prices on 2021-02-23, which was 8914.339844, indicating significant intraday volatility.

5. **Investment Performance Analysis:**
   - Calculated that if you had invested $10,000 on 1st January 2016, your investment would be worth $772,151.72 as of 1st February 2021, representing a 7621.52% increase.

### Techniques Used:

1. **SQL Queries:**
   - Leveraged SQL queries to retrieve and analyze data from the trading dataset.
   - Employed various SQL functions such as `SELECT`, `MIN`, `MAX`, `COUNT`, `GROUP BY`, `ORDER BY` to perform aggregations, filtering, and sorting.

2. **Data Exploration:**
   - Explored the dataset to understand its structure, including available columns and their data types.
   - Identified key metrics such as market dates, prices, and trading volumes.

3. **Data Aggregation:**
   - Aggregated data to derive insights such as the earliest and latest market dates, volume traded on specific dates, and count of days meeting certain criteria.

4. **Statistical Analysis:**
   - Conducted basic statistical analysis to calculate metrics like percentage change and price differentials.
