delete from articulos;
rollback work;
begin work;
insert into articulos (articulo, unidad_medida, desc_articulo,
categoria_abc, status_articulo, servicio, valorizacion, orden_impresion)
select substring(trim(tmp_articulos.codigo) from 1 for 15), 
tmp_unidades_medida.unidad_medida, descripcion,
'A', 'A', 'N', 'P', 100
from tmp_articulos, tmp_unidades_medida
where tmp_articulos.unidad_medida = tmp_unidades_medida.codigo
and not exists
(select * from articulos
where articulos.articulo = tmp_articulos.codigo);
commit work;

/*



insert into articulos_por_almacen (almacen, articulo, 
cuenta, precio_venta,
minimo, maximo, usuario, fecha_captura, dias_piso, existencia, 
costo,ubicacion)
select '01', substring(trim(articulo) from 1 for 15), '1', 
precio, 0, 0, 'dba', current_timestamp, 0, 0, 0, ubicacion
from tmp_articulos_fa
where articulo is not null 
and not exists
(select * from articulos_por_almacen
where articulos_por_almacen.articulo = tmp_articulos_fa.articulo);


commit work;

*/
