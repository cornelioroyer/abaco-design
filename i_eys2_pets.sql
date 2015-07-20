delete from eys2 where almacen = '02';
insert into eys2(almacen, articulo, no_transaccion, linea, cantidad, costo)
select '02', Substring(trim(codigo) from 1 for 15), 1, 0, to_number(existencia, '999999.99'), (to_number(costo, '999999.99')*to_number(existencia, '999999.99'))
from tmp_articulos_pets
where descripcion is not null 
and existencia is not null
