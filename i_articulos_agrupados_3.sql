delete from articulos_agrupados
where codigo_valor_grupo = '03';


begin work;
insert into articulos_agrupados (articulo, codigo_valor_grupo)
select articulo, '03' from articulos_por_almacen
where almacen = '01';
commit work;




