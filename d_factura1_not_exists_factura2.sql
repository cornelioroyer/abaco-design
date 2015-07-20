
delete from factura1
where fecha_factura >= '2010-01-01' 
and not exists
(select * from factura2
where factura2.almacen  = factura1.almacen
and factura2.caja = factura1.caja
and factura2.tipo = factura1.tipo
and factura2.num_documento = factura1.num_documento);
