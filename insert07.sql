insert into descuentos (secuencia, cantidad_desde, cantidad_hasta,
descuento, fecha_desde, fecha_hasta, status, usuario_captura, fecha_captura)
select rows, 1, 999999, descuento1+descuento2, today(), '2010-1-1', 'A', 'dba', today()
from desctos;
