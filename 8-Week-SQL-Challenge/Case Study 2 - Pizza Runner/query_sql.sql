/* 
 * Pizza Runner
 * Case Study #2 Questions
 * Pizza Metrics
 *  
*/

/*

Clean Data

The customer_order table has inconsistent data types.  We must first clean the data before answering any questions. 
The exclusions and extras columns contain values that are either 'null' (text), null (data type) or '' (empty).
We will create a temporary table where all forms of null will be transformed to null (data type).

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

DROP TABLE IF EXISTS new_customer_orders;
CREATE TEMP TABLE new_customer_orders AS (
	SELECT
		order_id,
		customer_id,
		pizza_id,
	CASE
		WHEN exclusions = ''
			OR exclusions LIKE 'null' THEN null
		ELSE exclusions
	END AS exclusions,
	CASE
		WHEN extras = ''
			OR extras LIKE 'null' THEN null
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
        
WITH cte_order_count AS (
	SELECT	
		c.order_id,
		count(c.pizza_id) AS n_orders
	FROM new_customer_orders AS c
	JOIN new_runner_orders AS r
	ON c.order_id = r.order_id
	WHERE
		r.cancellation IS NULL
	GROUP BY c.order_id
)

SELECT
	max(n_orders) AS max_n_orders
FROM cte_order_count;

-- Result:

max_n_orders|
------------+
           3|
           
-- 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

SELECT
	c.customer_id,
	sum(
		CASE
			WHEN c.exclusions IS NOT NULL 
				OR c.extras IS NOT NULL THEN 1
			ELSE 0
		END
	) AS has_changes,
	sum(
		CASE
			WHEN c.exclusions IS NULL 
				OR c.extras IS NULL THEN 1
			ELSE 0
		END
	) AS no_changes
FROM
	new_customer_orders AS c
JOIN new_runner_orders AS r
ON c.order_id = r.order_id
WHERE
	r.cancellation IS NULL
GROUP BY
	c.customer_id
ORDER BY
	c.customer_id;
        
-- Result:

customer_id|has_changes|no_changes|
-----------+-----------+----------+
        101|          0|         2|
        102|          0|         3|
        103|          3|         3|
        104|          2|         2|
        105|          1|         1|
        
-- 8. How many pizzas were delivered that had both exclusions and extras?
        
SELECT
	sum(
		CASE
			WHEN c.exclusions IS NOT NULL 
				and c.extras IS NOT NULL THEN 1
			ELSE 0
		END
	) AS n_pizzas
FROM new_customer_orders AS c
JOIN new_runner_orders AS r
ON c.order_id = r.order_id
WHERE r.cancellation IS NULL;

-- Result:
        
n_pizzas|
--------+
       1|      
        
-- 9. What was the total volume of pizzas ordered for each hour of the day?

SELECT
	extract(hour FROM order_time::timestamp) AS hour_of_day,
	count(*) AS n_pizzas
FROM new_customer_orders
WHERE order_time IS NOT NULL
GROUP BY hour_of_day
ORDER BY hour_of_day;

-- Result:
       
hour_of_day|n_pizzas|
-----------+--------+
       11.0|       1|
       13.0|       3|
       18.0|       3|
       19.0|       1|
       21.0|       3|
       23.0|       3|  
       
-- 10. What was the volume of orders for each day of the week?

SELECT
	to_char(order_time, 'Day') AS day_of_week,
	count(*) AS n_pizzas
FROM new_customer_orders
GROUP BY day_of_week
ORDER BY day_of_week;

-- Result:

day_of_week|n_pizzas|
-----------+--------+
Friday     |       1|
Saturday   |       5|
Thursday   |       3|
Wednesday  |       5| 

/* 
 * Pizza Runner
 * Case Study #2 Questions
 * Runner and Customer Experience
 *  
*/
       
-- 1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01) 
 
SELECT
	starting_week,
	count(runner_id) AS n_runners
from
	(SELECT
		runner_id,
		registration_date,
		registration_date - ((registration_date - '2021-01-01') % 7) AS starting_week
	FROM runners) AS signups
GROUP BY starting_week
ORDER BY starting_week;

-- Result:

starting_week|n_runners|
-------------+---------+
   2021-01-01|        2|
   2021-01-08|        1|
   2021-01-15|        1|

-- 2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

SELECT
	runner_id,
	extract('minutes' FROM avg(runner_arrival_time)) AS avg_arrival_time
from
	(SELECT
		r.runner_id,
		r.order_id,
		r.pickup_time,
		c.order_time,
		(r.pickup_time - c.order_time) AS runner_arrival_time
	FROM new_runner_orders AS r
	JOIN new_customer_orders AS c
	ON r.order_id = c.order_id) AS runner_time
GROUP BY runner_id
ORDER BY runner_id;
	
-- Result:  
   
runner_id|avg_arrival_time|
---------+----------------+
        1|            15.0|
        2|            23.0|
        3|            10.0|   
   
