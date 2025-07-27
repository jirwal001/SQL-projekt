----- Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----- Data vypovídají o pozitivní korelaci mezi GDP a mzdami. Mzdy ve většině let reagují na GDP (kromě roků 2009-2010, 2013-2014). Vyšší GDP obvykle znamená vyšší růst mezd v roce následujícím. Pokud klesne GDP, poklesne v následujícím roce i růst mezd.
----- Závislost cen potravin na GDP není jednoznačná, mezi lety 2007 až 2011 lze vidět pozitivní korelaci, ale v letech 2012 až 2016 negativní. S klesajícím GDP nejprve rostou ceny potravin a následně se zvyšujícím se GDP ceny potravin klesají.
----- Data o mzdách jsou k dispozici za roky 2000 až 2021, data o potravinách za roky 2006 až 2018 a ekonomické údaje státu (ČR) za roky 1990 až 2020. Srovnávané období je tedy 2007 až 2018. Rok 2006 nelze srovnat, nejsou k dispozici data o cenách potravin za předchozí rok.

with mzdy as
(   
	select 
		payroll_year as rok,
		round (avg (v1)) as prumer_mzda,
		lag (avg (v1)) over (order by (payroll_year)) as prumer_mzda_loni,
		(round (avg (v1)) - lag (avg (v1)) over (order by (payroll_year))) as rozdil_mezd,
		round(((avg (v1)-lag (avg (v1)) over (order by (payroll_year)))/lag (avg (v1)) over (order by (payroll_year)) * 100)::numeric, 2) as procenta_mzdy
	from t_jiri_waloschek_projekt_sql_primary_final
	group by payroll_year
	order by payroll_year 
), potraviny as
(
	select 
		year as rok2,
		avg (value) as prum_cen_potr,
		lag (avg(value)) over (order by (year)) as prum_cen_potr_loni,
		round(((avg(value)-lag (avg(value)) over (order by (year)))/lag (avg(value)) over (order by (year)) * 100)::numeric, 2) as procenta_potr
	from t_jiri_waloschek_projekt_sql_primary_final
	group by rok2
	order by rok2
), gdp as 
(
	select
		year,
		gdp,
		country,
		lag(gdp) over (order by (year)),
		round(((gdp - (lag(gdp) over (order by year asc)))/(lag(gdp) over (order by year asc)) * 100)::numeric, 2) as vyvoj_gdp_proc
	from t_jiri_waloschek_projekt_SQL_secondary_final
	where country = 'Czech Republic'
	group by year, country, gdp
)
	select 
		rok,
		procenta_mzdy,
		procenta_potr,
		vyvoj_gdp_proc
	from mzdy
	join potraviny on rok2 = rok
	join gdp on rok2 = year
