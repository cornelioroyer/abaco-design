select * from factura1
where Extract(hour from fecha_captura) = 12
and fecha_factura >= '2013-06-01'
order by almacen, fecha_factura, tipo, num_documento
