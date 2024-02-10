-- This file contains example queries in PostgreSQL dialect.

## Has anyone ever made a cohort analysis pivot table on a quarterly rather than monthly basis?
### I'm working on that in SQL (MySQL 5.7.12) and I can get each of the quarters (Q2 '23, Q3 '23, etc.) 
### in the column label, but I'm actually wondering now if each of the instances across the row headers should represent billing months or billing quarters## The only reason I'm making this quarterly cohort analysis anyway is because a client asked for it 
### in addition to the regular monthly cohort analysis?

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

