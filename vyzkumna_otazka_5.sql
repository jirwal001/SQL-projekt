----- Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----- Data vypovídají o pozitivní korelaci mezi GDP a mzdami. Mzdy ve většině let reagují na GDP (kromě roků 2009-2010, 2013-2014). Vyšší GDP obvykle znamená vyšší růst mezd v roce následujícím. Pokud klesne GDP, poklesne v následujícím roce i růst mezd.
----- Závislost cen potravin na GDP není jednoznačná, mezi lety 2007 až 2011 lze vidět pozitivní korelaci, ale v letech 2012 až 2016 negativní. S klesajícím GDP nejprve rostou ceny potravin a následně se zvyšujícím se GDP ceny potravin klesají.
----- Data o mzdách jsou k dispozici za roky 2000 až 2021, data o potravinách za roky 2006 až 2018 a ekonomické údaje státu (ČR) za roky 1990 až 2020. Srovnávané období je tedy 2007 až 2018. Rok 2006 nelze srovnat, nejsou k dispozici data o cenách potravin za předchozí rok.

create temporary table tmp_5 as
with mzdy as(   
select 
payroll_year as rok,
round (avg (value)) as prumer_mzda,
lag (avg (value)) over (order by (payroll_year)) as prumer_mzda_loni,
(round (avg (value)) - lag (avg (value)) over (order by (payroll_year))) as rozdilmezd,
round(((avg (value)-lag (avg (value)) over (order by (payroll_year)))/lag (avg (value)) over (order by (payroll_year)) * 100)::numeric, 2) as procenta_mzdy
from czechia_payroll cp 
where value_type_code = 5958 and calculation_code = 100 
group by payroll_year
order by payroll_year 
), potraviny as
(
select 
date_part ('year', date_from) as rok2,
avg (value) as prum_cen_potr,
lag (avg(value)) over (order by (date_part ('year', date_from))) as prum_cen_potr_loni,
round(((avg(value)-lag (avg(value)) over (order by (date_part ('year', date_from))))/lag (avg(value)) over (order by (date_part ('year', date_from))) * 100)::numeric, 2) as procenta_potr
from czechia_price cp 
group by rok2
order by rok2
)
select 
*,
procenta_potr - procenta_mzdy as rozdil_procent
from mzdy
join potraviny on rok2 = rok;


select
tmp_5.rok,
tmp_5.procenta_mzdy as vyvoj_mezd_proc,
tmp_5.procenta_potr as vyvoj_potravin_proc,
round(((gdp - (lag(gdp) over (order by year asc)))/(lag(gdp) over (order by year asc)) * 100)::numeric, 2) as vyvoj_gdp_proc
from economies e 
join tmp_5 on e."year" = rok
where country = 'Czech Republic'
