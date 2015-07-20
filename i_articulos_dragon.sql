delete from articulos;
insert into articulos(articulo, unidad_medida, desc_articulo,
status_articulo,servicio, valorizacion, orden_impresion)
select substring(trim(articulo) from 1 for 15), 'UNIDAD', desc_articulo, 'A',
'N','P',100 from tmp_articulos_dragon;
