delete from articulos_agrupados
where codigo_valor_grupo in
(select codigo_valor_grupo from gral_valor_grupos
where grupo = 'GRA');

insert into articulos_agrupados
select articulo, '60' from articulos
where articulo like 'TRIGO%';

insert into articulos_agrupados
select articulo, '61' from articulos
where articulo like 'SV%';

insert into articulos_agrupados
select articulo, '62' from articulos
where articulo like 'I%';

insert into articulos_agrupados
select articulo, 'P' from articulos
where articulo not in
(select articulos_agrupados.articulo from articulos_agrupados, gral_valor_grupos
where articulos_agrupados.codigo_valor_grupo = gral_valor_grupos.codigo_valor_grupo
and gral_valor_grupos.grupo = 'GRA')




