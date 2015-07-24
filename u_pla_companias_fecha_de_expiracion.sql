set search_path to planilla;

update pla_companias
set fecha_de_expiracion = '2015-07-01'
where compania in (89);
