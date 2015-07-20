select factura1.almacen, factura1.tipo, factura1.num_documento, sum(cglposteo.debito-cglposteo.credito)
from factura1, rela_factura1_cglposteo, cglposteo
where factura1.almacen = rela_factura1_cglposteo.almacen
and factura1.tipo = rela_factura1_cglposteo.tipo
and factura1.num_documento = rela_factura1_cglposteo.num_documento
and rela_factura1_cglposteo.consecutivo = cglposteo.consecutivo
and factura1.fecha_factura >= '2012-11-01'
group by 1, 2, 3
having sum(cglposteo.debito-cglposteo.credito) <> 0
