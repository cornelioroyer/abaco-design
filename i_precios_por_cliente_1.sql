insert into precios_por_cliente_1 (secuencia, cliente,
cantidad_desde, cantidad_hasta, fecha_desde, fecha_hasta,
status, usuario_captura, fecha_captura)
select secuencia+500, cliente,
cantidad_desde, cantidad_hasta, '2006-11-01', '2010-01-01',
'A', current_user, current_timestamp
from precios_por_cliente_1
where fecha_hasta = '2006-10-31';