----- Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----- Data vypovídají o pozitivní korelaci mezi GDP a mzdami. Mzdy ve většině let reagují na GDP (kromě roků 2009-2010, 2013-2014). Vyšší GDP obvykle znamená vyšší růst mezd v roce následujícím. Pokud klesne GDP, poklesne v následujícím roce i růst mezd.
----- Závislost cen potravin na GDP není jednoznačná, mezi lety 2007 až 2011 lze vidět pozitivní korelaci, ale v letech 2012 až 2016 negativní. S klesajícím GDP nejprve rostou ceny potravin a následně se zvyšujícím se GDP ceny potravin klesají.
----- Data o mzdách jsou k dispozici za roky 2000 až 2021, data o potravinách za roky 2006 až 2018 a ekonomické údaje státu (ČR) za roky 1990 až 2020. Srovnávané období je tedy 2007 až 2018. Rok 2006 nelze srovnat, nejsou k dispozici data o cenách potravin za předchozí rok.

WITH wages AS
(   
	SELECT 
		payroll_year,
		ROUND (AVG (v1)) AS avg_wage,
		LAG (AVG (v1)) OVER (ORDER BY (payroll_year)) AS avg_wage_previous_year,
		(ROUND (AVG (v1)) - LAG (AVG (v1)) OVER (ORDER BY (payroll_year))) AS wage_difference,
		ROUND(((AVG (v1)-LAG (AVG (v1)) OVER (ORDER BY (payroll_year)))/LAG (AVG (v1)) OVER (ORDER BY (payroll_year)) * 100)::NUMERIC, 2) AS wage_development_percentage
	FROM t_jiri_waloschek_projekt_sql_primary_final
	GROUP BY payroll_year
	ORDER BY payroll_year 
), categories AS
(
	SELECT 
		year as year2,
		AVG (value) AS category_avg_price,
		LAG (AVG(value)) OVER (ORDER BY (year)) AS category_avg_price_previous_year,
		ROUND(((AVG(value)-LAG (AVG(value)) OVER (ORDER BY (year)))/LAG (AVG(value)) OVER (ORDER BY (year)) * 100)::NUMERIC, 2) AS category_development_percentage
	FROM t_jiri_waloschek_projekt_sql_primary_final
	GROUP BY year2
	ORDER BY year2
), gdp AS 
(
	SELECT
		year,
		gdp,
		country,
		LAG(gdp) OVER (ORDER BY (year)),
		ROUND(((gdp - (LAG(gdp) OVER (ORDER BY year ASC)))/(LAG(gdp) OVER (ORDER BY year ASC)) * 100)::NUMERIC, 2) AS gdp_development_percentage
	FROM t_jiri_waloschek_projekt_SQL_secondary_final
	WHERE country = 'Czech Republic'
	GROUP BY year, country, gdp
)
SELECT 
	year,
	wage_development_percentage,
	category_development_percentage,
	gdp_development_percentage
FROM wages w
JOIN categories c
	ON c.year2 = w.payroll_year
JOIN gdp 
	ON c.year2 = gdp.year
