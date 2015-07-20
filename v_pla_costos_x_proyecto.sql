drop view v_pla_costos_x_proyecto;

create view v_pla_costos_x_proyecto as
select pla_dinero.id, pla_dinero.compania, pla_dinero.id_periodos, 
pla_periodos.year,
pla_periodos.numero_planilla as numero_planilla,
pla_proyectos.descripcion as desc_proyecto,
pla_dinero.id_pla_proyectos,
pla_dinero.codigo_empleado,
pla_dinero.tipo_de_calculo, 
pla_periodos.tipo_de_planilla,
pla_conceptos.prioridad_impresion, 
pla_conceptos.descripcion, pla_dinero.concepto,
pla_periodos.year as anio, pla_dinero.mes, 
(pla_dinero.monto*pla_conceptos.signo) as monto
from pla_dinero, pla_conceptos, pla_periodos, pla_proyectos
where pla_dinero.id_pla_proyectos = pla_proyectos.id
and pla_dinero.concepto = pla_conceptos.concepto
and pla_dinero.id_periodos = pla_periodos.id
and pla_conceptos.tipo_de_concepto <> '2'
union
select pla_dinero.id, pla_dinero.compania, pla_dinero.id_periodos, 
pla_periodos.year,
pla_periodos.numero_planilla,
pla_proyectos.descripcion as desc_proyecto,
pla_dinero.id_pla_proyectos,
pla_dinero.codigo_empleado,
pla_dinero.tipo_de_calculo, 
pla_periodos.tipo_de_planilla,
pla_conceptos.prioridad_impresion, 
pla_conceptos.descripcion, 
pla_reservas_pp.concepto,
pla_periodos.year, pla_dinero.mes, 
(pla_reservas_pp.monto*pla_conceptos.signo) as monto
from pla_dinero, pla_conceptos, pla_reservas_pp, pla_periodos, pla_proyectos
where pla_dinero.id = pla_reservas_pp.id_pla_dinero
and pla_dinero.id_pla_proyectos = pla_proyectos.id
and pla_reservas_pp.concepto = pla_conceptos.concepto
and pla_dinero.id_periodos = pla_periodos.id
and pla_conceptos.tipo_de_concepto <> '2';
