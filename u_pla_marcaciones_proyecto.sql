update pla_marcaciones
set id_pla_proyectos = pla_empleados.id_pla_proyectos
from pla_tarjeta_tiempo, pla_periodos, pla_empleados
where pla_tarjeta_tiempo.compania = pla_empleados.compania
and pla_tarjeta_tiempo.codigo_empleado = pla_empleados.codigo_empleado
and pla_tarjeta_tiempo.id_periodos = pla_periodos.id
and pla_tarjeta_tiempo.id = pla_marcaciones.id_tarjeta_de_tiempo
and pla_periodos.tipo_de_planilla = '2'
and pla_periodos.year = 2015
and pla_periodos.numero_planilla = 12
and pla_periodos.compania = 1353
