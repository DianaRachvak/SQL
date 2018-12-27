--student: Diana Rachvak

DROP TABLE IF EXISTS census_data CASCADE;
DROP TABLE IF EXISTS target_data CASCADE;
DROP TABLE IF EXISTS rest_of_census;

CREATE TABLE census_data (
	zip_code INTEGER PRIMARY KEY,
	total_population INTEGER,
	median_age FLOAT,
	total_males INTEGER,
	total_females INTEGER,
	total_households INTEGER,
	avg_household_size FLOAT
); 

\COPY census_data FROM '/home/diana/Desktop/census.csv' WITH (FORMAT csv);


CREATE TABLE target_data AS
	SELECT zip_code, total_population, median_age, 
		(total_males::FLOAT)/(total_population::FLOAT) AS pct_male, avg_household_size
	FROM census_data
	WHERE zip_code = 93591;
	
CREATE TABLE rest_of_census AS
	SELECT zip_code, total_population, median_age, 
		(total_males::FLOAT)/(total_population::FLOAT) AS pct_male, avg_household_size
	FROM census_data
	WHERE total_population > 0 AND zip_code != 93591;

	
WITH unformatted_table AS (
	SELECT r.zip_code, r.total_population, r.median_age, r.pct_male, r.avg_household_size, |/((r.median_age - t.median_age)^2 + 
(r.pct_male-t.pct_male)^2 + (r.avg_household_size - t.avg_household_size)^2) 
	AS distance
	FROM rest_of_census r
	CROSS JOIN target_data t
	ORDER BY distance ASC
	LIMIT 10
	)
SELECT ROW_NUMBER() OVER (ORDER BY distance) AS NUM, zip_code, total_population AS total_pop, median_age AS med_age, ROUND(pct_male::numeric, 4) AS pct_male, avg_household_size AS avg_hm_size, ROUND(distance::numeric, 4) AS distance
FROM unformatted_table;
