```sql
SELECT name || '(' || SUBSTR(occupation, 1, 1) || ')'
FROM occupations
ORDER BY name ASC;

SELECT 'There are a total of ' || COUNT(occupation) || ' ' || LOWER(occupation) || 's.'
FROM occupations
GROUP BY occupation
ORDER BY COUNT(name), occupation ASC;
```
