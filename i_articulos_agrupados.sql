/*
begin work;
delete from articulos_agrupados;
commit work;
*/



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
