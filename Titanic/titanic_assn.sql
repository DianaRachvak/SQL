/*  DBase Assn 1:

    Passengers on the Titanic:
        1,503 people died on the Titanic.
        - around 900 were passengers, 
        - the rest were crew members.

    This is a list of what we know about the passengers.
    Some lists show 1,317 passengers, 
        some show 1,313 - so these numbers are not exact, 
        but they will be close enough that we can spot trends and correlations.

    Lets' answer some questions about the passengers' survival data: 
 */

-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- DELETE OR COMMENT-OUT the statements in section below after running them ONCE !!
-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


/*  Create the table and get data into it: */
/*
DROP TABLE IF EXISTS passengers;

CREATE TABLE passengers (
    id INTEGER NOT NULL,
    lname TEXT,
    title TEXT,
    class TEXT, 
    age FLOAT,
    sex TEXT,
    survived INTEGER,
    code INTEGER
);

-- Now get the data into the database:
\COPY passengers FROM '/home/diana/Desktop/titanic.csv' WITH (FORMAT csv);
*/
-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- DELETE OR COMMENT-OUT the statements in the above section after running them ONCE !!
-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


/* Some queries to get you started:  */


-- How many total passengers?:
SELECT COUNT(*) AS total_passengers FROM passengers;


-- How many survived?
SELECT COUNT(*) AS survived FROM passengers WHERE survived=1;


-- How many died?
SELECT COUNT(*) AS did_not_survive FROM passengers WHERE survived=0;


-- How many were female? Male?
SELECT COUNT(*) AS total_females FROM passengers WHERE sex='female';
SELECT COUNT(*) AS total_males FROM passengers WHERE sex='male';


-- How many total females died?  Males?
SELECT COUNT(*) AS no_survived_females FROM passengers WHERE sex='female' AND survived=0;
SELECT COUNT(*) AS no_survived_males FROM passengers WHERE sex='male' AND survived=0;


-- Percentage of females of the total?
SELECT 
    SUM(CASE WHEN sex='female' THEN 1.0 ELSE 0.0 END) / 
        CAST(COUNT(*) AS FLOAT)*100 
            AS tot_pct_female 
FROM passengers;


-- Percentage of males of the total?
SELECT 
    SUM(CASE WHEN sex='male' THEN 1.0 ELSE 0.0 END) / 
        CAST(COUNT(*) AS FLOAT)*100 
            AS tot_pct_male 
FROM passengers;


-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- %%%%%%%%%% Write queries that will answer the following questions:  %%%%%%%%%%%
-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

--student: Diana Rachvak

-- 1.  What percent of passengers survived? (total)
	SELECT 
	    SUM(CASE WHEN survived = 1 THEN 1.0 ELSE 0.0 END)/
		CAST(COUNT(*) AS FLOAT)*100 
		    AS pct_passengers_survived 
	FROM passengers;

-- 2.  What percentage of females survived?     (female_survivors / tot_females)
	SELECT 
	    SUM(CASE WHEN sex='female' AND survived = 1 THEN 1.0 ELSE 0.0 END) / 
		CAST(COUNT(CASE WHEN sex = 'female' THEN 1.0 ELSE 0.0 END) AS FLOAT)*100 
		    AS pct_female_survived 
	FROM passengers;

-- 3.  What percentage of males that survived?      (male_survivors / tot_males)
	SELECT 
	    SUM(CASE WHEN sex='male' AND survived = 1 THEN 1.0 ELSE 0.0 END) / 
		CAST(COUNT(CASE WHEN sex = 'male' THEN 1.0 ELSE 0.0 END) AS FLOAT)*100 
		    AS pct_male_survived 
	FROM passengers;
	
-- 4.  How many people total were in First class, Second class, Third class, or of class unknown ?
	SELECT COUNT(*) FROM passengers GROUP BY class='1st', class='2nd', class='3rd', 		class=NULL;

-- 5.  What is the total number of people in First and Second class ?
	SELECT 
		SUM(CASE WHEN class='1st' OR class='2nd' THEN 1 ELSE 0 END) 
		AS classes_1_and_2
	FROM passengers;

-- 6.  What are the survival percentages of the different classes? (3).
	SELECT
		(SUM(CASE WHEN class='1st' THEN 1.0 ELSE 0.0 END) / 
			CAST(COUNT(*) AS FLOAT)*100)::NUMERIC(5,2) 
		AS first_class,
		(SUM(CASE WHEN class='2nd' THEN 1.0 ELSE 0.0 END) / 
			CAST(COUNT(*) AS FLOAT)*100)::NUMERIC(5,2) 
		AS second_class,
		(SUM(CASE WHEN class='3rd' THEN 1.0 ELSE 0.0 END) / 
			CAST(COUNT(*) AS FLOAT)*100)::NUMERIC(5,2)
		AS third_class,
		(SUM(CASE WHEN class=NULL THEN 1.0 ELSE 0.0 END) / 
			CAST(COUNT(*) AS FLOAT)*100)::NUMERIC(5,2)
		AS unknown_class
	FROM passengers;

-- 7.  Can you think of other interesting questions about this dataset?
--      I.e., is there anything interesting we can learn from it?  
--      Try to come up with at least two new questions we could ask.

--      Example:
--      Can we calcualte the odds of survival if you are a female in Second Class?

--      Could we compare this to the odds of survival if you are a female in First Class?
--      If we can answer this question, is it meaningful?  Or just a coincidence ... ?


--	I considered interesting to find out: 
--	1. How many women women were in 1st class and how many of them survived. Then how 
--	many women from 1st class didn't survive.
--	2. Now, after getting answers from the first question, what's the number of women 
--	survived in First Class comparing to all the rest of the survived people on Titanic. 



-- 8.  Can you answer the questions you thought of above?
--      Are you able to write the query to find the answer now?  

--      If so, try to answer the question you proposed.
--      If you aren't able to answer it, try to answer the following:
--      Can we calcualte the odds of survival if you are a female in Second Class?


--	1st
-- These results show us that almost all women in 1st class survived. Thus, we can assume, -- they were a priority

	SELECT 
		SUM(CASE WHEN sex='female' AND class='1st' THEN 1 ELSE 0 END) 
			AS total_women_in1st_class,
		SUM(CASE WHEN class='1st' AND sex='female' AND survived=1 THEN 1 ELSE 0 				END) 
			AS survived_w_in1st_class,
		SUM(CASE WHEN sex='female' AND class='1st' THEN 1 ELSE 0 END)  - 
		SUM(CASE WHEN class='1st' AND sex='female' AND survived=1 THEN 1 ELSE 0 				END)
			AS women_in1st_class_died
	FROM passengers;


--	2nd
--These results show us there were only a little bit more than twice of the passengers 
--survived comparing to survived women in 1st class. 

	SELECT 
		SUM(CASE WHEN class='1st' AND sex='female' AND survived=1 THEN 1 ELSE 0 				END) 
			AS survived_women_in_1st_class,
		SUM(CASE WHEN survived=1 THEN 1 ELSE 0 END) - SUM(CASE WHEN class='1st' 				AND sex='female' AND survived=1 THEN 1 ELSE 0 END)
			AS rest_of_passengers_survived
	FROM passengers;



