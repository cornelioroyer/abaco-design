set search_path to planilla;


select meses_trabajados from pla_planilla_03
where compania = 960

/*

update pla_planilla_03
set meses_trabajados = f_pla_meses_trabajados(compania, codigo_empleado, 2013)
where compania = 960;


select f_pla_planilla_03(960,2013);
select f_pla_meses_trabajados(compania,codigo_empleado,2013) from pla_planilla_03
where compania = 960



select f_pla_meses_trabajados(960,'7438',2013)


*/
