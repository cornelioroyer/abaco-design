

insert into pla_horarios(compania, codigo_empleado, dia, turno)
select compania, codigo_empleado, 0, '3'
from pla_empleados
where compania = 1240
and tipo_de_planilla = '3'
and not exists
(select * from pla_horarios a
where a.compania = pla_empleados.compania
and a.codigo_empleado = pla_empleados.codigo_empleado
and a.dia = 0)
