CREATE DATABASE coffee_shop_sales;
RENAME TABLE `coffee shop sales 1(transactions)` TO coffee_shop_sales_tb;
SELECT * FROM coffee_shop_sales_tb;
DESCRIBE coffee_shop_sales_tb;
UPDATE coffee_shop_sales_tb
SET transaction_date = STR_TO_DATE(transaction_date, '%d/%m/%Y');
ALTER TABLE coffee_shop_sales_tb
MODIFY COLUMN transaction_date DATE;
UPDATE coffee_shop_sales_tb
SET transaction_time = STR_TO_DATE(transaction_time, '%H:%i:%s');
ALTER TABLE coffee_shop_sales_tb
MODIFY COLUMN transaction_time TIME;
ALTER TABLE coffee_shop_sales_tb
RENAME COLUMN ï»¿transaction_id TO transaction_id;

SELECT CONCAT(ROUND(SUM(transaction_qty*unit_price)/1000), ' K') AS total_sales
FROM coffee_shop_sales_tb;
SELECT CONCAT(ROUND(SUM(transaction_qty*unit_price)/1000), ' K') AS total_sales
FROM coffee_shop_sales_tb
WHERE MONTH(transaction_date) = 5;

SELECT MONTH(transaction_date) AS month,
ROUND(SUM(transaction_qty*unit_price)) AS total_sales,
(SUM(transaction_qty*unit_price)-LAG(SUM(transaction_qty*unit_price),1)
OVER(ORDER BY MONTH(transaction_date)))/LAG(SUM(transaction_qty*unit_price),1)
OVER(ORDER BY MONTH(transaction_date)) * 100 AS mom_increase_percentage
FROM coffee_shop_sales_tb
WHERE MONTH(transaction_date) IN (4,5)
GROUP BY MONTH(transaction_date)
ORDER BY MONTH(transaction_date);

SELECT SUM(transaction_qty) AS total_qty_sold
FROM coffee_shop_sales_tb
WHERE MONTH(transaction_date) = 5;

SELECT MONTH(transaction_date) AS month,
SUM(transaction_qty) AS total_qty_sold,
(SUM(transaction_qty)-LAG(SUM(transaction_qty),1)
OVER(ORDER BY MONTH(transaction_date)))/LAG(SUM(transaction_qty),1)
OVER(ORDER BY MONTH(transaction_date))*100 AS mom_increase_percentage
FROM coffee_shop_sales_tb
WHERE MONTH(transaction_date) IN (4,5)
GROUP BY MONTH(transaction_date)
ORDER BY MONTH(transaction_date);

SELECT COUNT(transaction_id) AS Total_orders
FROM coffee_shop_sales_tb	
WHERE MONTH(transaction_date) = 5;

SELECT MONTH(transaction_date) AS month,
COUNT(transaction_id) AS total_orders,
(COUNT(transaction_id)-LAG(COUNT(transaction_id),1)
OVER(ORDER BY MONTH(transaction_date)))/LAG(COUNT(transaction_id),1)
OVER(ORDER BY MONTH(transaction_date))*100 AS mom_increase_percentage
FROM coffee_shop_sales_tb
WHERE MONTH(transaction_date) IN (4,5)
GROUP BY MONTH(transaction_date)
ORDER BY MONTH(transaction_date);

SELECT CONCAT(ROUND(SUM(transaction_qty*unit_price)/1000,1),' K') AS total_sales,
CONCAT(ROUND(SUM(transaction_qty)/1000,1),' K') AS total_qty_sold,
CONCAT(ROUND(COUNT(transaction_id)/1000,1),' K') AS total_orders
FROM coffee_shop_sales_tb
WHERE transaction_date = '2023-05-18';

SELECT 
	CASE WHEN DAYOFWEEK(transaction_date) IN (7,1) THEN 'Weekends'
    ELSE 'Weekdays'
    END AS Day_type,
    CONCAT(ROUND(SUM(transaction_qty*unit_price)/1000,1),' K') AS total_sales
