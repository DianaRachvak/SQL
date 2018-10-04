--student: Diana Rachvak

--1. What are the top ten countries by economic activity (Gross National Product - ‘gnp’).
SELECT gnp AS top_ten_gnp FROM country ORDER BY gnp desc LIMIT 10;


--2. What are the top ten countries by GNP per capita?
SELECT gnp AS top_gnp_per_capita FROM country 
	ORDER BY gnp/NULLIF(population, 0) desc LIMIT 10;


--3.  What are the ten most densely populated countries, and ten least
--densely populated countries?
SELECT name, population AS most_populated FROM country
	ORDER BY population desc LIMIT 10;

SELECT name, population AS least_populated FROM country
	ORDER BY population asc LIMIT 10;


--4(1). What different forms of government are represented in this data?
SELECT DISTINCT governmentform AS forms_of_gvmnt FROM country; 

--4(2).  Which forms of government are most frequent? 
SELECT governmentform, COUNT(governmentform) AS frequent_gvmnt_forms
	FROM country	
		GROUP BY governmentform 
			ORDER BY frequent_gvmnt_forms DESC LIMIT 10;


--5.  Which countries have the highest life expectancy?
SELECT name, lifeexpectancy FROM country  
	WHERE lifeexpectancy!=NULL OR lifeexpectancy!=0 		
		ORDER BY lifeexpectancy desc LIMIT 10;


--6.  What are the top ten countries by total population, and what is the official language spoken there? 
--this is first option (will print out only CHINA)
SELECT country.name, country.population, countrylanguage."language" 
	FROM country
		INNER JOIN countrylanguage 
		ON country.code = countrylanguage.countrycode 
			ORDER BY country.population desc LIMIT 10;

--will print 10 different countries
SELECT DISTINCT country.name, country.population, countrylanguage."language"
	FROM country
		INNER JOIN countrylanguage 
		ON country.code = countrylanguage.countrycode LIMIT 10;



--7.  What are the top ten most populated cities – along with which country they are in, and what continent they are on? 
SELECT city.name AS city_name, city.population AS city_population, 
	country.name AS country_name, country.continent 
	FROM city
		INNER JOIN country ON city.countrycode = country.code
		ORDER BY city.population desc LIMIT 10;


--8. What is the official language of the top ten cities you found in Question #7?
SELECT c.name AS city_name, c.population AS city_population,  cl."language", 		co.name AS country_name, co.continent 
		FROM city c
			INNER JOIN country co ON c.countrycode = co.code
			INNER JOIN countrylanguage cl ON c.countrycode = 					cl.countrycode WHERE cl.isofficial = true 
			ORDER BY 2 DESC LIMIT 10;



--9. Which of the cities from Question #7 are capitals of their country?
SELECT c.name AS city_name, c.population AS city_population, 
	co.name AS country_name, co.continent
	FROM city c
		INNER JOIN country co ON c.countrycode = co.code
		WHERE co.capital IN (SELECT capital FROM country) 
		ORDER BY c.population desc LIMIT 10;


--10. For the cities found in Question#9, what percentage of the country’s population lives in the capital city?
SELECT c.name AS city_name, co.name AS country_name, co.continent, 
	c.population AS city_population, 
	((CAST(c.population AS float)/co.population)*100):: NUMERIC(10,2) 
		AS pct_capital_population
	FROM city c
		INNER JOIN country co ON c.countrycode = co.code
		WHERE co.capital IN (SELECT capital FROM country) 
		ORDER BY c.population desc LIMIT 10;
























	 		
