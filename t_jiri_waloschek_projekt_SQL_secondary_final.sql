CREATE TABLE t_jiri_waloschek_projekt_SQL_secondary_final AS
WITH gdp AS
(
	SELECT
		country, 
		year,
		gdp,
		gini,
		population
	FROM economies e 
	WHERE year BETWEEN 2006 AND 2018
	GROUP BY year, country, gdp, gini, population
	ORDER BY country, year
)
SELECT 
	* 
FROM gdp
