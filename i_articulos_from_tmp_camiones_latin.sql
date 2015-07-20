
/*
insert into articulos (articulo, unidad_medida, desc_articulo,
categoria_abc, status_articulo, servicio, valorizacion, orden_impresion, 
numero_parte, numero_serie, desc_larga, anio, color)
select trim(motor), 'UNIDAD', desc_articulo, 'A', 'A', 'N', 'P', 100, motor, serie, 
desc_larga, anio, color
from tmp_camioneslatin
where trim(motor) not in (select trim(articulo) from articulos);




insert into articulos_por_almacen (almacen, articulo, cuenta, precio_venta,
minimo, maximo, usuario, fecha_captura, dias_piso, existencia, costo)
select '03', trim(motor), '121000', 90000, 0, 0, 'dba', current_timestamp, 0, 0, 0
from tmp_camioneslatin
where motor is not null;
*/



insert into articulos_agrupados (articulo, codigo_valor_grupo)
select trim(motor), 'PM' from tmp_camioneslatin
where motor is not null;





