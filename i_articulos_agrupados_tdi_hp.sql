begin work;
delete from articulos_agrupados where codigo_valor_grupo in ('30', '40', '45');

insert into articulos_agrupados 
(select articulo, '30' from articulos where articulo like 'TRIGO%');

insert into articulos_agrupados 
(select articulo, '45' from articulos where articulo like 'SV%');

commit work;

insert into articulos_agrupados
(select articulo, '40' from articulos_por_almacen
where almacen = '03' and articulo not like 'TRIGO%'
and articulo not like 'SV%')



