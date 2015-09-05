set search_path to planilla;

update pla_companias
set fecha_de_expiracion = '2090-07-01'
where compania in (1353,1357,1360,1362,1363);
