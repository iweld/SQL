/* 
 * Pizza Runner
 * Case Study #2 Questions
 *  
*/

/*

Clean Data

The customer_order table has inconsistent data types.  We must first clean the data before answering any questions. 
The exclusions and extras columns contain values that are either 'null' (text), null (data type) or '' (empty).
We will create a temporary table where all forms of null will be transformed to '' (empty).

*/

-- The orginal table consist structure

SELECT * FROM customer_orders;

-- Result:

order_id|customer_id|pizza_id|exclusions|extras|order_time             |
--------+-----------+--------+----------+------+-----------------------+
       1|        101|       1|          |      |2020-01-01 18:05:02.000|
       2|        101|       1|          |      |2020-01-01 19:00:52.000|
       3|        102|       1|          |      |2020-01-02 23:51:23.000|
       3|        102|       2|          |      |2020-01-02 23:51:23.000|
       4|        103|       1|4         |      |2020-01-04 13:23:46.000|
       4|        103|       1|4         |      |2020-01-04 13:23:46.000|
       4|        103|       2|4         |      |2020-01-04 13:23:46.000|
       5|        104|       1|null      |1     |2020-01-08 21:00:29.000|
       6|        101|       2|null      |null  |2020-01-08 21:03:13.000|
       7|        105|       2|null      |1     |2020-01-08 21:20:29.000|
       8|        102|       1|null      |null  |2020-01-09 23:54:33.000|
       9|        103|       1|4         |1, 5  |2020-01-10 11:22:59.000|
      10|        104|       1|null      |null  |2020-01-11 18:34:49.000|
      10|        104|       1|2, 6      |1, 4  |2020-01-11 18:34:49.000|
      
CREATE TEMP TABLE new_customer_orders AS (
	SELECT
		order_id,
		customer_id,
		pizza_id,
	CASE
		WHEN exclusions IS NULL
			OR exclusions LIKE 'null' THEN ''
		ELSE exclusions
	END AS exclusions,
	CASE
		WHEN extras IS NULL
			OR extras LIKE 'null' THEN ''
		ELSE extras
	END AS extras,
		order_time
FROM
	customer_orders
);
      
SELECT * FROM new_customer_orders;

-- Result:
	
order_id|customer_id|pizza_id|exclusions|extras|order_time             |
--------+-----------+--------+----------+------+-----------------------+
       1|        101|       1|          |      |2020-01-01 18:05:02.000|
       2|        101|       1|          |      |2020-01-01 19:00:52.000|
       3|        102|       1|          |      |2020-01-02 23:51:23.000|
       3|        102|       2|          |      |2020-01-02 23:51:23.000|
       4|        103|       1|4         |      |2020-01-04 13:23:46.000|
       4|        103|       1|4         |      |2020-01-04 13:23:46.000|
       4|        103|       2|4         |      |2020-01-04 13:23:46.000|
       5|        104|       1|          |1     |2020-01-08 21:00:29.000|
       6|        101|       2|          |      |2020-01-08 21:03:13.000|
       7|        105|       2|          |1     |2020-01-08 21:20:29.000|
       8|        102|       1|          |      |2020-01-09 23:54:33.000|
       9|        103|       1|4         |1, 5  |2020-01-10 11:22:59.000|
      10|        104|       1|          |      |2020-01-11 18:34:49.000|
      10|        104|       1|2, 6      |1, 4  |2020-01-11 18:34:49.000|
      
/*

Clean Data

The runner_order table has inconsistent data types.  We must first clean the data before answering any questions. 
The distance and duration columns have text and numbers.  We will remove the text values and convert to numeric values.
We will convert all 'null' (text) and 'NaN' values in the cancellation column to null (data type).
We will convert the pickup_time (varchar) column to a timestamp data type.

*/

-- The orginal table consist structure
      
SELECT * FROM runner_orders;

-- Result:

order_id|runner_id|pickup_time        |distance|duration  |cancellation           |
--------+---------+-------------------+--------+----------+-----------------------+
       1|        1|2020-01-01 18:15:34|20km    |32 minutes|                       |
       2|        1|2020-01-01 19:10:54|20km    |27 minutes|                       |
       3|        1|2020-01-03 00:12:37|13.4km  |20 mins   |                       |
       4|        2|2020-01-04 13:53:03|23.4    |40        |                       |
       5|        3|2020-01-08 21:10:57|10      |15        |                       |
       6|        3|null               |null    |null      |Restaurant Cancellation|
       7|        2|2020-01-08 21:30:45|25km    |25mins    |null                   |
       8|        2|2020-01-10 00:15:02|23.4 km |15 minute |null                   |
       9|        2|null               |null    |null      |Customer Cancellation  |
      10|        1|2020-01-11 18:50:20|10km    |10minutes |null                   |

