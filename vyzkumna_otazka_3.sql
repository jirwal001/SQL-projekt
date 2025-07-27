----- Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
-----------------------------------------------------------------------------------------------------
----- Nejpomaleji zdražuje kategorie banány žluté (116103) o 7,4 %.
----- Kategorie Cukr krystalový (118101) zlevnila o 27,5 %, a rajská jablka červená kulatá (117101) zlevnila o 23,1 %.
----- Data s cenami produktů jsou k dispozici za roky 2006 až 2018.
----- Kategorie (212101) Jakostní víno bílé má dostupná data pouze za roky 2015 až 2018 a není uvedena ve výsledné tabulce.

with tabulka_potravin as
(
	select 
		year,
		category_code,
		nazev_produktu,
		round(avg (value)::numeric, 2) as prumer,
		round(lag (avg (value)) over (partition by category_code order by category_code)::numeric, 2) as prumer_predchozi,
		avg(value) - lag(avg (value)) over (partition by category_code order by category_code, year) as rozdil_prumeru,
		(avg(value) - lag(avg (value)) over (partition by category_code order by category_code, year)) / lag(avg (value)) over (partition by category_code order by category_code, year) * 100 as procenta
from t_jiri_waloschek_projekt_sql_primary_final
where year in (2006, 2018)
group by category_code, year, nazev_produktu
order by category_code, year asc
)
select
	category_code as kategorie_potravin,
	nazev_produktu as nazev_kategorie,
	round(procenta::numeric, 2) as procento_zdrazeni
from tabulka_potravin
where procenta is not null
group by category_code, nazev_produktu, procenta 
order by procenta asc
