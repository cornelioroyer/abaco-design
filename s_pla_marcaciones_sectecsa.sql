
select pla_marcaciones.entrada, pla_periodos.*, pla_tarjeta_tiempo.*, pla_marcaciones.*
from pla_tarjeta_tiempo, pla_marcaciones, pla_periodos
where pla_tarjeta_tiempo.id = pla_marcaciones.id_tarjeta_de_tiempo
and pla_tarjeta_tiempo.id_periodos = pla_periodos.id
and pla_tarjeta_tiempo.compania = 1261
and date(pla_marcaciones.entrada) >= '2014-07-16'
and trim(pla_tarjeta_tiempo.codigo_empleado) = '0544'
order by pla_marcaciones.entrada

/*
and pla_periodos.tipo_de_planilla = '2'
and pla_periodos.year = 2014
and pla_periodos.numero_planilla = 14

*/
