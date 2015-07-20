delete from pla_liquidacion
using pla_empleados
where pla_liquidacion.compania = pla_empleados.compania
and pla_liquidacion.codigo_empleado = pla_empleados.codigo_empleado
and pla_empleados.compania = 745
and pla_empleados.tipo_de_planilla = '3'
and pla_liquidacion.fecha >= '2011-12-25';

