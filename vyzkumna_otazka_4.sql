----- Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
-------------------------------------------------------------------------------------------------------------
----- Neexistuje. V roce 2017 ceny potravin sice dosáhly téměř 10% růstu (9,98 %), ale růst mezd nebyl výrazně nižší (6,43 %).
----- Největší procentuální rozdíl mezi mzdami a cenami potravin byl v roce 2009. Potraviny klesly o 6,8 % a mzdy vzrostly o 3,25 % (nejde zde však o růst cen potravin). 
----- Data o mzdách jsou k dispozici za roky 2000 až 2021 a data o potravinách za roky 2006 až 2018. Srovnávané období je tedy 2007 až 2018.
----- Rok 2006 nelze srovnat, nejsou k dispozici kompletní data – chybí data o cenách potravin za předchozí rok 2005. 

with mzdy as(   
select 
payroll_year as rok,
avg (value) as prumer_mzda,
lag (avg (value)) over (order by (payroll_year)) as prumer_mzda_loni,
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
round(((avg(value)-lag (avg(value)) over (order by (date_part ('year', date_from))))/lag (avg(value)) over (order by (date_part ('year', date_from))) * 100)::numeric, 2) as procenta_potraviny
from czechia_price cp 
group by rok2
order by rok2
)
select 
rok,
procenta_mzdy,
procenta_potraviny,
procenta_potraviny - procenta_mzdy as rozdil_procent
from mzdy
join potraviny on rok2 = rok;
