

begin work;
    delete from eys1
    where fecha between '2015-06-01' and '2016-08-02'
    and aplicacion_origen in ('COS', 'FAC');
commit work;

begin work;
    delete from cglposteo
    where aplicacion_origen in ('COS', 'INV','FAC')
    and fecha_comprobante between '2015-06-01' and '2016-08-02';
commit work;

    

