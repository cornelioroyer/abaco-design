

delete from eys1
where aplicacion_origen = 'FAC'
and fecha >= '2015-01-01';

/*

select f_factura2_eys2(factura2.almacen, factura2.tipo, factura2.num_documento, factura2.caja, factura2.linea)
from factura1, factura2
where factura1.almacen = factura2.almacen
and factura1.caja = factura2.caja
and factura1.tipo = factura2.tipo
and factura1.num_documento = factura2.num_documento
and factura1.fecha_factura = '2015-01-02'
and factura1.tipo = 'RE'
and factura1.num_documento = 26

*/





