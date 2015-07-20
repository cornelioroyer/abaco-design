update tal_ot2
set fecha_despacho = tal_ot1.fecha
where tal_ot2.almacen = tal_ot1.almacen
and tal_ot2.tipo = tal_ot1.tipo
and tal_ot2.no_orden = tal_ot1.no_orden
and tal_ot2.despachar = 'S'
and tal_ot2.fecha_despacho <= '2005-06-30'
and tal_ot1.fecha >= '2005-07-01';
