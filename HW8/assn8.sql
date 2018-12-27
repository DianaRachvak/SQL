--student: Diana Rachvak

DROP TABLE IF EXISTS company CASCADE;
DROP TABLE IF EXISTS company_risk;

CREATE TABLE company (
	id INTEGER PRIMARY KEY,
	industrial_risk char(1),
	management_risk char(1),
	financial_flexibility char(1),
	credibility char(1),
	competitiveness char(1),
	operating_risk char(1),
	class varchar(2)
);


\COPY company FROM '/home/diana/Desktop/ids.csv' WITH (FORMAT csv);


--Generate a "risk score" for each company, by adding 1 point for each 'N' 
--seen in the company's six rating fields. Using a Decision Tree approach,
--classify each company into one of the four groups, based on their risk score.
CREATE TABLE company_risk AS
	WITH company_risk_score AS (
		SELECT id, class,
		SUM(CASE WHEN industrial_risk='N' THEN 1 ELSE 0 END +
			CASE WHEN management_risk='N' THEN 1 ELSE 0 END +
			CASE WHEN financial_flexibility='N' THEN 1 ELSE 0 END +
			CASE WHEN credibility='N' THEN 1 ELSE 0 END +
			CASE WHEN competitiveness='N' THEN 1 ELSE 0 END +
			CASE WHEN operating_risk='N' THEN 1 ELSE 0 END
		) AS risk_score
	FROM company
	GROUP BY id
	)
	SELECT *,
		CASE WHEN risk_score <= 2 THEN 'Low' 
			WHEN risk_score < 4 THEN 'Medium'
			WHEN risk_score < 5 THEN 'Medium-High'
			ELSE 'High'
		END AS risk_level
	FROM company_risk_score;
	

--Report the number of companies at each risk level from the bankrupt group.	
\echo 'Bankrupt companies'
WITH unordered_table AS (
	SELECT risk_level, MAX(risk_score) AS threshold, COUNT(*) AS num_companies
	FROM company_risk
	WHERE class = 'B'
	GROUP BY risk_level
)
SELECT risk_level, num_companies
FROM unordered_table
ORDER BY threshold DESC;


--Report the number of companies at each risk level from the non-bankrupt group.
\echo 'Non-bankrupt companies'
WITH unordered_table AS (
	SELECT risk_level, MAX(risk_score) AS threshold, COUNT(*) AS num_companies
	FROM company_risk
	WHERE class = 'NB'
	GROUP BY risk_level
)
SELECT risk_level, num_companies
FROM unordered_table
ORDER BY threshold DESC;


--Make a report of currently operating companies that are at a risk level 
--of 'Medium' or higher. We will have to monitor these, to make sure 
--we don't get burned if they go bankrupt.
\echo 'Non-bankrupt companies at "Medium" or higher risk level'
SELECT * 
FROM company_risk
WHERE risk_score > 2 AND class = 'NB'
ORDER BY id;
