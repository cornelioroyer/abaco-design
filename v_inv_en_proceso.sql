drop view v_inv_en_proceso;
create view v_inv_en_proceso as
select eys2.almacen, tal_ot1.no_orden, tal_ot2.fecha_despacho as fecha, 
eys2.articulo, eys2.cantidad, eys2.costo
from tal_ot1, tal_ot2, tal_ot2_eys2, eys2
where tal_ot1.almacen = tal_ot2.almacen
and tal_ot1.no_orden = tal_ot2.no_orden
and tal_ot2.no_orden = tal_ot2_eys2.no_orden
and tal_ot2.tipo = tal_ot2_eys2.tipo
and tal_ot2.almacen = tal_ot2_eys2.almacen
and tal_ot2.linea = tal_ot2_eys2.linea_tal_ot2
and tal_ot2.articulo = tal_ot2_eys2.articulo
and eys2.articulo = tal_ot2_eys2.articulo
and eys2.almacen = tal_ot2_eys2.almacen
and eys2.no_transaccion = tal_ot2_eys2.no_transaccion
and eys2.linea = tal_ot2_eys2.linea_eys2
and tal_ot1.numero_factura is null
and tal_ot2.despachar = 'S'
and tal_ot2.fecha_despacho is not null
union
select eys2.almacen, tal_ot1.no_orden, factura1.fecha_factura,
eys2.articulo, eys2.cantidad, eys2.costo
from tal_ot1, tal_ot2, tal_ot2_eys2, eys2, factura1
where tal_ot1.almacen = tal_ot2.almacen
and tal_ot1.no_orden = tal_ot2.no_orden
and tal_ot2.no_orden = tal_ot2_eys2.no_orden
and tal_ot2.tipo = tal_ot2_eys2.tipo
and tal_ot2.almacen = tal_ot2_eys2.almacen
and tal_ot2.linea = tal_ot2_eys2.linea_tal_ot2
and tal_ot2.articulo = tal_ot2_eys2.articulo
and eys2.articulo = tal_ot2_eys2.articulo
and eys2.almacen = tal_ot2_eys2.almacen
and eys2.no_transaccion = tal_ot2_eys2.no_transaccion
and eys2.linea = tal_ot2_eys2.linea_eys2
and tal_ot1.almacen = factura1.almacen
and tal_ot1.tipo_factura = factura1.tipo
and tal_ot1.numero_factura = factura1.num_documento
and tal_ot2.despachar = 'S'
and tal_ot2.fecha_despacho is not null



