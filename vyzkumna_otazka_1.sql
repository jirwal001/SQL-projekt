----- Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
-----------------------------------------------------------------------------
----- I přes poklesy mezd v některých letech v některých odvětvích je ve všech odvětvích trend rostoucí.
----- Odvětví S(Ostatní činnosti), N(Administrativní a podpůrné činnosti), H(Doprava a skladování), Q(Zdravotní a sociální péče) rostla ve všech sledovaných letech.
----- Nejvíce poklesů mezd zaznamenala odvětví: B (Těžba a dobývání) 4, a odvětvím: O (Veřejná správa a obrana; povinné sociální zabezpečení), R (Kulturní, zábavní a rekreační činnosti), I (Ubytování, stravování a pohostinství) poklesla mzda 3x
----- Data se mzdami jsou k dispozici za roky 2000 až 2021.

with porovnani_mezd_1 as 
(
	select 
		industry_branch_code,
		name,
		payroll_year,
		avg (v1),
		lag (avg (v1)) over (partition by industry_branch_code order by industry_branch_code, payroll_year) as prumerna_mzda_loni,
		avg (v1) - lag (avg (v1)) over (partition by industry_branch_code order by payroll_year) as mezirocni_rozdil,
		case 
			when avg (v1) - lag (avg (v1)) over (partition by industry_branch_code order by payroll_year) > 0 then 'roste' else 'klesa'
		end as vyvoj
	from t_jiri_waloschek_projekt_sql_primary_final
	group by industry_branch_code, name, payroll_year
	order by industry_branch_code, payroll_year 
)
select
	industry_branch_code as odvetvi,
	name as odvetvi_nazev,
	count (vyvoj) as pocet_roste
from porovnani_mezd_1
where payroll_year between 2001 and 2021 and vyvoj = 'roste' and industry_branch_code is not null and prumerna_mzda_loni is not null
group by industry_branch_code, name
order by count(vyvoj) desc
