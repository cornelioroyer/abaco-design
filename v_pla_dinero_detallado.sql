drop view v_pla_dinero_detallado;
create view v_pla_dinero_detallado as
select pla_dinero.compania, pla_empleados.apellido, pla_empleados.nombre, 
pla_empleados.codigo_empleado, pla_conceptos.tipo_de_concepto,
pla_tipos_de_conceptos.descripcion as desc_concepto, pla_conceptos.prioridad_impresion,
pla_empleados.departamento, pla_departamentos.descripcion as desc_departamento, 
sum(pla_dinero.monto*pla_conceptos.signo) as monto
from pla_dinero, pla_conceptos, pla_empleados, pla_periodos, pla_departamentos,
pla_tipos_de_conceptos
where pla_dinero.concepto = pla_conceptos.concepto
and pla_tipos_de_conceptos.tipo_de_concepto = pla_conceptos.tipo_de_concepto
and pla_dinero.id_pla_departamentos = pla_departamentos.id
and pla_dinero.id_periodos = pla_periodos.id
and pla_dinero.compania = pla_empleados.compania
and pla_dinero.codigo_empleado = pla_empleados.codigo_empleado
and pla_dinero.compania = 745
and pla_empleados.tipo_de_planilla = '1'
and pla_periodos.numero_planilla = 16
group by 1, 2, 3, 4, 5, 6, 7, 8, 9