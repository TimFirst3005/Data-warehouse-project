SELECT * 
FROM gold.report_customers;

SELECT 
	age_group
	,COUNT(customer_number) AS total_customers
	,SUM(total_sales) total_sales
FROM gold.report_customers
GROUP BY age_group;

SELECT 
	customer_segment
	,COUNT(customer_number) AS total_customers
	,SUM(total_sales) total_sales
FROM gold.report_customers
GROUP BY customer_segment