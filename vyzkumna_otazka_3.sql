----- Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
-----------------------------------------------------------------------------------------------------
----- Nejpomaleji zdražuje kategorie banány žluté (116103) o 7,4 %.
----- Kategorie Cukr krystalový (118101) zlevnila o 27,5 %, a rajská jablka červená kulatá (117101) zlevnila o 23,1 %.
----- Data s cenami produktů jsou k dispozici za roky 2006 až 2018.

with tabulka_potravin as(
select 
date_part('year', date_from) as year,
category_code,
round(avg (value)::numeric, 2) as prumer,
round(lag (avg (value)) over (partition by category_code order by category_code)::numeric, 2) as prumer_predchozi,
avg(value) - lag(avg (value)) over (partition by category_code order by category_code, date_part('year', date_from)) as rozdil_prumeru,
(avg(value) - lag(avg (value)) over (partition by category_code order by category_code, date_part('year', date_from))) / lag(avg (value)) over (partition by category_code order by category_code, date_part('year', date_from)) * 100 as procenta
from czechia_price cp 
where date_part('year', date_from) in (2006, 2018)
group by category_code, year
order by category_code, year asc
)
select
category_code as kategorie_potravin,
round(procenta::numeric, 2) as procento_zdrazeni
from tabulka_potravin
where procenta is not null
group by category_code, procenta 
order by round(procenta::numeric, 0) asc
