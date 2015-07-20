drop view v_pla_dinero_pla_reservas_pp;

create view v_pla_dinero_pla_reservas_pp as
select pla_dinero.id, pla_dinero.compania, pla_dinero.id_periodos, pla_dinero.id_pla_proyectos,
pla_dinero.id_pla_departamentos, pla_dinero.codigo_empleado,
pla_dinero.tipo_de_calculo, pla_conceptos.descripcion, pla_dinero.concepto,
pla_dinero.mes, (pla_dinero.monto*pla_conceptos.signo) as monto
from pla_dinero, pla_conceptos
where pla_dinero.concepto = pla_conceptos.concepto
union
select pla_dinero.id, pla_dinero.compania, pla_dinero.id_periodos, pla_dinero.id_pla_proyectos,
pla_dinero.id_pla_departamentos, pla_dinero.codigo_empleado,
pla_dinero.tipo_de_calculo, pla_conceptos.descripcion, pla_reservas_pp.concepto,
pla_dinero.mes, (pla_reservas_pp.monto*pla_conceptos.signo) as monto
from pla_dinero, pla_conceptos, pla_reservas_pp
where pla_dinero.id = pla_reservas_pp.id_pla_dinero
and pla_reservas_pp.concepto = pla_conceptos.concepto
