----- Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----- z dat lze vidět pozitivní korelaci mezi GDP a mzdami, mzdy ve většine let reagují na GDP, vyšší GDP obykle znamená vyšší růst mezd, pokud klesne GDP, poklesne v následujícím období(roce) i růst mezd
----- závislost cen potravin na GDP není jednoznačná, mezi lety 2007-2011 lze vidět pozitvní korelaci, ale v letech 2012-2016 negativní, s klesajícím GDP nejprve rostou ceny portavin ale následně se 
----- zvyšujícím se GDP snižující se ceny potravin  

create temporary table tmp_5 as
with mzdy as(   
select 
payroll_year as rok,
round (avg (value)) as prumer_mzda,
lag (avg (value)) over (order by (payroll_year)) as prumer_mzda_loni,
(round (avg (value)) - lag (avg (value)) over (order by (payroll_year))) as rozdilmezd,
round(((avg (value)-lag (avg (value)) over (order by (payroll_year)))/lag (avg (value)) over (order by (payroll_year)) * 100)::numeric, 2) as procenta_mzdy
from czechia_payroll cp 
where value_type_code = 5958 and calculation_code = 200 
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
