
select pla_marcaciones.*, pla_tarjeta_tiempo.codigo_empleado, pla_tarjeta_tiempo.id_periodos
from pla_tarjeta_tiempo, pla_periodos, pla_marcaciones
where pla_tarjeta_tiempo.id_periodos = pla_periodos.id
and pla_tarjeta_tiempo.id = pla_marcaciones.id_tarjeta_de_tiempo
and f_to_date(pla_marcaciones.entrada) = '2014-08-04'
and pla_tarjeta_tiempo.codigo_empleado = '0030'
and pla_tarjeta_tiempo.compania = 1289
order by pla_marcaciones.entrada

/*
and pla_periodos.year = 2014
and pla_periodos.numero_planilla = 
and pla_periodos.compania = 992
and f_intervalo(pla_marcaciones.entrada, pla_marcaciones.salida) > 2880
and pla_periodos.tipo_de_planilla = '2'
*/
