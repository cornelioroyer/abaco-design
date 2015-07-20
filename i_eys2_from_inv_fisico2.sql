
/*
delete from eys2
where no_transaccion = 3;
*/

/*
insert into eys2(almacen, no_transaccion, linea,
articulo, cantidad, costo)
select almacen, 3, linea, inv_fisico2.articulo,  cantidad, 
(inv_fisico2.cantidad*tmp_articulos_fisico.cu) as costo
from inv_fisico2, tmp_articulos_fisico
where trim(inv_fisico2.articulo) = trim(tmp_articulos_fisico.articulo)
and inv_fisico2.cantidad > 0
*/

insert into eys2(almacen, no_transaccion, linea,
articulo, cantidad, costo)
select almacen, 3, linea, inv_fisico2.articulo,  cantidad, 
(inv_fisico2.cantidad*tmp_articulos_fisico.cu) as costo
from inv_fisico2
where inv_fisico2.cantidad > 0
