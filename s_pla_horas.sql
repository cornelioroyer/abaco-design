

update pla_horas
set minutos = 0
from pla_tarjeta_tiempo, pla_marcaciones, pla_empleados
where pla_tarjeta_tiempo.id = pla_marcaciones.id_tarjeta_de_tiempo
and pla_empleados.compania = pla_tarjeta_tiempo.compania
and pla_empleados.codigo_empleado = pla_tarjeta_tiempo.codigo_empleado
and pla_marcaciones.id = pla_horas.id_marcaciones
and pla_tarjeta_tiempo.compania = 1240
and pla_empleados.tipo_de_planilla = '3'
and pla_marcaciones.entrada < '2013-10-31'
and pla_horas.tipo_de_hora = '00';


select pla_horas.* from pla_tarjeta_tiempo, pla_marcaciones, pla_horas, pla_empleados
where pla_tarjeta_tiempo.id = pla_marcaciones.id_tarjeta_de_tiempo
and pla_empleados.compania = pla_tarjeta_tiempo.compania
and pla_empleados.codigo_empleado = pla_tarjeta_tiempo.codigo_empleado
and pla_marcaciones.id = pla_horas.id_marcaciones
and pla_tarjeta_tiempo.compania = 1240
and pla_empleados.tipo_de_planilla = '3'
and pla_marcaciones.entrada < '2013-10-31'
and pla_horas.tipo_de_hora = '00';

