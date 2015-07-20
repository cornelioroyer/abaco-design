insert into cglsldoaux2(compania, cuenta,
auxiliar, year, periodo, balance_inicio,
debito, credito)
select compania, cuenta,
auxiliar, year, periodo, 0, debito, credito
from v_cglsldoaux2
