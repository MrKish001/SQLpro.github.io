 Select *                    /* Checking all the raw data */
FROM layoffs;

Create Table layoff_staging
Like layoffs
;

Select *                                     /* Creating a duplicte table to work on, preventing the raw data loss */
From layoff_staging
;

Insert layoff_staging
Select *
From layoffs
;

                             /* Finding the Duplicates */         

Select *,
Row_number() Over(Partition By company, industry, total_laid_off, percentage_laid_off, `date` ) As row_num
From layoff_staging
;

With duplicate_cte As
(
Select *,
Row_number() Over(Partition By company, industry, total_laid_off, percentage_laid_off, `date` , stage , country , funds_raised_millions) As row_num
From layoff_staging
)
Select*
From duplicate_cte
Where row_num>1
;

Select*
From layoff_staging                      /* Checking duplicate values */   
Where company = 'Casper'
;



						                 /* Deleting the duplicte data */     
                                         
                                         
                                         
                                         
CREATE TABLE `layoff_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,                        /* Creating new table to delet the duplicate value having  row-num>2*/ 
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


Select * 
From layoff_staging2  
Where row_num > 1            
;

Insert INTO layoff_staging2
Select *,
Row_number() Over(Partition By company, industry, total_laid_off, percentage_laid_off, `date` , stage , country , funds_raised_millions) As row_num
From layoff_staging
;



delete 
From layoff_staging2                     
Where row_num > 1 
;
          
Select * 
From layoff_staging2    
;        

                                                            -- Standardiing data

Select company, trim(company)
From layoff_staging2
;

UPDATE layoff_staging2
SET company = TRIM(company)                      
;

                   
Select Distinct industry
From layoff_staging2
;

Select*
From layoff_staging2
Where industry LIKE "Crypto%"
;
                                                      /* Checking and Updating the column industry*/ 

Update layoff_staging2
SET industry = "Crypto"
Where industry LIKE "Crypto%"
;

                                                      /* Checking and Updating the column country*/ 
                                                      

Select distinct country
From layoff_staging2
;

Select distinct country
From layoff_staging2
Where country LIKE "United State%"
;

Select distinct country, TRIM(TRAILING '.' FROM Country)
From layoff_staging2
Where country LIKE "United State%"
;

Update layoff_staging2
SET country =  TRIM(TRAILING '.' FROM Country)
Where country LIKE "United State%"
;

							-- Changing date type from String to Date
                            
Select `date`,
str_to_date(`date`, '%m/%d/%Y')
From layoff_staging2
;

Update layoff_staging2
SET `date` =  str_to_date(`date`, '%m/%d/%Y')
;

							 -- Dealing with the null and black data
                             
Select *
From layoff_staging2
Where total_laid_off IS NULL
And percentage_laid_off IS NULL
;

Select *
From layoff_staging2
Where industry IS NULL
or industry = ""
;

							-- Deleting the useless data
                            


SELECT *
FROM layoff_staging2
WHERE total_laid_off IS NULL
;


SELECT *
FROM layoff_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;


DELETE FROM layoff_staging
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT * 
FROM layoff_staging2;

ALTER TABLE layoff_staging2
DROP COLUMN row_num;


SELECT * 
FROM layoff_staging2;

							