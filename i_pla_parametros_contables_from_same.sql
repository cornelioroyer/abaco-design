

delete from pla_parametros_contables
where compania = 746;

insert into pla_parametros_contables(id_pla_departamentos,
id_pla_proyectos, concepto, id_pla_cuentas, compania)
select id_pla_departamentos, 8, concepto, 45, 754
from pla_parametros_contable
where compania = 745

