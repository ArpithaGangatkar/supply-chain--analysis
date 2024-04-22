USE supplychain;
SELECT * FROM dim_customers;
SELECT * FROM dim_date;
SELECT * FROM dim_products;
SELECT * FROM dim_targets_orders;
SELECT * FROM fact_order_lines;

-- 1. OTIF% , IF%, OnTime 
-- OT%
SELECT ROUND((SUM(on_time)/COUNT(*)*100),2) AS 'OT%' FROM fact_orders_aggregate; 
-- IF%
SELECT ROUND((SUM(CASE WHEN in_full = 1 THEN 1 ELSE 0 END)/COUNT(*) * 100),2) AS 'IF%' FROM fact_orders_aggregate;
-- OTIF%
SELECT ROUND((SUM(otif)/COUNT(*)*100),2) AS 'OT%' FROM fact_orders_aggregate;


-- 2. Target 
-- OT% Target
SELECT ROUND(AVG(`ontime_target%`),2) AS 'OT Target %' FROM dim_targets_orders;
-- IF% Target
SELECT ROUND(AVG(`infull_target%`),2) AS 'IF Target %' FROM dim_targets_orders;
-- OTIF% Target
SELECT ROUND(AVG(`otif_target%`),2) AS 'OTIF Target %' FROM dim_targets_orders;

-- 3. Find OT% , IF%, OTIF% Based on each city

SELECT city , ROUND((SUM(on_time)/COUNT(*)*100),2) AS 'OT%' FROM dim_customers t1
JOIN fact_orders_aggregate t2 
ON t1.customer_id = t2.customer_id
GROUP BY city 
ORDER BY `OT%` DESC;

SELECT city , ROUND((SUM(in_full)/COUNT(*)*100),2) AS 'IF%' FROM dim_customers t1
JOIN fact_orders_aggregate t2 
ON t1.customer_id = t2.customer_id
GROUP BY city 
ORDER BY `IF%` DESC;

SELECT city , ROUND((SUM(otif)/COUNT(*)*100),2) AS 'OTIF%' FROM dim_customers t1
JOIN fact_orders_aggregate t2 
ON t1.customer_id = t2.customer_id
GROUP BY city 
ORDER BY `OTIF%` DESC;

-- 4. Find OT Target% , IF Target%, OTIF Target% Based on each city

SELECT city, ROUND(AVG(`ontime_target%`),2) AS 'OT Target %' FROM dim_customers t1
JOIN dim_targets_orders t2 
ON t1.customer_id = t2.customer_id
GROUP BY city
ORDER BY `OT Target %` DESC;

SELECT city, ROUND(AVG(`infull_target%`),2) AS 'IF Target %' FROM dim_customers t1
JOIN dim_targets_orders t2 
ON t1.customer_id = t2.customer_id
GROUP BY city
ORDER BY `IF Target %` DESC;

SELECT city, ROUND(AVG(`otif_target%`),2) AS 'OTIF Target %' FROM dim_customers t1
JOIN dim_targets_orders t2 
ON t1.customer_id = t2.customer_id
GROUP BY city
ORDER BY `OTIF Target %` DESC;

SELECT * FROM dim_customers;
SELECT * FROM dim_date;
SELECT * FROM dim_products;
SELECT * FROM dim_targets_orders;
SELECT * FROM fact_order_lines;

-- 5. Extracting Month and yyyy-mmm-dd from tables 
UPDATE supplychain.dim_date
SET `ï»¿date` = DATE_FORMAT(STR_TO_DATE(`ï»¿date`, '%d-%b-%y'), '%d %M %Y');

UPDATE supplychain.fact_order_lines
SET order_placement_date = DATE_FORMAT(STR_TO_DATE(order_placement_date, '%W, %M %e, %Y'), '%Y-%m-%d' );

UPDATE supplychain.fact_order_lines
SET agreed_delivery_date = DATE_FORMAT(STR_TO_DATE(agreed_delivery_date, '%W, %M %e, %Y'), '%Y-%m-%d' );
SELECT MONTHNAME(`ï»¿date`) FROM dim_date;

