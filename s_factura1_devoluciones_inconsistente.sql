select b.almacen, b.num_documento, b.num_factura, b.forma_pago
from factura1 b
where tipo = '9'
and status <> 'A'
and fecha_factura >= '2014-04-01'
and not exists
(select * from factura1 a
where a.almacen = b.almacen
and a.caja = b.caja
and a.num_documento = b.num_factura
and a.forma_pago = b.forma_pago
and a.tipo = '13')
order by 1, 2
