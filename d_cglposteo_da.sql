delete from cglposteo using rela_factura1_cglposteo
where cglposteo.consecutivo = rela_factura1_cglposteo.consecutivo
and cglposteo.fecha_comprobante >= '2011-07-01'
and rela_factura1_cglposteo.tipo = 'DA';
