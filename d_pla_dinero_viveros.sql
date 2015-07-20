delete from pla_dinero
using pla_empleados
where pla_dinero.compania = pla_empleados.compania
and pla_dinero.codigo_empleado = pla_empleados.codigo_empleado
and pla_empleados.status = 'I'
and pla_dinero.compania = 1240

