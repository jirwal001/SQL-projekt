CREATE TABLE t_jiri_waloschek_projekt_sql_primary_final AS
WITH wages AS
(
	SELECT 
		payroll_year,
        	industry_branch_code,
		value AS v1
	FROM czechia_payroll
	WHERE value_type_code = 5958 AND calculation_code = 100
), avg_prices AS
(
	SELECT
		date_part('year', date_from) AS year,
		category_code,
		value
	FROM czechia_price 
), industry_branch AS
(
	SELECT
		code,
		name
	FROM czechia_payroll_industry_branch c 
), product_category AS
(
	SELECT
		code AS product_code,
		name AS product_name
	FROM czechia_price_category cpc
)
SELECT
	*
FROM wages w
LEFT JOIN avg_prices avp
	ON w.payroll_year = avp.year
LEFT JOIN industry_branch idb
	ON idb.code = w.industry_branch_code
LEFT JOIN product_category pdc
	ON pdc.product_code = avp.category_code
