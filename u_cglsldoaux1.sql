rollback work;

begin work;
    update cglsldoaux1
    set debito = 0, credito = 0
    where cglsldoaux1.year = 2011
    and cglsldoaux1.periodo = 1
    and cglsldoaux1.compania = '03';
commit work;

/*
begin work;
update cglsldocuenta
set debito = 0, credito = 0
where cglsldocuenta.year = 2007
and cglsldocuenta.periodo = 2
and cglsldocuenta.compania = '03';
commit work;

begin work;
update cglsldocuenta
set debito = v_cglposteo.debito, credito = v_cglposteo.credito
where cglsldocuenta.compania = v_cglposteo.compania
and cglsldocuenta.year = v_cglposteo.year
and cglsldocuenta.periodo = v_cglposteo.periodo
and cglsldocuenta.cuenta = v_cglposteo.cuenta
and cglsldocuenta.year = 2007
and cglsldocuenta.periodo = 2
and cglsldocuenta.compania = '03';
commit work;
*/


begin work;
    update cglsldoaux1
    set debito = v_cglsldoaux1.debito,
    credito = v_cglsldoaux1.credito
    from v_cglsldoaux1
    where cglsldoaux1.compania = v_cglsldoaux1.compania
    and cglsldoaux1.cuenta = v_cglsldoaux1.cuenta
    and trim(cglsldoaux1.auxiliar) = trim(v_cglsldoaux1.auxiliar)
    and cglsldoaux1.year = v_cglsldoaux1.year
    and cglsldoaux1.periodo = v_cglsldoaux1.periodo
    and cglsldoaux1.year = 2011
    and cglsldoaux1.periodo = 1
    and cglsldoaux1.compania = '03';
commit work;
