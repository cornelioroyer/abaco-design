insert into inv_fisico2(almacen, secuencia, articulo, linea, cantidad)
select almacen, 1, articulo, 1, 0
from articulos_por_almacen
where almacen = '02'
and not exists
    (select * from inv_fisico2
    where inv_fisico2.almacen = articulos_por_almacen.almacen
    and inv_fisico2.articulo = articulos_por_almacen.articulo
    and inv_fisico2.secuencia = 1)