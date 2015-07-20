
rollback work;

begin work;
    delete from cglposteo
    where aplicacion_origen = 'FAC'
    and fecha_comprobante between '2015-01-01' and '2015-01-31';
commit work;


/*

begin work;
    delete from eys1
    where aplicacion_origen = 'FAC'
    and fecha >= '2015-01-01';
commit work;

begin work;
select f_update_inventario('01');
commit work;
*/
