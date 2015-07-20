update pla_dinero
set id_pla_proyectos = pla_empleados.id_pla_proyectos
from pla_empleados, pla_periodos
where pla_periodos.id = pla_dinero.id_periodos
and pla_dinero.compania = pla_empleados.compania
and pla_dinero.codigo_empleado = pla_empleados.codigo_empleado
and pla_dinero.compania = 1199
and pla_periodos.year = 2014
and pla_periodos.numero_planilla = 4
and pla_dinero.tipo_de_calculo = '3'
