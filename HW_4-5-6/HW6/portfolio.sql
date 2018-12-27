--#1
--Backs up "investment" database
--pg_dump -U postgres -d investment > /home/diana/Desktop/backup.sql


--#2 create VIEW of portfolio
DROP TABLE IF EXISTS portfolio CASCADE;
DROP VIEW IF EXISTS recent_prices CASCADE;
DROP TABLE IF EXISTS annual_returns;

CREATE TABLE portfolio (
	acronym char(5) PRIMARY KEY,
	recent_price float
);

INSERT INTO portfolio VALUES
	('DIS', 107.51),
	('AMAT', 60.34),
	('SJM', 110.14),
	('BDX', 314.56),
	('NKE', 111.11),
	('FDX', 209.01),
	('AYI', 123.07),
	('V', 119.02),
	('STZ', 67.88),
	('WRK', 64.22);

	
CREATE VIEW recent_prices AS	
	SELECT DISTINCT ON (pr.acronym) p.acronym, pr.p_date, pr.close
	FROM prices pr
	INNER JOIN portfolio p ON p.acronym = pr.acronym
	ORDER BY pr.acronym, pr.p_date DESC;

SELECT * FROM recent_prices;


--#3 export data into .csv:
--psql -d finance -U postgres -tAF, -f /home/diana/Desktop/portfolio.sql > /home/diana/Desktop/portfolio_output.csv


--#4 Look up the last price of 2017 of each of the equities you chose, 
--and determine the percent return you (your company) would have made 
--on each of them if you had invested in your portfolio on Dec 30, 2016.
CREATE TABLE annual_returns AS
	SELECT p.acronym, rp.close, p.recent_price,
		p.recent_price - rp.close AS diff_price,
		((p.recent_price/rp.close)-1) * 100 AS annual_return
	FROM portfolio p
	INNER JOIN recent_prices rp ON rp.acronym = p.acronym;
	
SELECT acronym, annual_return FROM annual_returns;
SELECT SUM(annual_return) FROM annual_returns;
