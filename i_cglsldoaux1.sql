insert into cglsldoaux1 select compania, cuenta, auxiliar, year, periodo,
balance_inicio, debito, credito from tmp_cglsldoaux1
where exists (select * from cglsldocuenta
where cglsldocuenta.compania = tmp_cglsldoaux1.compania
and cglsldocuenta.cuenta = tmp_cglsldoaux1.cuenta
and cglsldocuenta.year = tmp_cglsldoaux1.year
and cglsldocuenta.periodo = tmp_cglsldoaux1.periodo)