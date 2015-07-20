insert into articulos (articulo, unidad_medida, desc_articulo,
categoria_abc, status_articulo, servicio, codigo_barra,
valorizacion, orden_impresion)
select Substring(trim(codigo) from 1 for 15), 'UNIDAD', descripcion, 'X', 'A', 'N', 
codigo_de_barra,'P', 100 
from tmp_articulos_pets
where descripcion is not null 
and substring(trim(codigo) from 1 for 15) not in
(select articulo from articulos)
group by codigo, descripcion, codigo_de_barra

