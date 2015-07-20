update factura1
set aplicacion = 'TAL', despachar = 'N', fecha_despacho = null
where exists
(select * from tal_ot1
where tal_ot1.almacen = factura1.almacen
and tal_ot1.tipo_factura = factura1.tipo
and tal_ot1.numero_factura = factura1.num_documento);