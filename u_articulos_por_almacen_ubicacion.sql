update articulos_por_almacen
set ubicacion = null;

update articulos_por_almacen
set ubicacion = tmp_articulos_por_almacen.ubicacion
where articulos_por_almacen.almacen = tmp_articulos_por_almacen.almacen
and articulos_por_almacen.articulo = tmp_articulos_por_almacen.articulo;

update articulos_por_almacen
set ubicacion = inv_fisico2.ubicacion
where articulos_por_almacen.almacen = inv_fisico2.almacen
and articulos_por_almacen.articulo = inv_fisico2.articulo
and inv_fisico2.ubicacion is not null
and inv_fisico2.secuencia in (4);