DROP TABLE IF EXISTS new_runner_orders;
CREATE TEMP TABLE new_runner_orders AS (
SELECT
		order_id,
		runner_id,
		CASE
			WHEN pickup_time LIKE 'null' THEN NULL
		ELSE pickup_time
	END::timestamp AS pickup_time,
	-- Return null value if both arguments are equal
	-- Use regex to match only numeric values and decimal point.
	-- Convert to numeric datatype
		NULLIF(regexp_replace(distance, '[^0-9.]', '', 'g'), '')::NUMERIC AS distance,
		NULLIF(regexp_replace(duration, '[^0-9.]', '', 'g'), '')::NUMERIC AS duration,
		CASE
			WHEN cancellation LIKE 'null'
				OR cancellation LIKE 'NaN' 
				OR cancellation LIKE '' THEN NULL
		ELSE cancellation
	END AS cancellation
FROM
	runner_orders
);

SELECT * FROM new_runner_orders;

-- Result:

order_id|runner_id|pickup_time            |distance|duration|cancellation           |
--------+---------+-----------------------+--------+--------+-----------------------+
       1|        1|2020-01-01 18:15:34.000|      20|      32|                       |
       2|        1|2020-01-01 19:10:54.000|      20|      27|                       |
       3|        1|2020-01-03 00:12:37.000|    13.4|      20|                       |
       4|        2|2020-01-04 13:53:03.000|    23.4|      40|                       |
       5|        3|2020-01-08 21:10:57.000|      10|      15|                       |
       6|        3|                       |        |        |Restaurant Cancellation|
       7|        2|2020-01-08 21:30:45.000|      25|      25|                       |
       8|        2|2020-01-10 00:15:02.000|    23.4|      15|                       |
       9|        2|                       |        |        |Customer Cancellation  |
      10|        1|2020-01-11 18:50:20.000|      10|      10|                       |
      
-- 1. How many pizzas were ordered?
      
SELECT
	count(*) AS n_orders
FROM
	new_customer_orders;

-- Result:

n_orders|
--------+
      14|

-- 2. How many unique customer orders were made?
   
SELECT
	count(DISTINCT order_id) AS n_orders
FROM
	new_customer_orders;

-- Result:

n_orders|
--------+
      10|
      
-- 3. How many successful orders were delivered by each runner?

SELECT
	runner_id,
	count(order_id) AS n_orders
FROM
	new_runner_orders
WHERE
	cancellation IS NULL
GROUP BY
	runner_id
ORDER BY
	n_orders DESC;

-- Result:

runner_id|n_orders|
---------+--------+
        1|       4|
        2|       3|
        3|       1|
        
-- 4. How many of each type of pizza was delivered?
        
SELECT
	p.pizza_name,
	count(c.*) AS n_pizza_type
FROM
	new_customer_orders AS c
JOIN pizza_names AS p
ON
	p.pizza_id = c.pizza_id
JOIN new_runner_orders AS r
ON
	c.order_id = r.order_id
WHERE
	cancellation IS NULL
GROUP BY
	p.pizza_name
ORDER BY
	n_pizza_type DESC;

-- Result:
       
pizza_name|n_pizza_type|
----------+------------+
Meatlovers|           9|
Vegetarian|           3|      
        
        
-- 5. How many Vegetarian and Meatlovers were ordered by each customer?

SELECT
	customer_id,
	sum(
		CASE
			WHEN pizza_id = 1 THEN 1 
			ELSE 0
		END
	) AS meat_lovers,
	sum(
		CASE
			WHEN pizza_id = 2 THEN 1 
			ELSE 0
		END
	) AS vegetarian
FROM
	new_customer_orders
GROUP BY
	customer_id
ORDER BY customer_id;

-- Result:

customer_id|meat_lovers|vegetarian|
-----------+-----------+----------+
        101|          2|         1|
        102|          2|         1|
        103|          3|         1|
        104|          3|         0|
        105|          0|         1|
        
        
-- 6. What was the maximum number of pizzas delivered in a single order?       
        
        
        
        
        
        
        
        
        
        
        
      