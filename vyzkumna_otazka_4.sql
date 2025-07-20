----- Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
-------------------------------------------------------------------------------------------------------------
----- ne, v roce 2017 ceny potravin sice dosáhly téměř 10% růstu, ale růst mezd nebyl výrazně nižší (6,19 %)
----- největší procentualní rozdíl mezi mzdami a cenami potravin byl v roce 2009, potraviny klesly o 6,8 % a mzdy vzrostly o 3,09 % (nejde zde však o růst cen potravin) 
----- rok 2006 nelze srovnat, nemáme k dispozici kompletní data, chybí data o cenách potravin za předchozí rok 2005 
----- data o mzdách jsou k dispozici za roky 2000-2021
----- data o potravinách jsou k dispozici za roky 2006-2018

with mzdy as(   
select 
payroll_year as rok,
avg (value) as prumer_mzda,
lag (avg (value)) over (order by (payroll_year)) as prumer_mzda_loni,
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
