
delete from cglposteo
where aplicacion_origen in ('FAC')
and fecha_comprobante >= '2015-09-18'
and trim(descripcion) like '%CLIENTE%'
and consecutivo not in (select consecutivo from rela_factura1_cglposteo);

delete from cglposteo
where aplicacion_origen in ('FAC')
and fecha_comprobante >= '2015-09-18'
and trim(descripcion) like '%ALMACEN%'
and consecutivo not in (select consecutivo from rela_eys1_cglposteo);




/*

delete from cglposteo
where aplicacion_origen in ('FAC')
and fecha_comprobante >= '2015-06-01'
and consecutivo not in (select consecutivo from rela_eys1_cglposteo)
and consecutivo not in (select consecutivo from rela_factura1_cglposteo);

delete from cglposteo
where aplicacion_origen in ('INV')
and fecha_comprobante >= '2015-06-01'
and consecutivo not in (select consecutivo from rela_eys1_cglposteo);

*/


