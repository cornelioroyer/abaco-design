delete from articulos_agrupados;

begin work;
insert into articulos_agrupados (articulo, codigo_valor_grupo)
select id, grupo from tmp_inventario;
commit work;


insert into articulos_agrupados (articulo, codigo_valor_grupo)
select id, 'SI' from tmp_inventario;


insert into articulos_agrupados (articulo, codigo_valor_grupo)
select id, '99' from tmp_inventario;




