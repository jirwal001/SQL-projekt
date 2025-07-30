----- Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
-----------------------------------------------------------------------------------------------------
----- Nejpomaleji zdražuje kategorie banány žluté (116103) o 7,4 %.
----- Kategorie Cukr krystalový (118101) zlevnila o 27,5 %, a rajská jablka červená kulatá (117101) zlevnila o 23,1 %.
----- Data s cenami produktů jsou k dispozici za roky 2006 až 2018.
----- Kategorie (212101) Jakostní víno bílé má dostupná data pouze za roky 2015 až 2018 a není uvedena ve výsledné tabulce.

WITH categories AS
(
	SELECT 
		year,
		category_code,
		product_name,
		ROUND(AVG (value)::NUMERIC, 2) AS average,
		ROUND(LAG (AVG (value)) OVER (PARTITION BY category_code ORDER BY category_code)::NUMERIC, 2) AS avg_previous_year,
		AVG(value) - LAG(AVG (value)) OVER (PARTITION BY category_code ORDER BY category_code, year) AS avg_difference,
		(AVG(value) - LAG(AVG (value)) OVER (PARTITION BY category_code ORDER BY category_code, year)) / LAG(AVG (value)) OVER (PARTITION BY category_code ORDER BY category_code, year) * 100 AS percentage
	FROM t_jiri_waloschek_projekt_sql_primary_final
	WHERE year IN (2006, 2018)
	GROUP BY category_code, year, product_name
	ORDER BY category_code, year ASC
)
SELECT
	category_code,
	product_name AS category_name,
	ROUND(percentage::NUMERIC, 2) AS price_increase_percentage
FROM categories
WHERE percentage IS NOT NULL
GROUP BY category_code, product_name, percentage 
ORDER BY percentage ASC
