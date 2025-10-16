/*
==============================================================
	Data Segmentation / Segmentation des données
==============================================================
En:	
	Group the data based on a specific range.
	Helps understand the correlation between two measures.
Fr:
	Regroupez les données en fonction d'une plage spécifique.
	Aide à comprendre la corrélation entre deux mesures.
==============================================================
*/

-- Segment products into cost ranges and count how many products fall into each segment.
-- Segmentez les produits en fonction de leur gamme de prix et comptez le nombre de produits appartenant à chaque segment.
WITH product_segments AS (
	SELECT 
		product_key
		,product_name
		,cost
		,CASE WHEN cost < 100 THEN 'Below 100'
			WHEN cost BETWEEN 100 AND 500 THEN '100-500'
			WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
			ELSE 'Above 1000'
		END cost_range
	FROM gold.dim_products
)

SELECT
	cost_range
	,COUNT(product_key) total_products
FROM product_segments
GROUP BY cost_range
ORDER BY total_products DESC
