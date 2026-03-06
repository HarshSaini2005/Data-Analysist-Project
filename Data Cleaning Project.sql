-- Data Cleaning 

# useful  format to clean the raw data for data vis. 

use world_layoffs ; 
select * 
from layoffs
;

-- 1 . Remove duplicates
-- 2. Standardize the data
-- 3. Null values or blank values 
-- 4.  Remove any columns 

CREATE TABLE layoffs_staging 
LIKE layoffs ; 

SELECT * 
FROM layoffs_staging ; 

INSERT layoffs_staging
SELECT * 
from layoffs;

-- Duplicate 
WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER (PARTITION BY  company , industry , total_laid_off , `date`,stage , country , funds_raised_millions ) AS row_num
FROM layoffs_staging 
)
SELECT * 
FROM duplicate_cte 
WHERE row_num > 1 ; 

SELECT * 
FROM layoffs_staging
WHERE company = 'Casper'
;

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER (PARTITION BY  company , industry , total_laid_off , `date`,stage , country , funds_raised_millions ) AS row_num
FROM layoffs_staging 
)
DELETE
FROM duplicate_cte 
WHERE row_num > 1 ; 

SELECT *,
ROW_NUMBER() OVER (PARTITION BY  company , industry , total_laid_off , `date`,stage , country , funds_raised_millions ) AS row_num
FROM layoffs_staging ;


CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num`INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


SELECT * 
FROM layoffs_staging2
WHERE row_num >1  ; 


INSERT layoffs_staging2
SELECT *,
ROW_NUMBER() OVER (PARTITION BY  company , 
industry ,
 total_laid_off , `date`,stage ,
 country , funds_raised_millions ) 
AS row_num
FROM layoffs_staging ;

SET SQL_SAFE_UPDATES = 0;

DELETE
FROM layoffs_staging2
WHERE row_num >1  ;

SELECT * 
FROM layoffs_staging2
WHERE row_num >1  ; 

-- Standardizing data 

SELECT company , TRIM(company)
FROM layoffs_staging2
;

UPDATE layoffs_staging2
SET company = TRIM(company) ;

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'crypto%'
;

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'crypto%'
;

SELECT distinct industry
FROM layoffs_staging2
;

SELECT distinct location
FROM layoffs_staging2
order by 1 
;

SELECT distinct country , TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
order by 1 
;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'united states%'
;

SELECT `date`,
str_to_date(`date`,'%m/%d/%Y')
FROM  layoffs_staging2 ;

UPDATE  layoffs_staging2
set `date`= str_to_date(`date`,'%m/%d/%Y') ;

ALTER TABLE  layoffs_staging2
MODIFY COLUMN `date` DATE ;

SELECT `date`
from  layoffs_staging2 ;

SELECT *
from  layoffs_staging2 ;

-- NULL VALUES 
SELECT *
from  layoffs_staging2 
WHERE total_laid_off IS  NULL
AND percentage_laid_off IS NULL  ;

UPDATE layoffs_staging2
SET  industry = NULL 
WHERE industry = '' ;

SELECT *
from  layoffs_staging2
WHERE industry IS NULL
OR industry = '' ;

SELECT t1.industry , t2.industry
from  layoffs_staging2 t1
join layoffs_staging2 t2
     on t1.company = t2.company
where (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT null ;


UPDATE  layoffs_staging2 t1
join layoffs_staging2 t2
     SET t1.industry = t2.industry
where  t1.industry IS NULL 
AND t2.industry IS NOT null ;

SELECT *
from  layoffs_staging2 
WHERE total_laid_off IS  NULL
AND percentage_laid_off IS NULL  ;


DELETE 
from  layoffs_staging2 
WHERE total_laid_off IS  NULL
AND percentage_laid_off IS NULL  ;

SELECT * 
FROM layoffs_staging2 ;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num ;

UPDATE layoffs_staging2 
SET total_laid_off = 0 
WHERE total_laid_off IS  NULL
 ;

SELECT * 
FROM layoffs_staging2 ;

UPDATE layoffs_staging2 
SET percentage_laid_off = 0 
WHERE percentage_laid_off IS  NULL
 ;
 
 SELECT * 
FROM layoffs_staging2 ;