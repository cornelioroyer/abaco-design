select * from factura2
where not exists
(select * from factura2_eys2
where factura2_eys2.almacen = factura2.almacen
and factura2_eys2.caja = factura2.caja
and factura2_eys2.tipo = factura2.tipo
and factura2_eys2.num_documento = factura2.num_documento
and factura2_eys2.factura2_linea = factura2.linea)
