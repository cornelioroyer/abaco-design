

rollback work;

/*
begin work;
select f_factura2_factura3(factura2.almacen, factura2.tipo, factura2.num_documento, factura2.caja, factura2.linea)
from factura1, factura2
where factura1.almacen = factura2.almacen
and factura1.tipo = factura2.tipo
and factura1.num_documento = factura2.num_documento
and factura1.caja = factura2.caja
and factura1.fecha_factura >= '2013-03-01';
commit work;
*/


-- drop function f_factura4_before_update() cascade;
drop function f_factura4_before_delete() cascade;

begin work;
select f_update_factura4(almacen, tipo, num_documento, caja)
from factura1
where factura1.fecha_factura >= '2013-04-01'
order by fecha_factura;



commit work;

