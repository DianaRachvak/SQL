--student: Diana Rachvak

DROP TABLE IF EXISTS annual_returns CASCADE;
DROP TABLE IF EXISTS avg_top_companies CASCADE;
DROP TABLE IF EXISTS top_companies;


--#2 all annual returns for companies acronyms, sorted by performance
CREATE TABLE temp_table AS
	SELECT acronym, p_date, close AS ending_yr_close
	FROM prices 
	WHERE p_date::text LIKE '%-12-31'
		OR p_date::text LIKE '2011-12-30'
	ORDER BY acronym, p_date;


CREATE TABLE annual_returns AS
	SELECT DISTINCT ON (acronym) *,
		((ending_yr_close/prev_yr_close)-1) * 100 AS annual_returns
	FROM (
		SELECT *,
		LAG(ending_yr_close) OVER (PARTITION BY acronym ORDER BY p_date) AS prev_yr_close
		FROM temp_table
		) AS temp
 	WHERE prev_yr_close IS NOT NULL
	ORDER BY acronym, annual_returns DESC;
DROP TABLE temp_table;


--#3 top 30 companies
CREATE TABLE avg_top_companies AS
	SELECT acronym,
		ROUND(AVG(ending_yr_close)::numeric,2) AS average_prices,
		ROUND(AVG(annual_returns)::numeric,4) AS average_returns
	FROM annual_returns
	GROUP BY acronym
	ORDER BY average_returns DESC LIMIT 30 OFFSET 3;
	
CREATE TABLE top_companies AS
	SELECT *
	FROM annual_returns
	WHERE EXTRACT(YEAR FROM p_date) > 2013
	ORDER BY annual_returns DESC LIMIT 30;
