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

### 🚀 Solutions

**How many `unique users` exist in the logs dataset?**

```sql
SELECT
  COUNT(DISTINCT id) AS unique_users
FROM health.user_logs;
```

|unique_users                            |
|----------------------------------------|
|554                                     |
