


update articulos_agrupados
set codigo_valor_grupo = 'RE'
from articulos, gral_valor_grupos
where articulos.articulo = articulos_agrupados.articulo
and gral_valor_grupos.codigo_valor_grupo = articulos_agrupados.codigo_valor_grupo
and articulos_agrupados.codigo_valor_grupo not in ('SE','AA')
and trim(gral_valor_grupos.grupo) = 'CAT'

/*
update articulos_agrupados
set codigo_valor_grupo = 'SE'
from articulos, gral_valor_grupos
where articulos.articulo = articulos_agrupados.articulo
and gral_valor_grupos.codigo_valor_grupo = articulos_agrupados.codigo_valor_grupo
and articulos.servicio = 'S'
and trim(gral_valor_grupos.grupo) = 'CAT'
*/

