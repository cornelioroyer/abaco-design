delete from articulos_agrupados;

insert into articulos_agrupados
select articulo, '50' from articulos;

insert into articulos_agrupados
select articulo, '00' from articulos
where articulo = '43';

insert into articulos_agrupados
select articulo, '40' from articulos
where articulo like '40%';

insert into articulos_agrupados
select articulo, '41' from articulos
where articulo like '41%';

insert into articulos_agrupados
select articulo, '42' from articulos
where articulo like '42%';

insert into articulos_agrupados
select articulo, '43' from articulos
where articulo like '43%';

insert into articulos_agrupados
select articulo, '44' from articulos
where articulo like '44%';

insert into articulos_agrupados
select articulo, '45' from articulos
where articulo like '45%';

insert into articulos_agrupados
select articulo, '46' from articulos
where articulo like '46%';

insert into articulos_agrupados
select articulo, '81' from articulos
where articulo not in
(select articulos_agrupados.articulo from articulos_agrupados, gral_valor_grupos
where articulos_agrupados.codigo_valor_grupo = gral_valor_grupos.codigo_valor_grupo
and gral_valor_grupos.grupo = 'TDI')


