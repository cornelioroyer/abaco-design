delete from inv_fisico2;

insert into inv_fisico2 (almacen, secuencia, articulo, linea, cantidad)
select almacen, 1, articulo, 0, 0
from articulos_por_almacen
where almacen = '02';


/*
and not exists
(select * from inv_fisico2 fis
where fis.almacen = articulos_por_almacen.almacen
and fis.secuencia = 1
and fis.articulo = articulos_por_almacen.articulo)
*/