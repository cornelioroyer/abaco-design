

select fecha_factura, almacen, caja, factura1.tipo, num_documento
from factura1, factmotivos
where factura1.tipo = factmotivos.tipo
and factmotivos.cotizacion = 'N'
and factura1.tipo not in ('DA')
and fecha_factura between '2014-11-01' and '2014-11-27'
and exists
(select * from factura2, articulos
where factura2.articulo = articulos.articulo
and factura2.almacen = factura1.almacen
and factura2.caja = factura1.caja
and factura2.tipo = factura1.tipo
and factura2.num_documento = factura1.num_documento
and articulos.servicio = 'N')
and not exists
(select * from factura2_eys2
where factura2_eys2.almacen = factura1.almacen
and factura2_eys2.tipo = factura1.tipo
and factura2_eys2.caja = factura1.caja
and factura2_eys2.num_documento = factura1.num_documento)
order by 1, 2, 3, 4




/*


select f_factura_inventario(almacen, factura1.tipo, num_documento, caja) 
from factura1, factmotivos
where factura1.tipo = factmotivos.tipo
and factmotivos.cotizacion = 'N'
and fecha_factura between '2014-11-01' and '2014-11-27'
and not exists
(select * from factura2_eys2
where factura2_eys2.almacen = factura1.almacen
and factura2_eys2.tipo = factura1.tipo
and factura2_eys2.caja = factura1.caja
and factura2_eys2.num_documento = factura1.num_documento)


*/

