
update articulos
set status_articulo = 'I'
where articulo in (select articulo from tmp_articulos_inactivos_coolhouse);
