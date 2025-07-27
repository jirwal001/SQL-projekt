create table t_jiri_waloschek_projekt_sql_primary_final as
with mzdy as
(
	select 
		payroll_year,
        industry_branch_code,
		value as v1
	from czechia_payroll
	where value_type_code = '5958' and calculation_code = '100'
), prum_ceny as
(
	select
		date_part('year', date_from) as year,
		category_code,
		value
	from czechia_price 
), kategorie_odvetvi as
(
	select
		code,
		name
	from czechia_payroll_industry_branch c 
), kategorie_produkt as
(
	select
		code as kod_produktu,
		name as nazev_produktu
	from czechia_price_category cpc
)
select
*
from mzdy m
left join prum_ceny pc on m.payroll_year = pc.year
left join kategorie_odvetvi on code = industry_branch_code
left join kategorie_produkt on kod_produktu = category_code
