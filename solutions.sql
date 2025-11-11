--Netflix Porject
DROP TABLE IF EXISTS netflixx;
CREATE TABLE netflixx(
	show_id	 varchar(6),
	type	 varchar(10),
	title	 varchar(150),
	director varchar(210),	
	casts	 varchar(1000),
	country	 varchar(150),
    date_added	varchar(50),
	release_year int not null,	
	rating	 varchar(10),
    duration	varchar(10),
	listed_in	varchar(100),
	description varchar(250)
)

select * from netflixx;

select count(*) 
as total_content 
from netflixx;

select count(distinct director) as total_directors 
from netflixx
where director is not null ;

-- 15 business problem 

-- 1. Count the number of Movies vs TV Shows

select type, count(*)
from netflixx
group by type;


-- 2. Find the most common rating for movies and TV shows

select type, count(rating)
from netflixx
group by rating;

-- 3. List all movies released in a specific year (e.g., 2020)

select *
from netflixx
where type = 'Movie'
and release_year = 2020;


-- 4. Find the top 5 countries with the most content on Netflix


select  
	unnest(string_to_array(country, ',')) as new_country,
	 count(show_id) as total_content
	 from netflixx
	 group by new_country
	 order by total_content desc limit 5;


-- 5. Identify the longest movie

select * from netlixx
where 
	type = 'Movie'
	and
	duration =(select MAX(duration) from netflixx);


-- 6. Find content added in the last 5 years

select 
* , to_date(date_added,'Month DD, YYYY ')
from netflixx
where to_date(date_added,'Month DD, YYYY') >= current_date - interval '5 years';

-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

select type,title,director from netflixx
where director ILIKE '%Rajiv Chilaka%';  


-- 8. List all TV shows with more than 5 seasons

select 
	*
from netflixx
where 
	type = 'TV Show' and
	SPLIT_PART(duration, ' ', 1)::numeric > 5;  

-- 9. Count the number of content items in each genre

select
	UNNEST (STRING_TO_ARRAY(listed_in, ',')) AS genre,
	COUNT(show_id) as total_content
from netflixx
group by 1; 

-- 10.Find each year and the average numbers of content release in India on netflix. 
-- return top 5 year with highest avg content release!

select 
	 EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY'))as date,
	COUNT(*) yearly_content,
	ROUND
	(COUNT(*)::numeric/(select count(*) from netflixx where country ='India') * 100 
	,2)as avg_content_per_year
from netflixx
where country = 'India'
group by 1; 


-- 11. List all movies that are documentaries

select * from netflixx
where
listed_in ILIKE '%Documentaries%';

-- 12. Find all content without a director

select * from netflixx
where 
	director IS NULL;

-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!

select * from netflixx
where
	casts ilike '%Salman khan%'
	and
	release_year > extract(year from current_date) - 10;

	
-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

select
UNNEST (STRING_TO_ARRAY(casts, ',')) as actor,
count(*) as total_content
from netflixx
where country ILIKE '%India%'
group by 1
order by total_content desc limit 10;



--15.
--Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
--the description field. Label content containing these keywords as 'Bad' and all other 
--content as 'Good'. Count how many items fall into each category.

WITH new_table
as
(
select 
*, 
	CASE
	WHEN
		 description like '%kill%' OR
		 description like '%violence%' THEN 'Bad content'
	     ELSE 'Good content'
	END category
from netflixx
)
select category,
	   COUNT(*) as total_content
from new_table
group by 1
;
	