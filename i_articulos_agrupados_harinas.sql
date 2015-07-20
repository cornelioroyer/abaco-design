delete from articulos_agrupados
where codigo_valor_grupo in ('SI', 'NO');


insert into articulos_agrupados (articulo, codigo_valor_grupo)
select articulo, 'SI' from articulos;



update articulos_agrupados
set codigo_valor_grupo = 'NO'
where codigo_valor_grupo = 'SI'
and articulo in
(select articulo from articulos_por_almacen
where almacen in ('01', '02'));





