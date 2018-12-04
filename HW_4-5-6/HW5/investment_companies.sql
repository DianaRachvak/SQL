--student: Diana Rachvak

DROP TABLE IF EXISTS highest_performers CASCADE;
DROP TABLE IF EXISTS potential_candidates;


CREATE TABLE highest_performers AS
	SELECT *, EXTRACT(YEAR FROM p_date)-1 AS previous_year
	FROM top_companies;
	
	
	
--PART ONE--

--High net worth growth year-over-year	
SELECT h.acronym, h.annual_returns, h.previous_year, 
		f.total_assets - f.total_liabilities AS net_worth
FROM fundamentals as f
INNER JOIN highest_performers h on f.acronym = h.acronym
WHERE h.previous_year = f.f_year
ORDER BY net_worth DESC;


--High net income growth year-over-year
SELECT h.acronym, h.annual_returns, h.previous_year, 
		fundamentals.net_income, fundamentals.prev_year_income,
		((fundamentals.net_income/fundamentals.prev_year_income)-1) * 100 
			AS net_income_growth_yoy
FROM (
	SELECT *,
	LAG(net_income) OVER (PARTITION BY acronym ORDER BY f_year) AS prev_year_income
	FROM fundamentals
) AS fundamentals
INNER JOIN highest_performers h on fundamentals.acronym = h.acronym
WHERE h.previous_year = fundamentals.f_year AND	prev_year_income IS NOT NULL
ORDER BY net_income_growth_yoy DESC;


--High revenue growth year-over-year
SELECT h.acronym, h.annual_returns, h.previous_year, 
		fundamentals.total_revenue, fundamentals.prev_year_revenue,
		((fundamentals.total_revenue/fundamentals.prev_year_revenue)-1)*100
			AS revenue_growth_yoy
FROM (
	SELECT *,
	LAG(total_revenue) OVER (PARTITION BY acronym ORDER BY f_year) AS prev_year_revenue
	FROM fundamentals
) AS fundamentals
INNER JOIN highest_performers h on fundamentals.acronym = h.acronym
WHERE h.previous_year = fundamentals.f_year AND	prev_year_revenue IS NOT NULL
ORDER BY revenue_growth_yoy DESC;


--High earnings-per-share (eps) growth
SELECT h.acronym, h.annual_returns, h.previous_year, 
		fundamentals.earnings_per_share, fundamentals.prev_year_eps,
		((fundamentals.earnings_per_share/fundamentals.prev_year_eps)-1) * 100 
			AS eps_growth
FROM (
	SELECT *,
	LAG(earnings_per_share) OVER (PARTITION BY acronym ORDER BY f_year) AS prev_year_eps
	FROM fundamentals
) AS fundamentals
INNER JOIN highest_performers h on fundamentals.acronym = h.acronym
WHERE h.previous_year = fundamentals.f_year AND	prev_year_eps IS NOT NULL
ORDER BY eps_growth DESC;


--Low price-to-earnings ratio 
SELECT h.acronym, h.annual_returns, h.previous_year, h.prev_yr_close AS price, 
		f.earnings_per_share AS eps,
		h.prev_yr_close/f.earnings_per_share AS price_to_earnings_ratio
FROM fundamentals f
INNER JOIN highest_performers h on f.acronym = h.acronym
WHERE h.previous_year = f.f_year
ORDER BY price_to_earnings_ratio;


--Amount of liquid cash in the bank vs. total liabilities
SELECT h.acronym, h.annual_returns, h.previous_year, f.cash_and_cash_equivalents AS cash, 
		f.total_liabilities AS liabilities,
		f.cash_and_cash_equivalents/f.total_liabilities AS cash_to_liabilities
FROM fundamentals f
INNER JOIN highest_performers h on f.acronym = h.acronym
WHERE h.previous_year = f.f_year
ORDER BY cash_to_liabilities DESC;


--Finds gross margin
SELECT h.acronym, h.annual_returns, h.previous_year, f.gross_margin
FROM fundamentals f
INNER JOIN highest_performers h on f.acronym = h.acronym
WHERE h.previous_year = f.f_year
ORDER BY gross_margin DESC;



--PART TWO--

--find the top 25-30 companies that have the most similar fundamental factors to your 
--highperformers for the year 2016
CREATE TABLE potential_candidates AS
	SELECT acronym, gross_margin,
		round(((total_revenue/prev_year_revenue)-1) * 100, 10) AS revenue_growth,
		round(cash_and_cash_equivalents/total_liabilities, 10) AS cash_to_liabilities,
		total_assets - total_liabilities AS net_worth
	FROM (
		SELECT *,
		LAG(total_revenue) OVER (PARTITION BY acronym ORDER BY f_year) 
			AS prev_year_revenue
		FROM fundamentals
	) AS temp
	WHERE f_year = 2016 AND	gross_margin > 15 AND
		((total_revenue/prev_year_revenue)-1) * 100 > 3 AND
		cash_and_cash_equivalents/total_liabilities > 0
	ORDER BY net_worth DESC	LIMIT 30;
	
	
	
--PART THREE--

--From this list of potential candidates, select ten companies to invest in:
SELECT DISTINCT s.sector, p.acronym, s.company, p.net_worth
FROM potential_candidates p
INNER JOIN securities s ON s.acronym = p.acronym
ORDER BY net_worth DESC LIMIT 10;

