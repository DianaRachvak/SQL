--student: Diana Rachvak


DROP DATABASE IF EXISTS investment CASCADE;
DROP TABLE IF EXISTS SECURITIES CASCADE;
DROP TABLE IF EXISTS FUNDAMENTALS CASCADE;
DROP TABLE IF EXISTS PRICES;


CREATE DATABASE investment;


CREATE TABLE securities (
	acronym char(5) PRIMARY KEY,
	company text,
	sector text,
	sub_industry text,
	initial_trade_date date
);

CREATE TABLE fundamentals (
	id integer PRIMARY KEY,
	acronym char(5),
	year_ending date,
	cash_and_cash_equivalents decimal,
	earnings_before_interest_and_taxes decimal,
	gross_margin integer,
	net_income decimal,
	total_assets decimal,
	total_liabilities decimal,
	total_revenue decimal,
	f_year integer,
	earnings_per_share float,
	shares_outstanding float
);

CREATE TABLE prices (
	p_date date,
	acronym char(5),
	open float,
	close float,
	low float,
	high float,
	volume integer	
);


\COPY securities FROM '/home/diana/Desktop/securities.csv' WITH (FORMAT csv);
\COPY fundamentals FROM '/home/diana/Desktop/fundamentals.csv' WITH (FORMAT csv);
\COPY prices FROM '/home/diana/Desktop/prices.csv' WITH (FORMAT csv);

