delete from eys2 where no_transaccion = 2866;
delete from eys3 where no_transaccion = 2866;

insert into eys2 (almacen, no_transaccion, linea, articulo,
cantidad, costo)
select almacen, 2866, 0, articulo, -existencia, 0
from articulos_por_almacen
where existencia < 0;

insert into eys2 (almacen, no_transaccion, linea, articulo,
cantidad, costo)
select almacen, 2866, 1, articulo, 0, -costo
from articulos_por_almacen
where costo < 0;


delete from eys2 where cantidad = 0 and costo = 0 and no_transaccion = 2866;

