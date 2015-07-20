/*
insert into articulos_agrupados
*/

select articulo, '00' from articulos
where articulo not in
(select articulos_agrupados.articulo 
from articulos_agrupados, gral_valor_grupos
where articulos_agrupados.codigo_valor_grupo = gral_valor_grupos.codigo_valor_grupo
and gral_valor_grupos.grupo = 'LAB')

