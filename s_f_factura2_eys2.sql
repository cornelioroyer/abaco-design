select f_factura2_eys2(factura2.almacen, factura2.tipo, factura2.num_documento, 
factura2.linea)
from factura1, factura2
where factura1.almacen = factura2.almacen
and factura1.tipo = factura2.tipo
and factura1.num_documento = factura2.num_documento
and factura1.status <> 'A'
and factura1.fecha_factura between '2011-12-02' and '2012-12-04';

