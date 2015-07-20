
/*
delete from pla_parametros_contables
where compania = 746;
*/




insert into pla_parametros_contables(id_pla_departamentos,
id_pla_proyectos, concepto, id_pla_cuentas, compania)
select 666, 80, concepto, 381, 746
from pla_conceptos;

