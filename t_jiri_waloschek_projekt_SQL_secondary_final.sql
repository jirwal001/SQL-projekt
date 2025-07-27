create table t_jiri_waloschek_projekt_SQL_secondary_final as
with hdp as
(
	select
		country, 
		year,
		gdp,
		lag(gdp) over (order by (year)),
		round(((gdp - (lag(gdp) over (order by year asc)))/(lag(gdp) over (order by year asc)) * 100)::numeric, 6) as vyvoj_gdp_proc
	from economies e 
	where country = 'Czech Republic'
	group by year, country, gdp
)
select * from hdp