UPDATE fact_order_lines
SET actual_delivery_date = DATE_FORMAT(STR_TO_DATE(actual_delivery_date, '%Y-%M-%d'), '%Y-%m-%d');


SELECT MONTHNAME(`ï»¿date`) AS 'month', ROUND((SUM(`On Time`)/COUNT(*)*100),2) AS 'OT %' FROM supplychain.dim_date t1
JOIN supplychain.fact_order_lines t2
ON t1.`ï»¿date` = t2.order_placement_date
GROUP BY `month` 
ORDER BY `OT %` DESC;

SELECT MONTHNAME(`ï»¿date`) AS 'month', ROUND((SUM(`In Full`)/COUNT(*)*100),2) AS 'IF %' FROM supplychain.dim_date t1
JOIN supplychain.fact_order_lines t2
ON t1.`ï»¿date` = t2.order_placement_date
GROUP BY `month` 
ORDER BY `IF %` DESC;

SELECT MONTHNAME(`ï»¿date`) AS 'month', ROUND((SUM(`On Time In Full`)/COUNT(*)*100),2) AS 'OTIF %' FROM supplychain.dim_date t1
JOIN supplychain.fact_order_lines t2
ON t1.`ï»¿date` = t2.order_placement_date
GROUP BY `month` 
ORDER BY `OTIF %` DESC;

SELECT MONTHNAME(`order_placement_date`) AS 'month', ROUND(AVG(`ontime_target%`),2) AS 'OT Target %' 
FROM supplychain.fact_order_lines t1
JOIN supplychain.dim_targets_orders t2
ON t1.customer_id = t2.customer_id
GROUP BY `month` 
ORDER BY `OT Target %` DESC;

SELECT MONTHNAME(`order_placement_date`) AS 'month', ROUND(AVG(`infull_target%`),2) AS 'IF Target %' 
FROM supplychain.fact_order_lines t1
JOIN supplychain.dim_targets_orders t2
ON t1.customer_id = t2.customer_id
GROUP BY `month` 
ORDER BY `IF Target %` DESC;

SELECT MONTHNAME(`order_placement_date`) AS 'month', ROUND(AVG(`otif_target%`),2) AS 'OTIF Target %' 
FROM supplychain.fact_order_lines t1
JOIN supplychain.dim_targets_orders t2
ON t1.customer_id = t2.customer_id
GROUP BY `month` 
ORDER BY `OTIF Target %` DESC;

SELECT * FROM dim_customers;
SELECT * FROM dim_date;
SELECT * FROM dim_products;
SELECT * FROM dim_targets_orders;
SELECT * FROM fact_order_lines;

UPDATE dim_date
SET week_no = SUBSTRING(week_no,2);

SELECT week_no,  ROUND((SUM(`On Time`)/COUNT(*)*100),2) AS 'OT %' FROM dim_date t1
JOIN fact_order_lines t2
ON t2.order_placement_date = t1.ï»¿date
GROUP BY week_no;

SELECT week_no,  ROUND((SUM(`In Full`)/COUNT(*)*100),2) AS 'IF %' FROM dim_date t1
JOIN fact_order_lines t2
ON t2.order_placement_date = t1.ï»¿date
GROUP BY week_no;

SELECT week_no,  ROUND((SUM(`On Time In Full`)/COUNT(*)*100),2) AS 'OTIF %' FROM dim_date t1
JOIN fact_order_lines t2
ON t2.order_placement_date = t1.ï»¿date
GROUP BY week_no;

SELECT week_no,  ROUND(AVG(`ontime_target%`),2) AS 'OT Target %' FROM dim_date t1 
JOIN fact_order_lines t2
ON t2.order_placement_date = t1.ï»¿date
JOIN dim_targets_orders t3
ON t2.customer_id = t3.customer_id
GROUP BY week_no;

SELECT week_no,  ROUND(AVG(`otif_target%`),2) AS 'OTIF Target %' FROM dim_date t1 
JOIN fact_order_lines t2
ON t2.order_placement_date = t1.ï»¿date
JOIN dim_targets_orders t3
ON t2.customer_id = t3.customer_id
GROUP BY week_no;

