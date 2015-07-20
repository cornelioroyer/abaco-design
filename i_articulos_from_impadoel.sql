
/*
update tmp_articulos_impadoel
set descripcion = 'PONER NOMBRE'
where descripcion is null;


insert into articulos (articulo, unidad_medida, desc_articulo,
categoria_abc, status_articulo, servicio, valorizacion, orden_impresion)
select substring(trim(articulo) from 1 for 15), 'UNIDAD', descripcion,
'A', 'A', 'N', 'P', 100
from tmp_articulos_impadoel
where articulo not in
(select articulo from tmp_articulos_duplicados)
group by articulo, descripcion
*/




insert into articulos_por_almacen (almacen, articulo, cuenta, precio_venta,
minimo, maximo, usuario, fecha_captura, dias_piso, existencia, costo)
select '01', articulo, '11301', 0, 0, 0, 'dba', current_timestamp, 0, 0, 0
from articulos





