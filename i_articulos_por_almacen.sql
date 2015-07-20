insert into articulos_por_almacen (almacen, articulo, cuenta, precio_venta,
minimo, maximo, usuario, fecha_captura, dias_piso, existencia, costo)
select '3', articulo, '1101001', 9999999, 0, 0, current_user, current_timestamp, 10, 0, 0
from articulos
where not exists
(select * from articulos_por_almacen
where articulos_por_almacen.almacen = '3'
and articulos_por_almacen.articulo = articulos.articulo);


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
