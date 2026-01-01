-- DATA CLEANING


select *
from layoffs;


create table layoffs_staging
like layoffs;

select *
from layoffs_staging;

insert layoffs_staging
select *
from layoffs;


select *,
row_number() over(partition by company, location, total_laid_off, `date`, percentage_laid_off, industry, `source`, stage, funds_raised, country, date_added) as row_num
from layoffs;


with duplicate_cte as
( select *,
row_number() over(partition by company, location, total_laid_off, `date`, percentage_laid_off, industry, `source`, stage, funds_raised, country, date_added) as row_num
from layoffs)
select *
from duplicate_cte
where row_num >=3;



select company, trim(company)
from layoffs_staging;

update layoffs_staging
set company= trim(company);



select distinct location, trim(trailing',Non-U.S.' from location)
from layoffs_staging
;

update layoffs_staging
set location = trim(trailing',Non-U.S.' from location);



select distinct location 
from layoffs_staging
order by 1;

select `date`
from layoffs_staging
;

update layoffs_staging
set `date`= str_to_date(`date`,'%m/%d/%Y');

alter table layoffs_staging
modify column `date` date;


select  *
from layoffs
where industry is Null 
or industry = '' ;

select *
from layoffs t1
join layoffs t2
    on t1.company = t2.company
where (t1.industry is null or t1.industry = '')
and t2.industry is not null    
 ;

select* 
from layoffs_staging
where total_laid_off  is null =  ' '
and percentage_laid_off is null = ' ';

select*
from layoffs_staging;

alter table layoffs_staging
drop column source;
