insert into articulos_por_almacen (almacen, articulo, cuenta, precio_venta, minimo,
maximo, usuario, fecha_captura, dias_piso, existencia, costo)
select '02', Substring(trim(codigo) from 1 for 15), '120000', to_number(precio, '99G999D9S'), 0, 0, 'dba',
current_timestamp, 1, 0, 0 
from tmp_articulos_pets
where descripcion is not null 

