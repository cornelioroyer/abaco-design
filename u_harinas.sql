
begin work;
update factura1
set codigo_vendedor = clientes.vendedor
from clientes
where factura1.cliente = clientes.cliente
and factura1.almacen = '01'
and factura1.fecha_factura >= '2013-06-01';
commit work;


/*
set search_path to dba;

update factura1
set codigo_vendedor = '05'
where trim(cliente) like  '%2121%'
and almacen = '02'
and num_documento = 9365
and fecha_factura >= '2013-06-01';
*/
