

delete from rela_factura1_cglposteo
where not exists
(select * from factura1
where factura1.almacen = rela_factura1_cglposteo.almacen
and factura1.caja = rela_factura1_cglposteo.caja
and factura1.num_documento = rela_factura1_cglposteo.num_documento
and factura1.tipo = rela_factura1_cglposteo.tipo);

