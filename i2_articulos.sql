

insert into articulos (articulo, unidad_medida, desc_articulo,
categoria_abc, status_articulo, servicio, valorizacion, orden_impresion)
select trim(substring(trim(articulo) from 1 for 15)), 'UNIDAD', desc_articulo,
'A', 'A', 'N', 'P', 100
from tmp1_articulos
where trim(substring(trim(tmp1_articulos.articulo) from 1 for 15)) 
not in (select trim(articulo) from articulos)
and trim(articulo) not in (select trim(articulo) from articulos);


insert into articulos_por_almacen (almacen, articulo, cuenta, precio_venta,
minimo, maximo, usuario, fecha_captura, dias_piso, existencia, costo)
select '01', trim(substring(trim(tmp1_articulos.articulo) from 1 for 15)), '1', 0, 0, 0, 'dba', current_timestamp, 0, 0, 0
from tmp1_articulos
where trim(substring(trim(tmp1_articulos.articulo) from 1 for 15)) not in
(select trim(articulo) from articulos);







