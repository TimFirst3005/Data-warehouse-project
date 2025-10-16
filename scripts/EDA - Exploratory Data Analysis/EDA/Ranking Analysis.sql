-- Which 5 products generate the highest revenue ?
SELECT TOP 5
	p.product_name
	,SUM(f.sales_amount) total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC

-- With the Window Fonction
SELECT * 
FROM (
	SELECT
		p.product_name
		,SUM(f.sales_amount) total_revenue
		,ROW_NUMBER() OVER(ORDER BY SUM(f.sales_amount) DESC) rank_products
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_products p
	ON p.product_key = f.product_key
	GROUP BY p.product_name
) t
WHERE rank_products <= 5
-- What are the 5 worst-performing products in terms of sales ?
SELECT TOP 5
	p.product_name
	,SUM(f.sales_amount) total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue


-- Find the top 10 customers who have generated the highest revenue 
SELECT TOP 10
	c.customer_key
	,c.firstname
	,c.lastname
	,SUM(f.sales_amount) total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
GROUP BY 
	c.customer_key
	,c.firstname
	,c.lastname
ORDER BY total_revenue DESC


-- The 3 customers with the fewest orders placed
SELECT TOP 3
	c.customer_key
	,c.firstname
	,c.lastname
	,COUNT(distinct order_number) total_orders
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
GROUP BY 
	c.customer_key
	,c.firstname
	,c.lastname
ORDER BY total_orders