FROM coffee_shop_sales_tb
WHERE MONTH(transaction_date) = 5
GROUP BY 
	CASE WHEN DAYOFWEEK(transaction_date) IN (7,1) THEN 'Weekends'
    ELSE 'Weekdays'
    END;
    
SELECT store_location,
CONCAT(ROUND(SUM(transaction_qty*unit_price)/1000,1),' K') AS total_sales
FROM coffee_shop_sales_tb
WHERE MONTH(transaction_date) = 5
GROUP BY store_location
ORDER BY total_sales DESC;

SELECT CONCAT(ROUND(AVG(total_sales)/1000,1),' K') AS avg_sales
FROM 
	(SELECT SUM(transaction_qty*unit_price) AS total_sales
    FROM coffee_shop_sales_tb
    WHERE MONTH(transaction_date) = 5
    GROUP BY DAY(transaction_date)
    ) AS i;

SELECT DAY(transaction_date) AS day_of_month,
CONCAT(ROUND(SUM(transaction_qty*unit_price)/1000,1),' K') AS total_sales
FROM coffee_shop_sales_tb
WHERE MONTH(transaction_date) = 5
GROUP BY day_of_month;

SELECT 
	day_of_month,total_sales,
    CASE 
		WHEN total_sales > avg_sales THEN 'Above Average'
		WHEN total_sales < avg_sales THEN 'Below Average'
        ELSE 'Equal to Average'
    END AS sales_status
FROM 
	( SELECT DAY(transaction_date) AS day_of_month,
    SUM(transaction_qty*unit_price) AS total_sales,
    AVG(SUM(transaction_qty*unit_price)) OVER() AS avg_sales
    FROM coffee_shop_sales_tb
    WHERE MONTH(transaction_date) = 5
    GROUP BY day_of_month
    ) AS i
    ORDER BY day_of_month;
    
SELECT product_category,
CONCAT(ROUND(SUM(transaction_qty*unit_price)/1000,1),' K') AS total_sales
FROM coffee_shop_sales_tb
WHERE MONTH(transaction_date) = 5
GROUP BY product_category
ORDER BY SUM(transaction_qty*unit_price) DESC;

SELECT product_type,
CONCAT(ROUND(SUM(transaction_qty*unit_price)/1000,1),' K') AS total_sales
FROM coffee_shop_sales_tb
WHERE MONTH(transaction_date) = 5
AND product_category = 'Coffee'
GROUP BY product_type
ORDER BY SUM(transaction_qty*unit_price) DESC
LIMIT 10;

SELECT CONCAT(ROUND(SUM(transaction_qty*unit_price)/1000),' K') AS total_sales,
SUM(transaction_qty) AS total_qty_sold,
COUNT(*) AS total_orders
FROM coffee_shop_sales_tb
WHERE MONTH(transaction_date) = 5
AND DAYOFWEEK(transaction_date) = 2
AND HOUR(transaction_time) = 8;

SELECT HOUR(transaction_time) AS hour,
CONCAT(ROUND(SUM(transaction_qty*unit_price)/1000,1),' K') AS total_sales
FROM coffee_shop_sales_tb
WHERE MONTH(transaction_date) = 5
GROUP BY hour
ORDER BY hour;

SELECT 
	CASE 
		WHEN DAYOFWEEK(transaction_date) = 2 THEN 'Monday'
        WHEN DAYOFWEEK(transaction_date) = 3 THEN 'Tuesday'
        WHEN DAYOFWEEK(transaction_date) = 4 THEN 'Wednesday'
        WHEN DAYOFWEEK(transaction_date) = 5 THEN 'Thursday'
        WHEN DAYOFWEEK(transaction_date) = 6 THEN 'Friday'
        WHEN DAYOFWEEK(transaction_date) = 7 THEN 'Saturday'
        ELSE 'Sunday'
	END AS day_of_week,
    CONCAT(ROUND(SUM(transaction_qty*unit_price)/1000,1),' K') AS total_sales
    FROM coffee_shop_sales_tb
    WHERE MONTH(transaction_date) = 5
    GROUP BY day_of_week;