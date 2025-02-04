DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales 
	(
		transactions_id	INT PRIMARY KEY,
		sale_date DATE,
		sale_time TIME,
		customer_id INT,
		gender VARCHAR(15),
		age INT,
		category VARCHAR(15),	
		quantiy	INT,
		price_per_unit FLOAT,
		cogs FLOAT,
		total_sale FLOAT
	);

SELECT * FROM retail_sales;

-- DATA CLEANING--
SELECT * FROM retail_sales
where
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL

DELETE FROM retail_sales
where
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL

-- DATA EXPLORATION--

-- How many sales we have
SELECT count(*) as total_sales FROM retail_sales

-- How many distinct customer we have
SELECT count(DISTINCT customer_id) as distinct_customer FROM retail_sales

-- How many distinct category we have
SELECT count(DISTINCT category) as distinct_category FROM retail_sales


-- DATA ANALYST & BUSINESS KEY PROBLEM & ANSWER
--Write a SQL query to retrieve all columns for sales made on '2022-11-05--:
SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';

/* Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity
sold is more than 4 in the month of Nov-2022 */:
SELECT * FROM retail_sales
WHERE category = 'Clothing'
	  AND
	  TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
	  AND
	  quantiy >= 4;

--Write a SQL query to calculate the total sales (total_sale) for each category
SELECT DISTINCT category, sum(total_sale) AS net_sales, count(*) AS total_orders 
FROM retail_sales
GROUP BY category;

--Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT ROUND(AVG(age)) as avg_age 
FROM retail_sales
WHERE category = 'Beauty';

--Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT * FROM retail_sales
WHERE total_sale >= '1000';

--Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT category, gender, count(transactions_id) AS total_transaction
FROM retail_sales
GROUP BY category, gender
ORDER BY 1;

--Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT year, month, avg_sales 
FROM
(
	SELECT
		EXTRACT(YEAR FROM sale_date) as year,
		EXTRACT(MONTH FROM sale_date) as month,
		ROUND(AVG(total_sale)) AS avg_sales,
		RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY ROUND(AVG(total_sale)) desc) as rank
	FROM retail_sales
	GROUP BY 1, 2
)
WHERE rank = 1;
--ORDER BY 1, 3 DESC;


--Write a SQL query to find the top 5 customers based on the highest total sales
SELECT customer_id, sum(total_sale) AS net_sales
FROM retail_sales
GROUP BY 1
ORDER BY net_sales DESC
LIMIT 5;

--Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT count(DISTINCT customer_id) AS unique_customer, category FROM retail_sales
GROUP BY category;

--Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
WITH hourly_shift
AS
(
	SELECT *,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END AS shift
	FROM retail_sales
)
SELECT shift, count(*) AS total_sales
FROM hourly_shift
GROUP BY shift;

-- END