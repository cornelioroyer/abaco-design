drop table tmp_precios;

create table tmp_precios as
select almacen, articulo, sum(costo) as costo, sum(cantidad) as cantidad, 0.0000 as cu, 0.0000 as precio
from v_eys1_eys2
where fecha <= '2005-12-31'
group by 1, 2;

update tmp_precios
set cu = costo / cantidad
where cantidad <> 0;

update tmp_precios
set precio = cu * 1.4;


update articulos_por_almacen
set precio_venta = 0;

update articulos_por_almacen
set precio_venta = tmp_precios.precio
where articulos_por_almacen.almacen = tmp_precios.almacen
and articulos_por_almacen.articulo = tmp_precios.articulo;
