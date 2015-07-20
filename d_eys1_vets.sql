rollback work;

begin work;
    update invparal
    set valor = 'N'
    where parametro = 'valida_existencias';
commit work;

begin work;
    update invparal
    set valor = '0'
    where parametro = 'sec_eys';
commit work;


/*
begin work;
    delete from eys1
    where aplicacion_origen in ('FAC','COS')
    and almacen in (select almacen from almacen where compania = '02')
    and fecha between '2007-01-01' and '2017-01-02';
commit work;
*/

begin work;
    select f_update_inventario('02');
commit work;

begin work;
    update invparal
    set valor = 'S'
    where parametro = 'valida_existencias';
commit work;

begin work;
    select f_postea_inventario('02');
commit work;

begin work;
    select f_postea_fac('02');
commit work;

