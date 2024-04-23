/*
Project Three: Data Cleaning

In this project, I will be cleaning the "layoffs" csv file.

The following cleaning will include:
1.) Remove duplicates
2.) Standardize data
3.) NULL/Blank values
4.) Remove any columns that are not needed
*/

-- Looking at the data as a whole (Raw data):

SELECT *
FROM layoffs

-- To make sure we are not altering the raw data, we will create a duplicate table to work with:

SELECT * INTO layoffs_staging
FROM layoffs

-- Now, we can work with the "layoffs_staging" table!

SELECT *
FROM layoffs_staging

-- 1.) Remove duplicates

SELECT *
FROM layoffs_staging