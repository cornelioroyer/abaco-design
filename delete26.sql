delete from rela_factura1_cglposteo;
delete from cglposteo where aplicacion_origen = 'FAC';
delete from cglcomprobante1 where aplicacion_origen = 'FAC';
update factura1 set status = 'I';


