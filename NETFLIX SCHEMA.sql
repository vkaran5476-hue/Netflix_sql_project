-- netflis Porject 
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
	
	show_id VARCHAR(10),
	type  VARCHAR(20),
	title VARCHAR(150),
	director  VARCHAR(250),
	castS    VARCHAR(1050),
	country  VARCHAR(150),
	date_added VARCHAR(50),
	release_year INT,
	rating VARCHAR(10),
	duration  VARCHAR(10),
	listed_in VARCHAR(150),
	description VARCHAR(300)

 );

 SELECT * FROM netflix;

 SELECT 
 	COUNT(*) as total_content
 FROM netflix;


 -- SELECT 
 -- 	DISTINCT type
 -- FROM netflix;

 -- SELECT 
 -- 	DISTINCT director
 -- FROM netflix;

 -- SELECT 
 -- 	DISTINCT casts
 -- FROM netflix;

 --  15 BUSINESS PROBLEMS

 -- 1 COUNT THE NUMBER OF MOVIE AND TV SHOWS
 SELECT 
  		type,
		COUNT (*) as total_content

FROM netflix
GROUP BY type


-- 2 FIND THE MOST COMMON RATING FOR MOVIES AND TV SHOWS


SELECT 
 	type,
	 rating
FROM 

(
SELECT
	type,
	rating, 
	count (*),
	RANK() OVER (PARTITION BY type ORDER BY count(*) DESC) as ranking
	-- MAX(rating)
FROM netflix 
GROUP BY 1 ,2
ORDER BY 1, 3 DESC

) as t1
WHERE 
ranking  = 1

-- 3 list all movies released in a specific year (2020)

SELECT * FROM netflix

WHERE 
	type = 'MOVIE'
	AND 
	release_year = 2020

-- 4 find the top 5 countries with the most content pn netflix

SELECT 
	 UNNEST(STRING_TO_ARRAY(country, ',')) AS new_country,
	 COUNT (show_id) AS total_content
	
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

SELECT 
	-- STRING_TO_ARRAY(country, ',') as new_countr
	 UNNEST(STRING_TO_ARRAY(country, ',')) AS new_country
FROM netflix

-- 5 indentify the longest movie

SELECT * FROM netflix
WHERE 
	type ='Movie'
	AND
	duration = (SELECT MAX (duration) FROM netflix)

-- 6 find content add in the last 5 years

SELECT 
	*
	-- TO_DATE(date_added,'MONTH DD, YYYY')
FROM netflix
WHERE 
	TO_DATE(date_added,'MONTH DD, YYYY') >= CURRENT_DATE -INTERVAL '5 years';

SELECT CURRENT_DATE - INTERVAL '5 years';



-- 7 find all the movies/ tv shows by director ' Rajiv CHilaka':


SELECT * FROM netflix
WHERE director LIKE '%Rajiv Chilaka%'
-- WHERE director = 'Rajiv Chilaka'


-- 8. List all TV shows with more than 5 seasons

SELECT *
FROM netflix
WHERE 
	TYPE = 'TV Show'
	AND
	SPLIT_PART(duration, ' ', 1)::INT > 5


-- 9. Count the number of content items in each genre

SELECT 
	UNNEST(STRING_TO_ARRAY(listed_in, ',')) as genre,
	COUNT(*) as total_content
FROM netflix
GROUP BY 1


-- 10. Find each year and the average numbers of content release by India on netflix. 
-- return top 5 year with highest avg content release !


SELECT 
	country,
	release_year,
	COUNT(show_id) as total_release,
	ROUND(
		COUNT(show_id)::numeric/
								(SELECT COUNT(show_id) FROM netflix WHERE country = 'India')::numeric * 100 
		,2
		)
		as avg_release
FROM netflix
WHERE country = 'India' 
GROUP BY country, 2
ORDER BY avg_release DESC 
LIMIT 5


-- 11. List all movies that are documentaries
SELECT * FROM netflix
WHERE listed_in LIKE '%Documentaries'



-- 12. Find all content without a director
SELECT * FROM netflix
WHERE director IS NULL


-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!

SELECT * FROM netflix
WHERE 
	casts LIKE '%Salman Khan%'
	AND 
	release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10


-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.



SELECT 
	UNNEST(STRING_TO_ARRAY(casts, ',')) as actor,
	COUNT(*)
FROM netflix
WHERE country = 'India'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10

/*
Question 15:
Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.
*/


SELECT 
    category,
	TYPE,
    COUNT(*) AS content_count
FROM (
    SELECT 
		*,
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix
) AS categorized_content
GROUP BY 1,2
ORDER BY 2




-- End of reports

