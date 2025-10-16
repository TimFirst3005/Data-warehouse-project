/*
Group customers into three segments based on thier spending behavior:
 - VIP: Customers with at least 12 months of history and spending more than £5,000.
 - Regular: Customers with at least 12 months of history but spending £5,000 or less.
 - New: lifespan less than 12 months.
 And find the total number of customers by each group.
 */

 WITH customer_spending AS (
	SELECT 
		c.customer_key
		,SUM(f.sales_amount) total_spending
		,MIN(f.order_date) first_order
		,MAX(f.order_date) last_order
		,DATEDIFF(month, MIN(f.order_date), MAX(f.order_date)) lifespan
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_customers c
	ON f.customer_key = c.customer_key
	GROUP BY c.customer_key
)

SELECT 
	customer_segment
	,COUNT(customer_key) total_customers
FROM (
	SELECT 
		customer_key
		,CASE WHEN lifespan > 12 AND total_spending > 5000 THEN 'VIP'
			WHEN lifespan > 12 AND total_spending <= 5000 THEN 'Regular'
			ELSE 'New'
		END customer_segment
	FROM customer_spending
	) t
GROUP BY customer_segment
ORDER BY total_customers DESC
