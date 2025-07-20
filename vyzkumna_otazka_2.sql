-----Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
-----------------------------------------------------------------------------------------------------------------------------------
----- v roce 2006 si bylo možno za průměrnou mzdu pro daný rok koupit 1257 chleba, v roce 2018 1317 chleba
----- v roce 2006 si bylo možno za průměrnou mzdu pro daný rok koupit 1403 l mléka, v roce 2018 1611 l mléka
----- data s cenami produktů jsou k dipozici v letech 2006 až 2018 a data s příjmy v letech 2001 až 2021, tudíž první rok, který bylo možno srovnat, byl 2006 a poslední 2018

with PRUM_CENY as( -- PRUM CENY JSOU 2006-2018
select
date_part('year', date_from) as year,
category_code,
AVG(value) as PRUM_CENA
from czechia_price cp 
where category_code IN (111301, 114201) and date_part('year', date_from) in (2006, 2018)--111301 chleba, 114201 mléko
group by year, category_code 
order by year
),
PRUM_PLATY as ( --PRUM PLATY JSOU 2000 AŽ 2021
select 
payroll_year, 
AVG(value) as PRUM_PLAT
from czechia_payroll cp 
where value_type_code = '5958' and calculation_code = '100' and payroll_year in (2006, 2018)
group by payroll_year 
order by payroll_year
)
select
year as rok,
CATEGORY_CODE as produkt,
prum_cena,
prum_plat,
round((PRUM_PLAT / PRUM_CENA)::numeric, 2) AS VYSLEDEK
from PRUM_PLATY PP
join PRUM_CENY PC on PC.year = PP.PAYROLL_YEAR
order by category_code
