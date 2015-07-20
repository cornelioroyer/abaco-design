

delete from pla_horas
using pla_tarjeta_tiempo, pla_periodos, pla_empleados, pla_departamentos, pla_marcaciones
where pla_horas.id_marcaciones = pla_marcaciones.id
and pla_tarjeta_tiempo.id_periodos = pla_periodos.id
and pla_marcaciones.id_tarjeta_de_tiempo = pla_tarjeta_tiempo.id
and pla_tarjeta_tiempo.compania = pla_empleados.compania
and pla_tarjeta_tiempo.codigo_empleado = pla_empleados.codigo_empleado
and pla_empleados.departamento = pla_departamentos.id
and pla_periodos.compania in (1353)
and pla_periodos.year = 2015
and pla_periodos.tipo_de_planilla = '2'
and pla_periodos.numero_planilla = 11;


/*

and pla_horas.minutos = 0

delete from pla_horas
using pla_tarjeta_tiempo, pla_periodos, pla_empleados, pla_departamentos, pla_marcaciones
where pla_horas.id_marcaciones = pla_marcaciones.id
and pla_tarjeta_tiempo.id_periodos = pla_periodos.id
and pla_marcaciones.id_tarjeta_de_tiempo = pla_tarjeta_tiempo.id
and pla_tarjeta_tiempo.compania = pla_empleados.compania
and pla_tarjeta_tiempo.codigo_empleado = pla_empleados.codigo_empleado
and pla_empleados.departamento = pla_departamentos.id
and pla_periodos.compania in (1296)
and pla_periodos.year = 2014
and pla_periodos.tipo_de_planilla = '2'
and pla_periodos.numero_planilla = 21
and pla_horas.forma_de_registro = 'M'
and pla_horas.minutos = 0
and pla_horas.tipo_de_hora = '00'




and f_to_date(pla_marcaciones.entrada) >= '2014-01-01';

*/
