
rollback work;


update gralparaxcia
set valor = 'N'
where parametro = 'validar_fecha'
and aplicacion = 'CXC';


begin work;
    delete from cxcdocm
    where almacen in (select almacen from almacen where compania = '01')
    and documento <> docmto_aplicar
    and fecha_posteo >= '2014-08-01';
commit work;

begin work;
    delete from cxcdocm
    where almacen in (select almacen from almacen where compania = '01')
    and fecha_posteo >= '2014-08-01';
commit work;


begin work;
    select f_update_cxcdocm_fac('01');
commit work;

begin work;
    select f_update_cxcdocm_cxc('01');
commit work;


update gralparaxcia
set valor = 'S'
where parametro = 'validar_fecha'
and aplicacion = 'CXC';


