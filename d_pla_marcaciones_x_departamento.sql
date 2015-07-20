delete from pla_marcaciones
using pla_tarjeta_tiempo, pla_empleados
where pla_marcaciones.id_tarjeta_de_tiempo = pla_tarjeta_tiempo.id
and pla_tarjeta_tiempo.compania = pla_empleados.compania
and pla_tarjeta_tiempo.codigo_empleado = pla_empleados.codigo_empleado
and pla_empleados.compania = 992
and pla_tarjeta_tiempo.id_periodos = 184811
