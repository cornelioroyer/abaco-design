rollback work;

begin work;
    update invparal
    set valor = 'N'
    where parametro = 'valida_existencias'
    and almacen in (select almacen from almacen where compania = '05');
commit work;

begin work;
    update invparal
    set valor = '0'
    where parametro = 'sec_eys'
    and almacen in (select almacen from almacen where compania = '05');
commit work;


begin work;
    delete from eys1
    where motivo = '02'
    and almacen in (select almacen from almacen where compania = '05')
    and aplicacion_origen = 'TAL'
    and fecha between '2007-12-01' and '2009-12-15';
commit work;

begin work;
    delete from eys1
    where aplicacion_origen = 'FAC'
    and almacen in (select almacen from almacen where compania = '05')
    and fecha between '2007-12-01' and '2009-12-15';
commit work;

begin work;
    delete from cglposteo
    where aplicacion_origen in ('TAL')
    and fecha_comprobante between '2007-12-01' and '2009-12-09'
    and compania = '05';
commit work;

begin work;
    select f_update_inventario('05');
commit work;

begin work;
    select f_postea_inventario('05');
commit work;

begin work;
    update invparal
    set valor = 'S'
    where parametro = 'valida_existencias'
    and almacen in (select almacen from almacen where compania = '05');
commit work;
