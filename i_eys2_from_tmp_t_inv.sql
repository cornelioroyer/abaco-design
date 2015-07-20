delete from eys2 where no_transaccion = 6;
insert into eys2(almacen, no_transaccion, linea, articulo, cantidad, costo)
select '01', 6, 1, codigo, existencia, costo
from tmp_t_inv
where codigo in (select articulo from articulos)
