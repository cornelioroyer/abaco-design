set search_path to planilla;

update pla_companias
set fecha_de_expiracion = '2300-09-30'
where compania in (1343);
