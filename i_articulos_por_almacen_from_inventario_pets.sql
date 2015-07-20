insert into articulos_por_almacen (almacen, articulo, cuenta, precio_venta, minimo,
maximo, usuario, fecha_captura, dias_piso, existencia, costo)
select '02', Substring(trim(codigo) from 1 for 15), '120000', 0, 0, 0, 'dba',
current_timestamp, 1, 0, 0 
from inventario_hv
where descripcion is not null 
and codigo is not null
and not exists
(select * from articulos_por_almacen
where articulos_por_almacen.almacen = '02'
and articulos_por_almacen.articulo = Substring(trim(inventario_hv.codigo) from 1 for 15));

