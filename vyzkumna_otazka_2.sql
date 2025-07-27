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
		nazev_produktu,
		round(avg(value)::numeric, 2) as prum_cena
		from t_jiri_waloschek_projekt_sql_primary_final
	where category_code IN (111301, 114201) and year in (2006, 2018)
	group by year, category_code, nazev_produktu	
	order by year
),
prum_platy as 
(
	select
		payroll_year,
		avg(v1) as prum_plat
		from t_jiri_waloschek_projekt_sql_primary_final
	where payroll_year in (2006, 2018)
	group by payroll_year
	order by payroll_year 
)
select 
	year as rok,
	category_code as kategorie_potravin,
	nazev_produktu as nazev_kategorie,
	prum_cena,
	prum_plat,
	round((prum_plat / prum_cena)::numeric, 0) as vysledek
from prum_platy pp
join prum_ceny pc on pc.year = pp.payroll_year
order by pc.category_code 
