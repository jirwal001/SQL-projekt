create table t_jiri_waloschek_projekt_sql_primary_final as
with mzdy as
(
	select 
		payroll_year,
        industry_branch_code,
		value as v1
	from czechia_payroll cp
	where value_type_code = '5958' and calculation_code = '100'
), prum_ceny as
(
	select
		date_part('year', date_from) as year,
		category_code,
		value
	from czechia_price cp 
)
select
*
from mzdy
left join prum_ceny pc on mzdy.payroll_year = pc.year
