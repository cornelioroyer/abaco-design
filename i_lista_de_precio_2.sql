insert into listas_de_precio_2 (secuencia, articulo, almacen, precio)
select 3, substring(trim(articulo) from 1 for 15), '01', Max(precio3)
from tmp_precios_bering
where precio3 is not null
group by articulo