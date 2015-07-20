insert into inv_fisico2 (almacen, secuencia, articulo, linea, cantidad)
select '01', 1, articulo, 0, 0
from tmp_articulos_fisico
where almacen in ('01')
and not exists
(select * from inv_fisico2 fis
where fis.almacen = articulos_por_almacen.almacen
and fis.secuencia = 1
and fis.articulo = articulos_por_almacen.articulo)