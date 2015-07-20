select trim(pla_dinero.descripcion) as descripcion,
trim(pla_empleados.apellido) as apellido, trim(pla_empleados.nombre) as nombre,
pla_dinero.monto
from pla_dinero, pla_empleados, pla_periodos, pla_conceptos
where pla_dinero.compania = pla_empleados.compania
and pla_dinero.codigo_empleado = pla_empleados.codigo_empleado
and pla_dinero.id_periodos = pla_periodos.id
and pla_dinero.concepto = pla_conceptos.concepto
and pla_conceptos.signo < 0
and pla_dinero.compania = 1261
and pla_periodos.year = 2014
and pla_periodos.numero_planilla = 13
and pla_conceptos.tipo_de_concepto = '2'
order by 1, 2, 3
