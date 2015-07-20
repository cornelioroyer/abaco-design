

rollback work;
begin work;
insert into articulos (articulo, unidad_medida, desc_articulo,
categoria_abc, status_articulo, servicio, valorizacion, orden_impresion)
select substring(trim(codigo) from 1 for 15), 'UNIDAD', descripcion,
'A', 'A', 'N', 'P', 100
from tmp_articulos_por_almacen
where codigo is not null 
and not exists
(select * from articulos
where articulos.articulo = tmp_articulos_por_almacen.codigo);




insert into articulos_por_almacen (almacen, articulo, 
cuenta, precio_venta,
minimo, maximo, usuario, fecha_captura, dias_piso, existencia, 
costo,ubicacion, precio_minimo, precio_fijo)
select '02', substring(trim(codigo) from 1 for 15), '11105101', 
precio, 0, 0, 'dba', current_timestamp, 0, 0, 0, 'PRIMER PISO', 0, 'N'
from tmp_articulos_por_almacen
where codigo is not null
and not exists
(select * from articulos_por_almacen
where articulos_por_almacen.articulo = tmp_articulos_por_almacen.codigo);


commit work;
