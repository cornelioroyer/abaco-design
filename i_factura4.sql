insert into factura4
select almacen, tipo, num_documento,
'SUBTOTAL', total
from f_conytram_resumen
where total > 0 
and not exists
(select * from factura4
where factura4.almacen = f_conytram_resumen.almacen
and factura4.tipo = f_conytram_resumen.tipo
and factura4.num_documento = f_conytram_resumen.num_documento)