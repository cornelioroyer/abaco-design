
insert into articulos_por_almacen (almacen, articulo, cuenta, precio_venta,
minimo, maximo, usuario, fecha_captura, dias_piso, existencia, costo, precio_fijo)
select '02', articulo, '1', 999999, 0, 0, current_user, current_date,
10, 0, 0, 'N'
from articulos
