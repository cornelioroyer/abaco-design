/*
begin work;
delete from articulos_agrupados;
commit work;
*/

delete from 
insert into articulos_agrupados (codigo_valor_grupo, articulo)
select trim(origen), substring(trim(articulo) from 1 for 15) from tmp1_articulos
where articulo is not null
and substring(trim(articulo) from 1 for 15) in (select trim(articulo) from articulos)
group by 1, 2
begin work;
insert into articulos_agrupados (articulo, codigo_valor_grupo)
select articulo, 'PM' from articulos
where articulo not in
(select articulo from articulos_agrupados
where codigo_valor_grupo = 'PM');
commit work;




begin work;
insert into articulos_agrupados (articulo, codigo_valor_grupo)
select articulo, 'SI' from articulos
where articulo not in
(select articulo from articulos_agrupados
where codigo_valor_grupo = 'SI');
commit work;