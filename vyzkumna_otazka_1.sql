----- Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
-----------------------------------------------------------------------------
----- I přes poklesy mezd v některých letech v některých odvětvích je ve všech odvětvích trend rostoucí.
----- Odvětví S(Ostatní činnosti), N(Administrativní a podpůrné činnosti), H(Doprava a skladování), Q(Zdravotní a sociální péče) rostla ve všech sledovaných letech.
----- Nejvíce poklesů mezd zaznamenala odvětví: B (Těžba a dobývání) 4, a odvětvím: O (Veřejná správa a obrana; povinné sociální zabezpečení), R (Kulturní, zábavní a rekreační činnosti), I (Ubytování, stravování a pohostinství) poklesla mzda 3x
----- Data se mzdami jsou k dispozici za roky 2000 až 2021.

WITH wage_comparison AS 
(
	SELECT 
		industry_branch_code,
		name,
		payroll_year,
		AVG (v1),
		LAG (AVG (v1)) OVER (PARTITION BY industry_branch_code ORDER BY industry_branch_code, payroll_year) as avg_wage_previous_year,
		AVG (v1) - LAG (AVG (v1)) OVER (PARTITION BY industry_branch_code ORDER BY payroll_year) AS y_o_y_difference,
		CASE 
			WHEN AVG (v1) - LAG (AVG (v1)) OVER (PARTITION BY industry_branch_code ORDER BY payroll_year) > 0 THEN 'growth' 
			ELSE 'decline'
		END AS wage_development
	FROM t_jiri_waloschek_projekt_sql_primary_final
	GROUP BY industry_branch_code, name, payroll_year
	ORDER BY industry_branch_code, payroll_year 
)
SELECT
	industry_branch_code,
	name AS branch_name,
	COUNT (wage_development) AS number_of_growth
FROM wage_comparison
WHERE payroll_year BETWEEN 2001 AND 2021 
	AND wage_development = 'growth' 
	AND industry_branch_code IS NOT NULL 
	AND avg_wage_previous_year IS NOT NULL
GROUP BY industry_branch_code, name
ORDER BY COUNT(wage_development) DESC
