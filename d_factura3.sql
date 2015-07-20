delete from factura3
where not exists
(select * from factura2
where factura2.almacen = factura3.almacen
and factura2.caja = factura3.caja
and factura2.tipo = factura3.tipo
and factura2.num_documento = factura3.num_documento
and factura2.linea = factura3.linea)
