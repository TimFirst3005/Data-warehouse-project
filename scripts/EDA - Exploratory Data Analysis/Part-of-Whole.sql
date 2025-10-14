/*
==============================================================
	Part-to-Whole Proportional
==============================================================
	Analyze how an individual part is performing compared to 
	the overall, allowing us ton undestand which category has
	the greatest impact on the business.
==============================================================
*/

-- Which categories contribute the most to overall sales ?
-- Quelles catégories contribuent le plus aux ventes globales ?
WITH category_sales AS (
	SELECT 
		category
		,SUM(sales_amount) total_sales
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_products p
	ON p.product_key = f.product_key
	GROUP BY category
)
SELECT 
	category
	,total_sales
	,SUM(total_sales) OVER() overall_sales
	,CONCAT(ROUND((CAST(total_sales AS float) / SUM(total_sales) OVER())*100, 2), '%') percentage_of_total
FROM category_sales
ORDER BY total_sales DESC