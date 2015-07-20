insert into factura1
select almacen, tipo, num_documento,
cliente, '30', '00', nombre_cliente,
null, 0,0, 'dba', 'dba', null,
fecha_factura, fecha_factura, fecha_factura,
fecha_factura, 'C', 0, 0, null,
null, 'N', documento, 'FAC'
from f_conytram_resumen
where not exists
(select * from factura1
where factura1.almacen = f_conytram_resumen.almacen
and factura1.tipo = f_conytram_resumen.tipo
and factura1.num_documento = f_conytram_resumen.num_documento)
