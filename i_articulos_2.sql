drop table tmp_articulos;
create table tmp_articulos as
select substring(trim(articulo) from 1 for 15) as articulo from tmp_precios_bering
where substring(trim(articulo) from 1 for 15) not in
(select articulo from articulos)
group by articulo;


insert into articulos (articulo, unidad_medida, desc_articulo,
categoria_abc, status_articulo, servicio, valorizacion, orden_impresion)
select substring(trim(articulo) from 1 for 15), 'UNIDAD', 'DESCRIPCION',
'A', 'A', 'N', 'P', 100
from tmp_articulos;


update articulos
set desc_articulo = tmp_precios_bering.desc_articulo
where trim(articulos.articulo) = substring(trim(tmp_precios_bering.articulo) from 1 for 15)
and tmp_precios_bering.desc_articulo is not null;


insert into articulos_por_almacen (almacen, articulo, cuenta, precio_venta,
minimo, maximo, usuario, fecha_captura, dias_piso, existencia, costo)
select '01', substring(trim(articulo) from 1 for 15), '1', 0, 0, 0, 'dba', current_timestamp, 0, 0, 0
from tmp_articulos;




