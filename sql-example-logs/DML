-- UPDATE statement to convert existing date values to DATETIME format
UPDATE coviddeaths
-- SET the 'date' column to the result of the STR_TO_DATE() function, which converts the existing date values to the specified format
SET date = STR_TO_DATE(date, '%m/%d/%y');

-- ALTER TABLE statement to modify the data type of the 'date' column
ALTER TABLE coviddeaths
-- MODIFY COLUMN 'date' to change its data type to DATETIME, which is a date and time type that MySQL recognizes
MODIFY COLUMN date DATETIME;
