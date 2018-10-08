--student: Diana Rachvak


/*
DROP TABLE IF EXISTS boats CASCADE;
DROP TABLE IF EXISTS buyers CASCADE;
DROP TABLE IF EXISTS transactions;

SET client_encoding = 'LATIN1';

CREATE TABLE boats (
	prod_id INTEGER NOT NULL,
	brand TEXT NOT NULL,
	category TEXT,
	cost INTEGER,
	price FLOAT
);

CREATE TABLE buyers (
	cust_id INTEGER NOT NULL,
	fname TEXT,
	lname TEXT,
	city TEXT,
	state TEXT,
	referrer TEXT
);

CREATE TABLE transactions (
	trans_id INTEGER NOT NULL,
	cust_id INTEGER NOT NULL,
	prod_id INTEGER NOT NULL,
	qty INTEGER,
	price FLOAT
);
	


-- Get the data into the database:
\COPY boats FROM '/home/diana/Desktop/boats.csv' WITH (FORMAT csv);
\COPY buyers FROM '/home/diana/Desktop/buyers.csv' WITH (FORMAT csv);
\COPY transactions FROM '/home/diana/Desktop/transactions.csv' WITH (FORMAT csv);
*/




/*Questions and answers*/


--1. We want to spend some advertising money - where should we spend it?
--       I.e., What is our best referral source of buyers?

--there are more than 1 max referrer, so I decided to print them all out in descending order. I hope, that counts:)

\echo 'Best referrers in descending order:'
SELECT referrer, COUNT(*) AS best_referrer 
	FROM buyers
		GROUP BY referrer
		ORDER BY COUNT(*) DESC;

--2. Who of our customers has not bought a boat?
\echo 'Customers who have not bought a boat:'
SELECT b.cust_id, b.fname, b.lname
	FROM buyers b
		WHERE b.cust_id NOT IN (
			SELECT cust_id
			FROM transactions t
			WHERE t.cust_id = b.cust_id
		);

--3. Which boats have not sold?
\echo 'Boats they were never sold:'
SELECT b.prod_id, b.brand
	FROM boats b
		WHERE b.prod_id NOT IN (
			SELECT prod_id
			FROM transactions t
			WHERE t.prod_id = b.prod_id
		);	

--4. What boat did Alan Weston buy?
\echo 'Alan Weston purchased:'
SELECT b.fname, b.lname, bo.brand
	FROM buyers b
		INNER JOIN transactions t ON b.cust_id = t.cust_id
		INNER JOIN boats bo ON bo.prod_id = t.prod_id
		WHERE b.fname = 'Alan' AND b.lname = 'Weston';

--5.  Who are our VIP customers? I.e., Has anyone bought more than one boat?
\echo 'VIP customers:'
SELECT COUNT(t.cust_id) AS bought_times, t.cust_id, b.fname, b.lname
	FROM transactions t
		INNER JOIN buyers b ON t.cust_id = b.cust_id
			GROUP BY t.cust_id, b.fname, b.lname
			HAVING COUNT(t.cust_id) > 1;




























