

update factura1
set codigo_vendedor = clientes.vendedor
from clientes
where factura1.cliente = clientes.cliente
and factura1.fecha_factura >= '2013-07-01';


/*
update factura1
set codigo_vendedor = '05'
where trim(cliente) like  '%2121%'
and almacen = '02'
and fecha_factura >= '2013-06-01';

update factura1
set codigo_vendedor = '02'
where trim(cliente) like  '%2121%'
and almacen = '01'
and fecha_factura >= '2013-06-01';
*/

