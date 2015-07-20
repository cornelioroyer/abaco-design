select articulos_agrupados.articulo, gral_grupos_aplicacion.grupo, count(*)
from articulos_agrupados, gral_valor_grupos, gral_grupos_aplicacion
where articulos_agrupados.codigo_valor_grupo = gral_valor_grupos.codigo_valor_grupo
and gral_valor_grupos.grupo = gral_grupos_aplicacion.grupo
group by 1, 2
having count(*) > 1
order by 1, 2