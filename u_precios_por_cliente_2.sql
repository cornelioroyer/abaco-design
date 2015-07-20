update precios_por_cliente_2
set precio = precio + .50
where articulo in ('21','22')
and secuencia in
(select secuencia from precios_por_cliente_1
where fecha_desde = '2006-11-01');
