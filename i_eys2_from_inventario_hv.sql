insert into eys2 (articulo, almacen, no_transaccion, linea, cantidad, costo)
select Substring(trim(codigo) from 1 for 15), '02', 1, oid, cantidad, costo
from inventario_hv
where descripcion is not null 
and codigo is not null
and not exists
(select * from eys2
where eys2.almacen = '02'
and eys2.articulo = Substring(trim(inventario_hv.codigo) from 1 for 15))
group by codigo, cantidad, costo, oid;

