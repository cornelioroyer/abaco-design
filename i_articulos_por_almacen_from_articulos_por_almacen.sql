
insert into articulos_por_almacen (almacen, articulo, cuenta, precio_venta,
minimo, maximo, usuario, fecha_captura, dias_piso, existencia, costo, precio_fijo)
select '09', articulo, cuenta, precio_venta, minimo, maximo, current_user, current_date,
dias_piso, 0, 0, 'N'
from articulos_por_almacen
where almacen = '01'
and articulo not in
(select articulo from articulos_por_almacen
where almacen = '09');

