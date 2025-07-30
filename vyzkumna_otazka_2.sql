-----Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
-----------------------------------------------------------------------------------------------------------------------------------
----- V roce 2006 si bylo možno za průměrnou mzdu pro daný rok koupit 1257 chleba, v roce 2018 1317 chleba.
----- V roce 2006 si bylo možno za průměrnou mzdu pro daný rok koupit 1403 l mléka, v roce 2018 1611 l mléka.
----- Data s cenami produktů jsou k dispozici za roky 2006 až 2018 a s příjmy 2001 až 2021. Srovnávané období je tedy 2006 až 2018.

WITH avg_prices AS
(
	SELECT
		year,
		category_code,
		product_name,
		ROUND(AVG(value)::NUMERIC, 2) AS avg_price
		FROM t_jiri_waloschek_projekt_sql_primary_final
	WHERE category_code IN (111301, 114201) 
		AND year in (2006, 2018)
	GROUP BY year, category_code, product_name	
	ORDER BY year
), avg_wages AS 
(
	SELECT
		payroll_year,
		AVG(v1) AS avg_wage
		FROM t_jiri_waloschek_projekt_sql_primary_final
	WHERE payroll_year in (2006, 2018)
	GROUP BY payroll_year
	ORDER BY payroll_year 
)
SELECT 
	year,
	category_code,
	product_name as category_name,
	avg_price,
	avg_wage,
	ROUND((avg_wage / avg_price)::NUMERIC, 2) AS result
FROM avg_wages awg
JOIN avg_prices apc 
	ON apc.year = awg.payroll_year
ORDER BY category_code 
