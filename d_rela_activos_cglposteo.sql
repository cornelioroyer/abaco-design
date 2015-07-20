delete from rela_activos_cglposteo
where exists
(select * from activos
where compania = '03'
and fecha_compra <= '2005-07-31');