-- 3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
        
WITH number_of_pizzas AS (
	SELECT	
		order_id,
		order_time,
		count(pizza_id) AS n_pizzas
	FROM new_customer_orders
	GROUP BY 
		order_id,
		order_time	
),
preperation_time AS (
	SELECT
		r.runner_id,
		r.pickup_time,
		n.order_time,
		n.n_pizzas,
		(r.pickup_time - n.order_time) AS runner_arrival_time
	FROM new_runner_orders AS r
	JOIN number_of_pizzas AS n
	ON r.order_id = n.order_id
	WHERE r.pickup_time IS NOT null
)

SELECT
	n_pizzas,
	avg(runner_arrival_time) AS avg_order_time
FROM preperation_time
GROUP BY n_pizzas
ORDER BY n_pizzas;

-- Result:

n_pizzas|avg_order_time|
--------+--------------+
       1|    00:12:21.4|
       2|    00:18:22.5|
       3|      00:29:17|
       
-- 4a. What was the average distance travelled for each customer?

SELECT
	c.customer_id,
	floor(avg(r.distance)) AS avg_distance_rounded_down,
	round(avg(r.distance), 2) AS avg_distance,
	ceil(avg(r.distance)) AS avg_distance_rounded_up
FROM new_runner_orders AS r
JOIN new_customer_orders AS c
ON c.order_id = r.order_id
GROUP BY customer_id
ORDER BY customer_id;

-- Result:

customer_id|avg_distance_rounded_down|avg_distance|avg_distance_rounded_up|
-----------+-------------------------+------------+-----------------------+
        101|                       20|       20.00|                     20|
        102|                       16|       16.73|                     17|
        103|                       23|       23.40|                     24|
        104|                       10|       10.00|                     10|
        105|                       25|       25.00|                     25|
             
-- 4b. What was the average distance travelled for each runner?

SELECT
	runner_id,
	floor(avg(distance)) AS avg_distance_rounded_down,
	round(avg(distance), 2) AS avg_distance,
	ceil(avg(distance)) AS avg_distance_rounded_up
FROM new_runner_orders
GROUP BY runner_id
ORDER BY runner_id;       

-- Result:
       
runner_id|avg_distance_rounded_down|avg_distance|avg_distance_rounded_up|
---------+-------------------------+------------+-----------------------+
        1|                       15|       15.85|                     16|
        2|                       23|       23.93|                     24|
        3|                       10|       10.00|                     10|      
       
-- 5. What was the difference between the longest and shortest delivery times for all orders?

SELECT
	max(duration) - min(duration) AS time_diff
FROM new_runner_orders;
       
-- Result:
       
time_diff|
---------+
       30|       
       
-- 6. -- What was the average speed for each runner for each delivery and do you notice any trend for these values?

WITH customer_order_count AS (
	SELECT
		customer_id,
		order_id,
		order_time,
		count(pizza_id) AS n_pizzas
	FROM new_customer_orders
	GROUP BY 
		customer_id,
		order_id,
		order_time		
)

SELECT
	c.customer_id,
	r.order_id,
	r.runner_id,
	c.n_pizzas,
	r.distance,
	r.duration,
	round(60 * r.distance / r.duration, 2) AS runner_speed
FROM new_runner_orders AS r
JOIN customer_order_count AS c
ON r.order_id = c.order_id
WHERE r.pickup_time IS NOT NULL
ORDER BY runner_speed

/* 
 * Noticable Trend
 *  
 */

-- As long as weather and road conditions are not a factor, customer #102 appears to be a tremendous tipper and
-- runner #2 will violate every law in an attempt to deliver the pizza quickly.
-- Although the slowest runner carried three pizzas, other runners carrying only 1 pizza has similar slow
-- speeds which may have been cause by bad weather conditions or some other factor.     
       
       
-- 7. -- What is the successful delivery percentage for each runner?

SELECT
	runner_id,
	count(pickup_time) AS delivered_pizzas,
	count(order_id) AS total_orders,
	(round(100 * count(pickup_time) / count(order_id))) AS delivered_percentage
FROM new_runner_orders
GROUP BY runner_id
ORDER BY runner_id

-- Result:

runner_id|delivered_pizzas|total_orders|delivered_percentage|
---------+----------------+------------+--------------------+
        1|               4|           4|               100.0|
        2|               3|           4|                75.0|
        3|               1|           2|                50.0|

/* 
 * Pizza Runner
 * Case Study #2 Questions
 * Ingredient Optimisation
 *  
*/

-- We will create a temp table with the unnested array of pizza toppings
        
DROP TABLE IF EXISTS recipe_toppings;
CREATE TEMP TABLE recipe_toppings AS (
	SELECT
		pn.pizza_id,
		pn.pizza_name,
		UNNEST(string_to_array(pr.toppings, ','))::numeric AS each_topping
	FROM pizza_names AS pn
	JOIN pizza_recipes AS pr
	ON pn.pizza_id = pr.pizza_id
);

