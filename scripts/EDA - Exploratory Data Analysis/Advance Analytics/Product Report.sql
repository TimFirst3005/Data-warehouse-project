/*
=============================================================================
Product Report
=============================================================================
Purpose
	- This report consolidates key product metrics and behaviors

Highlights:
	1. Gathers essential fiels such as product name, categories, subcategory, and cost.
	2. Segments products by revenue to identify High-performers, Mid-range, or Low-Performers.
	3. Aggregates product-level metrics:
		- total orders
		- total sales
		- total quantity sold
		- total customers (unique)
		- lifespan (in months)
	4. Calculates valuable KPIs:
		- recency (months since last sale)
		- average order revenue (AOR)
		- average monthly revenue
===============================================================================
*/
CREATE VIEW gold.report_products AS
WITH base_query AS (
/*---------------------------------------------------------------------------
	1) Base Query : Restrieves core columns from fact_sales and dim_products
---------------------------------------------------------------------------*/
SELECT 
	f.order_number
	,f.order_date
	,f.customer_key
	,f.sales_amount
	,f.quantity
	,p.product_key
	,p.product_name
	,p.category
	,p.subcategory
	,p.cost
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
WHERE order_date IS NOT NULL  -- Only consider valid sales dates
)

, product_aggregation AS (
/*---------------------------------------------------------------------------
	2) Product Aggregations: Summarizes key metrics at the product level
---------------------------------------------------------------------------*/
SELECT
	product_key
	,product_name
	,category
	,subcategory
	,cost
	,DATEDIFF(month, MIN(order_date), MAX(order_date)) lifespan
	,MAX(order_date) last_sale_date
	,COUNT(DISTINCT order_number) total_orders
	,COUNT(DISTINCT customer_key) total_customers
	,SUM(sales_amount)total_sales
	,SUM(quantity) total_quantity
	,ROUND(AVG(CAST(sales_amount AS FLOAT) / NULLIF(quantity, 0)), 1) avg_selling_price
FROM base_query
GROUP BY 
	product_key
	,product_name
	,category
	,subcategory
	,cost
)

/*---------------------------------------------------------------------------
	3) Final Query: Combines all product results into one output
---------------------------------------------------------------------------*/
SELECT
	product_key
	,product_name
	,category
	,subcategory
	,cost
	,last_sale_date
	,DATEDIFF(month, last_sale_date, GETDATE()) recency_in_months
	,CASE 
		WHEN total_sales > 50000 THEN 'High-Performer'
		WHEN total_sales >= 10000 THEN 'Mid-Range'
		ELSE 'Low-Performer'
	 END product_segment
	,CASE 
		WHEN lifespan > 12 AND total_sales > 5000 THEN 'VIP'
		WHEN lifespan > 12 AND total_sales <= 5000 THEN 'Regular'
		ELSE 'New'
	 END customer_segment
	,lifespan
	,total_orders
	,total_sales
	,total_quantity
	,total_customers
	,avg_selling_price
	-- Average order Revenue (AOR)
	,CASE 
		WHEN total_orders = 0 THEN 0
		ELSE total_sales / total_orders
	 END avg_order_revenue

	 -- Average monthly Revenue
	 ,CASE WHEN lifespan = 0 THEN total_sales
		ELSE total_sales / lifespan
	 END avg_monthly_revenue

FROM product_aggregation
