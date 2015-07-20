
update cglsldoaux2
set balance_inicio = f_saldo_auxiliar(compania, cuenta, auxiliar, '2013-06-30',2)
where compania = '03'
and year = 2013
and periodo = 7;


insert into cglsldoaux2(compania, cuenta,
auxiliar, year, periodo, balance_inicio,
debito, credito)
select compania, cuenta,
auxiliar, year, periodo+1, debito-credito, 0, 0
from v_cglsldoaux2
where compania = '03'
and year = 2013
and periodo = 6
