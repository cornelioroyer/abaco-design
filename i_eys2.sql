/*
insert into articulos (articulo, unidad_medida, desc_articulo,
categoria_abc, status_articulo, servicio, valorizacion, orden_impresion)
select codigo, 'UNIDAD', nombre, 'A', 'A', 'N', 'P', 100
from articulos_bering2
where nombre is not null
group by codigo, nombre


drop table tmp_precios;

create table tmp_precios as
select codigo, sum(price) as price
from articulos_bering2
where nombre is not null
group by codigo;
*/

insert into articulos_por_almacen (almacen, articulo, cuenta, precio_venta,
minimo, maximo, usuario, fecha_captura, dias_piso, existencia, costo)
select '01', substring(trim(articulo) from 1 for 15), '1', 0, 0, 0, 'dba', current_timestamp, 0, 0, 0
from tmp_articulos;