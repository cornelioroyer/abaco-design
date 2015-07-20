
delete from rela_factura1_cglposteo
using factura1, cglposteo, almacen
where factura1.almacen = rela_factura1_cglposteo.almacen
and factura1.caja = rela_factura1_cglposteo.caja
and factura1.tipo = rela_factura1_cglposteo.tipo
and factura1.num_documento = rela_factura1_cglposteo.num_documento
and factura1.almacen = almacen.almacen
and cglposteo.consecutivo = rela_factura1_cglposteo.consecutivo
and cglposteo.fecha_comprobante <> factura1.fecha_factura
and almacen.compania = '03'
and factura1.fecha_factura >= '2014-09-01'
