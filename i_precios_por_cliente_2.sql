




insert into precios_por_cliente_2 (secuencia, articulo, almacen, precio)
select secuencia, articulo, '09', precio
from precios_por_cliente_2
where almacen = '01'
and secuencia in
(select secuencia from precios_por_cliente_1
where fecha_hasta >= '2014-01-01');
