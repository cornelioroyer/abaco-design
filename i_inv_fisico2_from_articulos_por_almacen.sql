delete from inv_fisico2 where secuencia = 1 and almacen = '02';

insert into inv_fisico2(almacen, secuencia, articulo, linea, cantidad)
select almacen, 1, articulo, 1, f_stock(almacen, articulo, '2009-08-31', 0, 0, 'STOCK')
from articulos_por_almacen
where almacen = '02'
and not exists
    (select * from inv_fisico2
    where inv_fisico2.almacen = articulos_por_almacen.almacen
    and inv_fisico2.articulo = articulos_por_almacen.articulo
    and inv_fisico2.secuencia = 1);
    
update inv_fisico2
set cantidad = 0
where cantidad < 0
and almacen = '02'
and secuencia = 1;    
    