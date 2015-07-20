

delete from factura2_eys2
where not exists
(select * from factura2
where factura2.almacen = factura2_eys2.almacen
and factura2.caja = factura2_eys2.caja
and factura2.tipo = factura2_eys2.tipo
and factura2.num_documento = factura2_eys2.num_documento
and factura2.linea = factura2_eys2.factura2_linea);
