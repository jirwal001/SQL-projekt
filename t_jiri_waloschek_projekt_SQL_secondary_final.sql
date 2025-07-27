create table t_jiri_waloschek_projekt_SQL_secondary_final as
with hdp as
(
	select
		country, 
		year,
		gdp,
		gini,
		population
	from economies e 
	where year between 2006 and 2018
	group by year, country, gdp, gini, population
	order by country, year
)
select * from hdp