-- 1. What are the standard ingredients for each pizza?

SELECT
	rt.pizza_name,
	pt.topping_name
FROM recipe_toppings AS rt
JOIN pizza_toppings AS pt
ON rt.each_topping = pt.topping_id
ORDER BY rt.pizza_name;

-- Result

pizza_name|topping_name|
----------+------------+
Meatlovers|BBQ Sauce   |
Meatlovers|Pepperoni   |
Meatlovers|Cheese      |
Meatlovers|Salami      |
Meatlovers|Chicken     |
Meatlovers|Bacon       |
Meatlovers|Mushrooms   |
Meatlovers|Beef        |
Vegetarian|Tomato Sauce|
Vegetarian|Cheese      |
Vegetarian|Mushrooms   |
Vegetarian|Onions      |
Vegetarian|Peppers     |
Vegetarian|Tomatoes    |

-- 2. What was the most commonly added extra?

WITH most_common_extra AS (
	SELECT
		extras,
		RANK() OVER (ORDER BY count(extras) desc) AS rnk_extras
	from
		(SELECT
			trim(UNNEST(string_to_array(extras, ',')))::numeric AS extras
		FROM new_customer_orders
		GROUP BY extras) AS tmp
	GROUP BY extras
)

SELECT
	topping_name
FROM pizza_toppings
WHERE topping_id = (SELECT extras FROM most_common_extra WHERE rnk_extras = 1);

-- Result

topping_name|
------------+
Bacon       |

-- 3. What was the most common exclusion?

WITH most_common_exclusion AS (
	SELECT
		exclusions,
		RANK() OVER (ORDER BY count(exclusions) desc) AS rnk_exclusions
	from
		(SELECT
			trim(UNNEST(string_to_array(exclusions, ',')))::numeric AS exclusions
		FROM new_customer_orders
		GROUP BY exclusions) AS tmp
	GROUP BY exclusions
)

SELECT
	topping_name
FROM pizza_toppings
WHERE topping_id in (SELECT exclusions FROM most_common_exclusion WHERE rnk_exclusions = 1);

-- Result

topping_name|
------------+
BBQ Sauce   |
Cheese      |
Mushrooms   |

-- 4. Generate an order item for each record in the customers_orders table in the format of one of the following:
-- Meat Lovers
-- Meat Lovers - Exclude Beef
-- Meat Lovers - Extra Bacon
-- Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers

WITH get_exclusions AS (
	SELECT
		order_id,
		trim(UNNEST(string_to_array(exclusions, ',')))::NUMERIC AS single_exclusions
	FROM new_customer_orders
	GROUP BY order_id, exclusions
),
get_extras AS (
	SELECT
		order_id,
		trim(UNNEST(string_to_array(extras, ',')))::numeric AS single_extras
	FROM new_customer_orders
	GROUP BY order_id, extras
)

SELECT
	order_id,
	case
		WHEN all_exclusions IS NOT NULL AND all_extras IS NULL THEN concat(pizza_name, ' - ', 'Exclude: ', all_exclusions)
		WHEN all_exclusions IS NULL AND all_extras IS NOT NULL THEN concat(pizza_name, ' - ', 'Extra: ', all_extras)
		WHEN all_exclusions IS NOT NULL AND all_extras IS NOT NULL THEN concat(pizza_name, ' - ', 'Exclude: ', all_exclusions, ' - ', 'Extra: ', all_extras)
		ELSE pizza_name
	END AS pizza_type
from
	(
	SELECT
		c.order_id,
		pn.pizza_name,
		CASE
			WHEN c.exclusions IS NULL AND c.extras IS NULL THEN NULL
			ELSE 
				(SELECT
					string_agg((SELECT topping_name FROM pizza_toppings WHERE topping_id = get_exc.single_exclusions), ', ')
				FROM
					get_exclusions AS get_exc
				WHERE order_id =c.order_id)
		END AS all_exclusions,
		CASE
			WHEN c.exclusions IS  NULL AND c.extras IS NULL THEN NULL
			ELSE
				(SELECT
					string_agg((SELECT topping_name FROM pizza_toppings WHERE topping_id = get_ext.single_extras), ', ')
				FROM
					get_extras AS get_ext
				WHERE order_id =c.order_id)
		END AS all_extras
	FROM pizza_names AS pn
	JOIN new_customer_orders AS c
	ON c.pizza_id = pn.pizza_id
	LEFT JOIN get_exclusions AS get_exc
	ON get_exc.order_id = c.order_id AND c.exclusions IS NOT NULL
	LEFT JOIN get_extras AS get_ext
	ON get_ext.order_id = c.order_id AND c.extras IS NOT NULL
	GROUP BY c.order_id,
		pn.pizza_name,
		c.exclusions,
		c.extras
	ORDER BY c.order_id) AS tmp



       
       
      