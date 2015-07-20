update factura2
set precio = 0
from factura1
where factura1.almacen = factura2.almacen
and factura1.tipo = factura2.tipo
and factura1.num_documento = factura2.num_documento
and factura1.tipo in ('02','RE')
and factura1.fecha_factura >= '2012-06-01'
and factura2.precio > 0
