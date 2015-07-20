

update articulos_por_almacen
set margen_minimo = 30;

update articulos_por_almacen
set margen_minimo = 10
where articulo in (select articulo from articulos_agrupados
where codigo_valor_grupo = 'AA')
