----- Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
-------------------------------------------------------------------------------------------------------------
----- Neexistuje. V roce 2017 ceny potravin sice dosáhly téměř 10% růstu (9,98 %), ale růst mezd nebyl výrazně nižší (6,43 %).
----- Největší procentuální rozdíl mezi mzdami a cenami potravin byl v roce 2009. Potraviny klesly o 6,8 % a mzdy vzrostly o 3,25 % (nejde zde však o růst cen potravin). 
----- Data o mzdách jsou k dispozici za roky 2000 až 2021 a data o potravinách za roky 2006 až 2018. Srovnávané období je tedy 2007 až 2018.
----- Rok 2006 nelze srovnat, nejsou k dispozici data za předchozí rok. 

WITH wages AS
(   
	SELECT 
		payroll_year,
		AVG (v1) AS avg_wage,
		LAG (AVG (v1)) OVER (ORDER BY (payroll_year)) AS avg_wage_previous_year,
		ROUND(((AVG (v1)-LAG (AVG (v1)) OVER (ORDER BY (payroll_year)))/LAG (AVG (v1)) OVER (ORDER BY (payroll_year)) * 100)::NUMERIC, 2) AS wage_percentage
	FROM t_jiri_waloschek_projekt_sql_primary_final
	GROUP BY payroll_year
	ORDER BY payroll_year 
), categories AS
(
	SELECT 
		year,
		AVG (value) AS category_avg_price,
		LAG (AVG(value)) OVER (ORDER BY (year)) AS category_avg_price_previous_year,
		ROUND(((AVG(value)-LAG (AVG(value)) OVER (ORDER BY (year)))/LAG (AVG(value)) OVER (ORDER BY ((year))) * 100)::NUMERIC, 2) AS category_percentage
	FROM t_jiri_waloschek_projekt_sql_primary_final
	GROUP BY year
	ORDER BY year
)
SELECT 
	payroll_year,
	wage_percentage,
	category_percentage,
	category_percentage - wage_percentage AS difference_percentage
FROM wages w
JOIN categories c
	ON c.year = w.payroll_year;
