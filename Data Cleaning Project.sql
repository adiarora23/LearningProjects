/*
Project Three: Data Cleaning

This project will be about cleaning the given dataset by making changes to it via SQL!
*/

-- To start, we will look at the dataset as a whole:

SELECT *
FROM ProjectTwo..layoffs

-- Now, we can start cleaning the data!
-- This will include the following:

-- 1. Remove Duplicates
-- 2. Standardize The Data
-- 3. NULL Values or BLANK Values
-- 4. Remove Any Columns 

-- To make sure we do not lose anything from the raw dataset, we will create a staging dataset and work with that:

SELECT * INTO layoffs_staging
FROM ProjectTwo..layoffs

-- Now we have our staging dataset, so we can start cleaning the following dataset:

SELECT *
FROM ProjectTwo..layoffs_staging

-- Need to clean this, but data has no unique IDs/keys to it, so we create a partition on all necessary columns to create a row number:

SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, industry, total_laid_off, percentage_laid_off, date ORDER BY date) AS row_num
FROM ProjectTwo..layoffs_staging


-- Now that we have this new column, we can use this query multiple times. To do this with our other queries, we will create a CTE:

WITH duplicate_CTE AS
(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions ORDER BY date) AS row_num
FROM ProjectTwo..layoffs_staging
)
SELECT *
FROM duplicate_CTE
WHERE row_num > 1

-- Now that we have this CTE, we see the duplicate companies listed. To verify this we will check if it is valid with a quick query:

SELECT *
FROM ProjectTwo..layoffs_staging
WHERE company = 'Casper'

-- After the verification, we will start deleting the duplicates listed in the CTE. First we create a new staging table to work off of

-- DROP TABLE ProjectTwo..layoffs_staging2

CREATE TABLE ProjectTwo..layoffs_staging2 (
	company text,
	location text,
	industry text,
	total_laid_off int DEFAULT NULL,
	percentage_laid_off text,
	date text,
	stage text,
	country text,
	funds_raised_millions int DEFAULT NULL,
	row_num int
)

SELECT *
FROM ProjectTwo..layoffs_staging2

INSERT INTO ProjectTwo..layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions ORDER BY date) AS row_num
FROM ProjectTwo..layoffs_staging

-- Now all the information is in the new staging table + new column, we will look at the duplicates and delete them:

SELECT *
FROM ProjectTwo..layoffs_staging2
WHERE row_num > 1

--DELETE
--FROM ProjectTwo..layoffs_staging2
--WHERE row_num > 1

SELECT *
From ProjectTwo..layoffs_staging2

-- Now that we have deleted the duplicates, we can now work on standardizing the data:

SELECT company, TRIM(CAST(company as varchar(MAX)))
From ProjectTwo..layoffs_staging2  -- removes all blank spaces

UPDATE ProjectTwo..layoffs_staging2
SET company = TRIM(CAST(company as varchar(MAX))) -- updated table with correct spacing

SELECT DISTINCT(CAST(industry as varchar(MAX)))
FROM ProjectTwo..layoffs_staging2

UPDATE ProjectTwo..layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%'

SELECT DISTINCT(CAST(country as varchar(MAX))), TRIM(TRAILING '.' FROM CAST(country as varchar(MAX)))
FROM ProjectTwo..layoffs_staging2
ORDER BY 1

UPDATE ProjectTwo..layoffs_staging2
SET country = TRIM(TRAILING '.' FROM CAST(country as varchar(MAX)))
WHERE country LIKE 'United States%'


-- Now, after standardizing the dataset, we can now move onto NULL and BLANK values

SELECT *
FROM ProjectTwo..layoffs_staging2
WHERE total_laid_off IS NULL AND percentage_laid_off LIKE 'NULL'

SELECT *
FROM ProjectTwo..layoffs_staging2
WHERE industry is NULL

-- Finally, we can drop the columns that are not needed

SELECT *
FROM ProjectTwo..layoffs_staging2

ALTER TABLE ProjectTwo..layoffs_staging2
DROP COLUMN row_num