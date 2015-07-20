rollback work;

delete from eys2;
delete from articulos_por_almacen;
delete from articulos;

update tmp_inventario
set descripcion = 'PONER NOMBRE'
where descripcion is null;

update tmp_inventario
set cantidad = 0
where cantidad is null;

begin work;
insert into articulos (articulo, unidad_medida, desc_articulo,
categoria_abc, status_articulo, servicio, valorizacion, orden_impresion, codigo_barra,
desc_larga)
select id, 'UNIDAD', descripcion,
'A', 'A', 'N', 'P', 100, codigo, desc_tecnica
from tmp_inventario;
commit work;

/*
begin work;
insert into articulos_agrupados (articulo, codigo_valor_grupo)
select id, grupo from tmp_inventario;
commit work;


insert into articulos_agrupados (articulo, codigo_valor_grupo)
select id, 'SI' from tmp_inventario;


insert into articulos_agrupados (articulo, codigo_valor_grupo)
select id, '99' from tmp_inventario;
*/


insert into articulos_por_almacen (almacen, articulo, cuenta, precio_venta,
minimo, maximo, usuario, fecha_captura, dias_piso, existencia, costo)
select '02', id, cuenta, 99999, 0, 0, current_user, current_timestamp, 0, 0, 0
from tmp_inventario;


insert into eys2 (articulo, almacen, no_transaccion, linea, cantidad, costo)
select id, '02', 3, 1, cantidad, costo from tmp_inventario;



