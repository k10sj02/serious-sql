# Bitcoin Dataset

### Insights Gleaned:

1. **Market Date Analysis:**
   - Identified the earliest and latest market dates in the dataset.
   - Investigated the high and low prices for all market dates.

2. **Volume Analysis:**
   - Determined the date with the highest volume traded and the corresponding volume.
   - Provided insights into the market's liquidity and trading activity.

3. **Price Movement Analysis:**
   - Calculated the number of days where the low price was 10% less than the open price, indicating potential volatility.
   - Analyzed the percentage of days where the close price exceeded the open price, reflecting bullish market sentiments.

4. **Price Range Analysis:**
   - Identified the date with the largest difference between the high and low prices, indicating significant intraday volatility.

5. **Investment Performance Analysis:**
   - Calculated the growth of a hypothetical investment of $10,000 made on a specific date until a later date, using close prices for valuation.

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
