insert into pla_cuentas_x_concepto(compania, concepto, id_pla_cuentas, id_pla_cuentas_2)
select pla_cuentas.compania,pla_cuentas_conceptos.concepto, pla_cuentas_conceptos.id_pla_cuentas,
pla_cuentas_conceptos.id_pla_cuentas_2
from pla_cuentas_conceptos, pla_cuentas
where pla_cuentas_conceptos.id_pla_cuentas = pla_cuentas.id
and pla_cuentas.compania = 1261
