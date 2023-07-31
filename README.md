# Serious SQL

![Screenshot of Data with Danny logo.](https://user-images.githubusercontent.com/81607668/128655887-038f2b02-0e9d-44b0-b632-594134bf3d56.png)

Serious SQL is one of the courses in the Data With Danny Virtual Data Apprenticeship Program.

View the course [here](https://www.datawithdanny.com/courses/serious-sql).

-------------------------------------

## 📚 Table of Contents
- 🛠️ Overview
- 🚀 Solutions
- 💻 Key Highlights

--------------------------------------

### 🛠️ Overview

With the Health Analytics Mini Case Study, I queried data to bring insights to the following questions:

1. How many `unique users` exist in the logs dataset?
2. How many total `measurements` do we have `per user on average`?
3. What about the `median` number of measurements per user?
4. How many users have `3 or more` measurements?
5. How many users have `1,000 or more` measurements?
6. Have logged `blood glucose` measurements?
7. Have `at least 2 types` of measurements?
8. Have all 3 measures - `blood glucose`, `weight` and `blood pressure`?
9. What is the `median systolic/diastolic` `blood pressure` values?

-----------------------------------------

### 🚀 Solutions with Explanations

**How many `unique users` exist in the logs dataset?**

```sql
SELECT
  COUNT(DISTINCT id) AS unique_users
FROM health.user_logs;
```

|unique_users                            |
|----------------------------------------|
|554                                     |

Let's break down the query:

`SELECT`: This keyword is used to specify which columns you want to retrieve from the database.

`COUNT`: This is an aggregate function in SQL that returns the number of rows that match a specified condition. In this case, it counts the number of distinct id values.

`DISTINCT`: This keyword is used to ensure that only unique values are counted. It means that if there are multiple rows with the same id, they will be treated as one. 

Please note, `DISTINCT` is not a function. It is a _modifier_ of the `SELECT` statement that tells MySQL to strip duplicate rows from the result set generated by the query. It can be used together with `COUNT()` aggregate function (as `COUNT(DISTINCT expr`)) and it has the same meaning: it ignores the duplicates.

`id`: This is the column in the user_logs table whose distinct count we want to calculate.

`FROM health.user_logs`: This specifies the table (user_logs) and the database (health) from which the data should be retrieved.

When you execute this SQL query, it will return a single number representing the count of unique id values in the user_logs table of the health database.