SELECT week_no,  ROUND(AVG(`infull_target%`),2) AS 'IF Target %' FROM dim_date t1 
JOIN fact_order_lines t2
ON t2.order_placement_date = t1.ï»¿date
JOIN dim_targets_orders t3
ON t2.customer_id = t3.customer_id
GROUP BY week_no;


SELECT DAYNAME(`order_placement_date`) AS 'DayName', ROUND((SUM(`On Time`)/COUNT(*)*100),2) AS 'OT %' 
FROM supplychain.fact_order_lines t1
GROUP BY `DayName` 
ORDER BY `OT %` DESC;

SELECT DAYNAME(`order_placement_date`) AS 'DayName', ROUND((SUM(`In Full`)/COUNT(*)*100),2) AS 'IF %' 
FROM supplychain.fact_order_lines t1
GROUP BY `DayName` 
ORDER BY `IF %` DESC;

SELECT DAYNAME(`order_placement_date`) AS 'DayName', ROUND((SUM(`On Time In Full`)/COUNT(*)*100),2) AS 'OTIF %' 
FROM supplychain.fact_order_lines t1
GROUP BY `DayName` 
ORDER BY `OTIF %` DESC;

-- Calculate IF, OTIF, OT based on store

SELECT city, MONTHNAME(`order_placement_date`) AS 'month', ROUND((SUM(`In Full`)/COUNT(*)*100),2) AS 'IF %' 
FROM supplychain.fact_order_lines t1
JOIN supplychain.dim_customers t2
ON t1.customer_id = t2.customer_id
GROUP BY `month`, city;

SELECT city, MONTHNAME(`order_placement_date`) AS 'month', ROUND((SUM(`On Time`)/COUNT(*)*100),2) AS 'OT %' 
FROM supplychain.fact_order_lines t1
JOIN supplychain.dim_customers t2
ON t1.customer_id = t2.customer_id
GROUP BY `month`, city;

SELECT city, MONTHNAME(`order_placement_date`) AS 'month', ROUND((SUM(`On Time In Full`)/COUNT(*)*100),2) AS 'OTIF %' 
FROM supplychain.fact_order_lines t1
JOIN supplychain.dim_customers t2
ON t1.customer_id = t2.customer_id
GROUP BY `month`, city;

-- Store wise Target, store normal, store and city wise

SELECT customer_name, ROUND((SUM(`On Time`)/COUNT(*)*100),2) AS 'OT %' FROM supplychain.dim_customers t1
JOIN supplychain.fact_order_lines t2 
ON t1.customer_id = t2.customer_id 
GROUP BY customer_name
ORDER BY customer_name;

SELECT customer_name, ROUND((SUM(`In Full`)/COUNT(*)*100),2) AS 'IF %' FROM supplychain.dim_customers t1
JOIN supplychain.fact_order_lines t2 
ON t1.customer_id = t2.customer_id 
GROUP BY customer_name
ORDER BY customer_name;

SELECT customer_name, ROUND((SUM(`On Time In Full`)/COUNT(*)*100),2) AS 'OTIF %' FROM supplychain.dim_customers t1
JOIN supplychain.fact_order_lines t2 
ON t1.customer_id = t2.customer_id 
GROUP BY customer_name
ORDER BY customer_name;

SELECT customer_name, city, ROUND((SUM(`On Time In Full`)/COUNT(*)*100),2) AS 'OTIF %' FROM supplychain.dim_customers t1
JOIN supplychain.fact_order_lines t2 
ON t1.customer_id = t2.customer_id 
GROUP BY customer_name, city
ORDER BY customer_name;

SELECT customer_name, ROUND((SUM(`In Full`)/COUNT(*)*100),2) AS 'IF %' FROM supplychain.dim_customers t1
JOIN supplychain.fact_order_lines t2 
ON t1.customer_id = t2.customer_id 
GROUP BY customer_name, city
ORDER BY customer_name;

SELECT customer_name, city, ROUND((SUM(`In Full`)/COUNT(*)*100),2) AS 'IF %' FROM supplychain.dim_customers t1
JOIN supplychain.fact_order_lines t2 
ON t1.customer_id = t2.customer_id 
GROUP BY customer_name, city
ORDER BY customer_name;