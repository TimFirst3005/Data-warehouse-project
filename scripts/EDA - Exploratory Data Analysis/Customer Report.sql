/*
=============================================================================
Customer Repor
=============================================================================
Purpose
	- This report consolidates key customer metrics and behaviors

Highlights:
	1. Gathers essential fiels such as names, ages, and transactions details.
	2. Segments customers into categories (VIP, Regulars, New) and age groups.
	3. Aggregates customer-level metrics:
		- total orders
		- total sales
		- total quantity purchased
		- total products
		- lifespan (in months)
	4. Calculates valuable KPIs:
		- recency (months since last order)
		- average order value
		- average monthly spend
===============================================================================
*/
CREATE VIEW gold.report_customers AS
WITH base_query AS (
/*---------------------------------------------------------------------------
	1) Base Query : Restrieves core columns from tables
---------------------------------------------------------------------------*/
SELECT 
	f.order_number
	,f.product_key
	,f.order_date
	,f.sales_amount
	,f.quantity
	,c.customer_key
	,c.customer_number
	,CONCAT(c.firstname, ' ', c.lastname) customer_name
	,DATEDIFF(year, c.birthdate, GETDATE()) age
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
)

, customer_aggregation AS (
SELECT
	customer_key
	,customer_number
	,customer_name
	,age
	,COUNT(DISTINCT order_number) total_orders
	,SUM(sales_amount) total_sales
	,SUM(quantity) total_quantity
	,COUNT(DISTINCT product_key) total_products
	,MAX(order_date) last_order_date
	,DATEDIFF(month, MIN(order_date), MAX(order_date)) lifespan
FROM base_query
GROUP BY 
	customer_key
	,customer_number
	,customer_name
	,age
)

SELECT
	customer_key
	,customer_number
	,customer_name
	,CASE 
		WHEN age < 20 THEN 'Under 20'
		WHEN age between 20 and 29 THEN '20-29'
		WHEN age between 30 and 39 THEN '30-39'
		WHEN age between 40 and 49 THEN '40-49'
		ELSE '50 and Above'
	 END age_group
	,CASE 
		WHEN lifespan > 12 AND total_sales > 5000 THEN 'VIP'
		WHEN lifespan > 12 AND total_sales <= 5000 THEN 'Regular'
		ELSE 'New'
	 END customer_segment
	,last_order_date
	,DATEDIFF(month, last_order_date, GETDATE()) recency
	,total_orders
	,total_sales
	,total_quantity
	,total_products
	,lifespan
	-- Compute average order value (AVO)
	,CASE WHEN total_sales = 0 THEN 0
		ELSE total_sales / total_orders
	 END avg_order_value

	 -- Compute average monthly spend
	 ,CASE WHEN lifespan = 0 THEN total_sales
		ELSE total_sales / lifespan
	 END avg_monthly_spend
FROM customer_aggregation