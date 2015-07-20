rollback work;

begin work;
    update invparal
    set valor = 'N'
    where parametro = 'valida_existencias'
    and almacen in (select almacen from almacen where compania = '03');
commit work;

begin work;
    update invparal
    set valor = '0'
    where parametro = 'sec_eys'
    and almacen in (select almacen from almacen where compania = '03');
commit work;


begin work;
    delete from eys1
    where aplicacion_origen in ('FAC','COS')
    and almacen in (select almacen from almacen where compania = '03')
    and fecha between '2013-12-01' and '2015-12-04';
commit work;


begin work;
    select f_update_inventario('03');
commit work;


begin work;
    select f_postea_inventario('03');
commit work;

