select f_update_factura4(almacen, tipo, num_documento)
from factura1
where fecha_factura >= '2012-06-12'
and exists
(select * from factura2
where factura2.almacen = factura1.almacen
and factura2.tipo = factura1.tipo
and factura2.num_documento = factura1.num_documento
and trim(factura2.articulo) = 'MANEJO')
