insert into articulos_por_almacen (articulo, almacen,
cuenta, precio_venta, minimo, maximo, usuario, fecha_captura, dias_piso, existencia, costo)
select articulo, '01', '1', 0, 0, 0, current_user, current_timestamp, 0, 0, 0
from articulos