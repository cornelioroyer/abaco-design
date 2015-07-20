/*
insert into articulos (articulo, unidad_medida, desc_articulo,
categoria_abc, status_articulo, servicio, valorizacion, orden_impresion)
select substring(trim(codigo) from 1 for 15), 'UNIDAD', descripcion,
'A', 'A', 'N', 'P', 100
from tmp_piezas;


insert into articulos_por_almacen (almacen, articulo, cuenta, precio_venta,
minimo, maximo, usuario, fecha_captura, dias_piso, existencia, costo)
select '05', substring(trim(codigo) from 1 for 15), '120000', precio, 0, 0, 'dba', current_timestamp, 0, 0, 0
from tmp_piezas;
*/

insert into articulos_agrupados (articulo, codigo_valor_grupo)
select substring(trim(codigo) from 1 for 15), 'XX' from tmp_piezas;

/*
insert into articulos_agrupados (articulo, codigo_valor_grupo)
select substring(trim(articulo) from 1 for 15), '03' from tmp_piezas;

insert into articulos_agrupados (articulo, codigo_valor_grupo)
select substring(trim(articulo) from 1 for 15), 'SI' from tmp_piezas;
*/





