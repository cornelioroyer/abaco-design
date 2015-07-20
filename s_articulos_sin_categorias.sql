/*
insert into articulos_agrupados (articulo, codigo_valor_grupo)
*/
select articulo,'03' from articulos
where articulo not in
(select articulos_agrupados.articulo from articulos_agrupados, gral_valor_grupos
where articulos_agrupados.codigo_valor_grupo = gral_valor_grupos.codigo_valor_grupo
and gral_valor_grupos.grupo = 'CAT')


/*
, count(*)
from articulos_agrupados, gral_valor_grupos
where articulos_agrupados.codigo_valor_grupo = gral_valor_grupos.codigo_valor_grupo
and gral_valor_grupos.grupo = 'CAT'
group by 1
having count(*) > 1
order by 1
*/
