create view v_pla_reservas as
select pla_periodos.compania, pla_empleados.apellido, pla_empleados.nombre,
pla_empleados.codigo_empleado,
pla_dinero.tipo_de_calculo, 
pla_periodos.tipo_de_planilla, pla_periodos.year, pla_periodos.numero_planilla,
pla_dinero.id_pla_departamentos,
pla_dinero.id_pla_proyectos,
pla_periodos.dia_d_pago as fecha, 
pla_conceptos.descripcion as d_concepto_acumula, 
pla_conceptos.concepto as concepto_acumula,
(pla_dinero.monto*pla_conceptos.signo) as monto_acumula,
null as d_concepto_reserva, null as concepto_reserva, 0 as monto_reserva
from pla_periodos, pla_dinero, pla_conceptos, pla_empleados, pla_reservas_pp
where pla_periodos.id = pla_dinero.id_periodos
and pla_dinero.concepto = pla_conceptos.concepto
and pla_empleados.compania = pla_dinero.compania
and pla_empleados.codigo_empleado = pla_dinero.codigo_empleado
and pla_reservas_pp.id_pla_dinero = pla_dinero.id
