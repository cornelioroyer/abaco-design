
rollback work;

begin work;
    delete from eys1
    where fecha >= '2015-09-05'
    and aplicacion_origen in ('COS', 'FAC');
commit work;

begin work;
    delete from cglposteo
    where aplicacion_origen in ('COS', 'INV','FAC')
    and fecha_comprobante >= '2015-09-05';
commit work;

    
