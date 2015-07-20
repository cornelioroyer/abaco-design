
update pla_horarios
set turno = '1'
from pla_empleados
where pla_empleados.compania = pla_horarios.compania
and pla_empleados.codigo_empleado = pla_horarios.codigo_empleado
and pla_empleados.tipo_de_planilla = '3'
and pla_horarios.dia <> 6
and pla_empleados.compania = 1289;
