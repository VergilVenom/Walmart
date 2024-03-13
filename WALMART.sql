CREATE DATABASE IF NOT EXISTS salesdatawalmart;
USE salesdatawalmart;
CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    VAT FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);


--- -----------------------------------------------------------------------------------------------------------
-----------------------------------------------TIme/Date/Day--------------------------------------------------

-- Add the time_of_day column
SELECT
	time,
	(CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END) AS time_of_day
FROM sales;


ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

-- For this to work turn off safe mode for update
-- Edit > Preferences > SQL Edito > scroll down and toggle safe mode
-- Reconnect to MySQL: Query > Reconnect to server
UPDATE sales
SET time_of_day = (
	CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END
);


-- Add day_name column
SELECT
	date,
	DAYNAME(date)
FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales
SET day_name = DAYNAME(date);


-- Add month_name column
SELECT
	date,
	MONTHNAME(date)
FROM sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);

UPDATE sales
SET month_name = MONTHNAME(date);

-- -----------------------------------------------------------------------------------------------------------
-- ---------------------------- ------------------Generic ---------------------------------------------------
-- How many unique cities does the data have?
SELECT 
	DISTINCT city
FROM sales;

-- In which city is each branch?
SELECT 
	DISTINCT city,
    branch
FROM sales;

-- -----------------------------------------------------------------------------------------------------------
-- ------------------------------------------------ Product --------------------------------------------------


-- How many unique product lines does the data have?
SELECT
	DISTINCT product_line
FROM sales;


-- What is the most selling product line?
SELECT
	SUM(quantity) as qty,
    product_line
FROM sales
GROUP BY product_line
ORDER BY qty DESC;


-- What is the total revenue by month
SELECT
	month_name AS month,
	SUM(total) AS total_revenue
FROM sales
GROUP BY month_name 
ORDER BY total_revenue;


-- What month had the largest COGS?
SELECT
	month_name AS month,
	SUM(cogs) AS cogs
FROM sales
GROUP BY month_name 
ORDER BY cogs;


-- What product line had the largest revenue?
SELECT
	product_line,
	SUM(total) as total_revenue
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC;

-- What is the city with the largest revenue?
SELECT
	branch,
	city,
	SUM(total) AS total_revenue
FROM sales
GROUP BY city, branch 
ORDER BY total_revenue;


-- Fetch each product line and add a column to those product 
   line showing "Good", "Bad". Good if its greater than average sales

SELECT 
	AVG(quantity) AS avg_qnty
FROM sales;

SELECT
	product_line,
	CASE
		WHEN AVG(quantity) > 6 THEN "Good"
        ELSE "Bad"
    END AS remark
FROM sales
GROUP BY product_line;


-- What product line had the largest VAT?
SELECT
	product_line,
	AVG(VAT) as avg_tax
FROM sales
GROUP BY product_line
ORDER BY avg_tax DESC;

 
-- Which branch sold more products than average product sold?
SELECT 
	branch, 
    SUM(quantity) AS qnty
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);


-- What is the most common product line by gender?
SELECT
	gender,
    product_line,
    COUNT(gender) AS total_cnt
FROM sales
GROUP BY gender, product_line
ORDER BY total_cnt DESC;

-- What is the average rating of each product line?
SELECT
	ROUND(AVG(rating), 2) as avg_rating,
    product_line
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;

-- What is the most common payment method?

SELECT payment,
COUNT(payment) AS cnt
FROM sales
GROUP BY payment
ORDER BY cnt DESC;

------------------------------------------------------------------------------------------------------------
-- --------------------------------------------Sales--------------------------------------------------------
--Number of sales made in each time of the day per weekday-
SELECT 
time_of_day,
COUNT(*) AS total_sales
FROM sales
WHERE day_name = "MONDAY" 
GROUP BY time_of_day

-- Which of the customer types brings the most revenue?
SELECT 
customer_type,
SUM(total) AS total_revenue
FROM sales
GROUP BY customer_type
ORDER BY total_revenue DESC;

-- Which city has the largest tax percent /VAT (value added tax)?
SELECT 
     city,
     AVG(VAT) AS VAT
     FROM sales
     GROUP BY city
     ORDER BY VAT DESC;
     
     
----- Which customer type pays the most in VAT?

SELECT customer_type,
AVG(VAT) AS VAT
FROM sales
GROUP BY Customer_type
ORDER BY VAT DESC;

------------------------------------------------------------------------------------------------------------
-- --------------------------------------Customer----------------------------------------------------------

-- How many unique customer types does the data have?
SELECT 
DISTINCT customer_type
FROM sales;

-- How many unique payments method does the data have?
SELECT
DISTINCT payment
FROM sales;

--What is the most common customer type?

SELECT customer_type,
COUNT(*) AS count
FROM sales
GROUP BY customer_type
ORDER BY count DESC;


---- Which customer type buys the most?

SELECT customer_type,
COUNT(*)
FROM sales
GROUP BY customer_type;

--- What is the gender of most of the customers?
SELECT gender,
COUNT(*)
FROM sales
GROUP BY gender;

---- What is the gender distribution per branch?
SELECT gender,
COUNT(*)
FROM sales
WHERE branch ="C"
GROUP BY gender;

SELECT gender,
COUNT(*)
FROM sales
WHERE branch ="A"
GROUP BY gender;

SELECT gender,
COUNT(*)
FROM sales
WHERE branch ="B"
GROUP BY gender;


-- Which time of the day do customers give most ratings ?

SELECT time_of_day,
AVG(rating) AS avg_rating 
FROM sales
GROUP BY time_of_day
ORDER BY avg_rating DESC;


--- Which time of the day do cutsomers give most ratings per branch 

SELECT time_of_day,
AVG(rating) AS avg_rating
FROM sales
Where branch = "A"
GROUP BY time_of_day;


SELECT time_of_day,
AVG(rating) AS avg_rating
FROM sales
Where branch = "B"
GROUP BY time_of_day;


SELECT time_of_day,
AVG(rating) AS avg_rating
FROM sales
Where branch = "C"
GROUP BY time_of_day;


-- Which day of the weeek has the best avg ratings?

SELECT day_name,
AVG(rating) AS avg_rating
FROM sales
GROUP BY day_name;


--- Which day of the week has the best average rating per branch?

SELECT day_name,
AVG(rating) AS avg_rating 
FROM sales
WHERE branch = "A"
GROUP BY day_name;

SELECT day_name,
AVG(rating) AS avg_rating 
FROM sales
WHERE branch = "B"
GROUP BY day_name;

SELECT day_name,
AVG(rating) AS avg_rating 
FROM sales
WHERE branch = "C"
GROUP BY day_name;


-----------------------------------------------------------------------------------------------------------------
--------------------------------Revenue and Profit calculations-------------------------------------------------

-------- Total Gross sales
SELECT
SUM(VAT+COGS) AS total_gross_sales
FROM sales;


--------- Gross Profit

SELECT
(SUM(VAT + COGS)-COGS) AS gross_profit
FROM sales;