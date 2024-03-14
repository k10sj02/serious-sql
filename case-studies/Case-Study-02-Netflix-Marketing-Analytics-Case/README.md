# DVD Rentals Insights

This repository contains SQL scripts for generating insights from a DVD rental database. These insights include category-based and actor-based recommendations and insights derived from customer rental behavior.

## Table of Contents

- [Category Insights](#category-insights)
  - [Base Dataset Creation](#1-create-a-base-dataset-and-join-all-relevant-tables)
  - [Customer Rental Counts by Category](#2-calculate-customer-rental-counts-for-each-category)
  - [Aggregate Total Films Watched](#3-aggregate-all-customer-total-films-watched)
  - [Identify Top Categories for Each Customer](#4-identify-the-top-2-categories-for-each-customer)
  - [Calculate Average Rental Count per Category](#5-calculate-each-categorys-aggregated-average-rental-count)
  - [Calculate Percentile Metric for Top Categories](#6-calculate-the-percentile-metric-for-each-customers-top-category-film-count)
  - [Generate First Top Category Insights](#7-generate-our-first-top-category-insights-table-using-all-previously-generated-tables)
  - [Generate Second Category Insights](#8-generate-the-2nd-category-insights)
- [Category Recommendations](#category-recommendations)
  - [Summarised Film Count Table](#1-generate-a-summarised-film-count-table-with-the-category-included)
  - [Previously Watched Films Exclusion](#2-create-previously-watched-films-for-the-top-2-categories-to-exclude-for-each-customer)
  - [Generate Category Recommendations](#3-finally-perform-an-anti-join-from-the-relevant-category-films-on-the-exclusions)
- [Actor Insights](#actor-insights)
  - [Actor Base Dataset Creation](#1-create-a-new-base-dataset-which-has-a-focus-on-the-actor-instead-of-category)
  - [Identify Top Actors for Each Customer](#2-identify-the-top-actor-and-their-respective-rental-count-for-each-customer)
- [Actor Recommendations](#actor-recommendations)
  - [Total Actor Rental Counts](#1-generate-total-actor-rental-counts-to-use-for-film-popularity-ranking-in-later-steps)
  - [Film Exclusions for Actor Recommendations](#2-create-an-updated-film-exclusions-table-which-includes-the-previously-watched-films)

---

## Category Insights

### 1. Create a base dataset and join all relevant tables

The script creates a base dataset `complete_joined_dataset` by joining rental, inventory, film, film_category, and category tables.

### 2. Calculate customer rental counts for each category

The script calculates rental counts for each customer in each category and stores them in the `category_counts` table.

### 3. Aggregate all customer total films watched

Aggregates total rental counts for each customer in the `total_counts` table.

### 4. Identify the top 2 categories for each customer

Identifies the top 2 categories based on rental counts for each customer and stores them in the `top_categories` table.

### 5. Calculate each category's aggregated average rental count

Calculates the average rental count for each category and stores it in the `average_category_count` table.

### 6. Calculate the percentile metric for each customer's top category film count

Calculates the percentile metric for each customer's top category film count and stores it in the `top_category_percentile` table.

### 7. Generate our first top category insights table using all previously generated tables

Generates insights for the top category based on all previously generated tables and stores them in the `first_category_insights` table.

### 8. Generate the 2nd category insights

Generates insights for the second category based on all previously generated tables and stores them in the `second_category_insights` table.

---

## Category Recommendations

### 1. Generate a summarised film count table with the category included

Generates a summarised film count table including the category and stores it in the `film_counts` table.

### 2. Create previously watched films for the top 2 categories to exclude for each customer

Creates a table `category_film_exclusions` containing previously watched films for the top 2 categories to exclude for each customer.

### 3. Finally perform an anti-join from the relevant category films on the exclusions and use window functions to keep the top 3 from each category by popularity

Performs an anti-join operation to exclude previously watched films and recommends the top 3 films from each category based on popularity. Results are stored in the `category_recommendations` table.

---

## Actor Insights

### 1. Create a new base dataset which has a focus on the actor instead of category

Creates a base dataset `actor_joined_dataset` focusing on actors by joining rental, inventory, film, film_actor, and actor tables.

### 2. Identify the top actor and their respective rental count for each customer based on the ranked rental counts

Identifies the top actor and their respective rental counts for each customer based on ranked rental counts. Results are stored in the `top_actor_counts` table.

---

## Actor Recommendations

### 1. Generate total actor rental counts to use for film popularity ranking in later steps

Generates total actor rental counts to use for film popularity ranking and stores them in the `actor_film_counts` table.

### 2. Create an updated film exclusions table which includes the previously watched films

Creates an updated film exclusions table `actor_film_exclusions` including previously watched films.

### 3. Apply the same `ANTI JOIN` technique and use a window function to identify the 3 valid film recommendations for our customers

Applies an anti-join technique to exclude previously watched films and recommends the top 3 films for each customer. Results are stored in the `actor_recommendations` table.

---

This README provides an overview of the SQL scripts in this repository for generating insights and recommendations from a DVD rental database. For detailed information and implementation, refer to the individual SQL files.
