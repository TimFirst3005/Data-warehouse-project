/*
==============================================================================
Quality Checks
==============================================================================
Script Purpose : 
    This script perform quality checks to validate the intégrity, consistency,
    and accuracy of the Gold Layer. These checks ensure :
    - Uniqueness of the surrogates keys in dimension tables.
    - Referential integrity between fact and dimension tables.
    - Validation of relationships in the data model for analytical purposes.

Usage Notes : 
    - Run these cheks after data loading Gold Layer
    - Investigate and resolve any discreapancies found during the checks
==============================================================================
*/

-- =============================================================
-- Checking 'gold.dim_customers'
-- =============================================================
-- Check for uniqueness of customer key in gold.dim_customers
-- Expectation : No Results
SELECT 
  customer_key, 
  COUNT(*) duplicate_count
FROM
  gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1

-- =============================================================
-- Checking 'gold.dim_products'
-- =============================================================
-- Check for uniqueness of product key in gold.dim_products
-- Expectation : No Results
SELECT 
  prd_key, 
  COUNT(*) duplicate_count
FROM
  gold.dim_products
GROUP BY prd_key
HAVING COUNT(*) > 1

-- =============================================================
-- Checking 'gold.fact_sales'
-- =============================================================
-- Check the data model connectivity fact and dimensions
SELECT *
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
lEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
WHERE c.customer_key IS NULL
	OR p.product_key IS NULL
