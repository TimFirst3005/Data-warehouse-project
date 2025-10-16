-- Find the Total sales
SELECT 
	SUM(sales_amount) total_sales
FROM gold.fact_sales

-- Find how many items are sold
SELECT 
	SUM(quantity) total_quantity
FROM gold.fact_sales

-- Find the average selling price
SELECT 
	AVG(price) avg_price
FROM gold.fact_sales

-- Find the total number of orders
SELECT 
	COUNT(order_number) total_orders
FROM gold.fact_sales

SELECT 
	COUNT(DISTINCT order_number) total_orders
FROM gold.fact_sales

-- Find the total number of products
SELECT 
	COUNT(product_key) total_products
FROM gold.dim_products

SELECT 
	COUNT(DISTINCT product_key) total_products
FROM gold.dim_products

-- Find the total number of customers
SELECT 
	COUNT(customer_key) total_customers
FROM gold.dim_customers

-- Find the total number of customers that has placed an order
SELECT 
	COUNT(DISTINCT customer_key) total_customers
FROM gold.fact_sales


-- Generate a report that show all key metrics of the business
SELECT 'Total sales' measure_name, SUM(sales_amount) mesure_value FROM gold.fact_sales
UNION 
SELECT 'Total Quantity' measure_name, SUM(quantity) mesure_value FROM gold.fact_sales
UNION 
SELECT 'Average Price' measure_name, AVG(price) avg_price FROM gold.fact_sales
UNION
SELECT 'Total Nbr. Orders' measure_name, COUNT(DISTINCT order_number) total_orders FROM gold.fact_sales
UNION
SELECT 'Total Nbr. Products' measure_name, COUNT(product_key) total_products FROM gold.dim_products
UNION
SELECT 'Total Nbr. Customers' measure_name, COUNT(customer_key) total_products FROM gold.dim_customers