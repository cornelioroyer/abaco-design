select factura1.almacen, factura1.tipo, factura1.num_documento, sum(cglposteo.debito-cglposteo.credito)
from rela_factura1_cglposteo, cglposteo, factura1
where factura1.almacen = rela_factura1_cglposteo.almacen
and factura1.caja = rela_factura1_cglposteo.caja
and factura1.tipo = rela_factura1_cglposteo.tipo
and factura1.num_documento = rela_factura1_cglposteo.num_documento
and rela_factura1_cglposteo.consecutivo = cglposteo.consecutivo
and factura1.fecha_factura >= '2013-01-01'
group by 1, 2, 3
having sum(cglposteo.debito-cglposteo.credito) <> 0
