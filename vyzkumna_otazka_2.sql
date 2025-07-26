-----Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
-----------------------------------------------------------------------------------------------------------------------------------
----- V roce 2006 si bylo možno za průměrnou mzdu pro daný rok koupit 1257 chleba, v roce 2018 1317 chleba.
----- V roce 2006 si bylo možno za průměrnou mzdu pro daný rok koupit 1403 l mléka, v roce 2018 1611 l mléka.
----- Data s cenami produktů jsou k dispozici za roky 2006 až 2018 a s příjmy 2001 až 2021. Srovnávané období je tedy 2006 až 2018.

with prum_ceny as
(
	select
		year,
		category_code,
		round(avg(value)::numeric, 2) as prum_cena
		from t_jiri_waloschek_projekt_sql_primary_final 
	group by year, category_code
	having category_code IN (111301, 114201) and year in (2006, 2018)
	order by year
),
prum_platy as 
(
	select
		payroll_year,
		avg(v1) as prum_plat
		from t_jiri_waloschek_projekt_sql_primary_final 
	group by payroll_year
	having payroll_year in (2006, 2018)
	order by payroll_year 
)
select 
	year as rok,
	category_code as produkt,
	prum_cena,
	prum_plat,
	round((prum_plat / prum_cena)::numeric, 0) as vysledek
from prum_platy pp
join prum_ceny pc on pc.year = pp.payroll_year
order by pc.category_code 

--------------------------
  SMAZAT

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
