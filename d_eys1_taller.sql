rollback work;

begin work;
    update invparal
    set valor = 'N'
    where parametro = 'valida_existencias'
    and almacen in (select almacen from almacen where compania = '01');
commit work;

begin work;
    update invparal
    set valor = '0'
    where parametro = 'sec_eys'
    and almacen in (select almacen from almacen where compania = '01');
commit work;


begin work;
    delete from eys1
    where motivo = '02'
    and almacen in (select almacen from almacen where compania = '01')
    and aplicacion_origen = 'TAL'
    and fecha >= '2007-01-01';
commit work;

begin work;
    delete from eys1
    where aplicacion_origen = 'FAC'
    and almacen in (select almacen from almacen where compania = '01')
    and fecha >= '2007-01-01';
commit work;


begin work;
    select f_update_inventario('01');
commit work;

begin work;
    select f_postea_inventario('01');
commit work;

begin work;
    update invparal
    set valor = 'S'
    where parametro = 'valida_existencias'
    and almacen in (select almacen from almacen where compania = '01');
commit work;
