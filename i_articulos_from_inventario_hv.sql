insert into articulos (articulo, unidad_medida, desc_articulo,
categoria_abc, status_articulo, servicio, codigo_barra,
valorizacion, orden_impresion)
select Substring(trim(codigo) from 1 for 15), 'UNIDAD', descripcion, 'X', 'A', 'N', 
substring(trim(codigo_barra) from 1 for 20),'P', 100 
from inventario_hv
where descripcion is not null 
and substring(trim(codigo) from 1 for 15) not in
(select articulo from articulos)
group by codigo, descripcion, codigo_barra
