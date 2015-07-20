

insert into articulos (articulo, unidad_medida, desc_articulo,
categoria_abc, status_articulo, servicio, valorizacion, orden_impresion, numero_parte, 
numero_serie, desc_larga)
select substring(trim(articulo) from 1 for 15), 'UNIDAD', descripcion,
'A', 'A', 'N', 'P', 100, parte, serie, anio || color
from tmp_medicamentos;




insert into articulos_por_almacen (almacen, articulo, cuenta, precio_venta,
minimo, maximo, usuario, fecha_captura, dias_piso, existencia, costo)
select '05', substring(trim(articulo) from 1 for 15), '120000', 13500, 0, 0, 'dba', current_timestamp, 0, 0, 0
from tmp_camiones;



insert into articulos_agrupados (articulo, codigo_valor_grupo)
select substring(trim(articulo) from 1 for 15), 'PM' from tmp_camiones;




