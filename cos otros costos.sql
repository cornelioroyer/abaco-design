select b.compania, b.year, b.periodo, a.rubro, sum(b.debito-b.credito) as corriente, 
sum(b.balance_inicio+b.debito-b.credito) as acumulado
from cos_cuenta_rubro a, cglsldocuenta b
where a.cuenta = b.cuenta
group by b.compania, b.year, b.periodo, a.rubro
order by b.compania, b.year, b.periodo, a.rubro