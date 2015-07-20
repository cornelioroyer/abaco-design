update pla_horarios
set turno = 4
from pla_empleados, pla_departamentos
where pla_empleados.departamento = pla_departamentos.id
and pla_empleados.compania = pla_horarios.compania
and pla_empleados.codigo_empleado = pla_horarios.codigo_empleado
and pla_horarios.compania = 1261
and pla_departamentos.id = 1979
