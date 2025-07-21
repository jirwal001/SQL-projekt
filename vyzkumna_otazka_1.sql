----- Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
-----------------------------------------------------------------------------
----- I přes poklesy mezd v některých letech v některých odvětvích je ve všech odvětvích trend rostoucí.
----- Odvětví S(Ostatní činnosti), N(Administrativní a podpůrné činnosti), H(Doprava a skladování), Q(Zdravotní a sociální péče) rostly ve všech sledovaných letech.
----- Nejvíce poklesů mezd zaznamenaly odvětví: B (Těžba a dobývání) 4, a odvětvím: O (Veřejná správa a obrana; povinné sociální zabezpečení), R (Kulturní, zábavní a rekreační činnosti), I (Ubytování, stravování a pohostinství) poklesla mzda 3x

with porovnani_mezd_1 as( 
select 
industry_branch_code as odvetvi, 
payroll_year as rok, 
avg (value) as prumerna_mzda,
lag (avg (value)) over (partition by industry_branch_code order by industry_branch_code, payroll_year) as prumerna_mzda_loni,
avg (value) - lag (avg (value)) over (partition by industry_branch_code order by payroll_year) as mezirocni_rozdil,
	case 
		when avg (value) - lag (avg (value)) over (partition by industry_branch_code order by payroll_year) > 0 then 'roste' else 'klesa'
	end as vyvoj
from czechia_payroll cp 
where value_type_code = '5958' and calculation_code = '100'
group by industry_branch_code, payroll_year  
order by industry_branch_code, payroll_year asc
)
select
odvetvi,
count (vyvoj) as pocet_roste
from porovnani_mezd_1
where rok between 2001 and 2021 and vyvoj = 'roste' and odvetvi is not null and prumerna_mzda_loni is not null
group by odvetvi
order by count(vyvoj) desc
