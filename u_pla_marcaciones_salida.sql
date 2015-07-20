/*
update pla_marcaciones
set salida = salida + '1800 second'
from pla_tarjeta_tiempo, pla_periodos
where pla_tarjeta_tiempo.id_periodos = pla_periodos.id
and pla_tarjeta_tiempo.id = pla_marcaciones.id_tarjeta_de_tiempo
and pla_periodos.tipo_de_planilla = '2'
and pla_periodos.year = 2012
and pla_periodos.numero_planilla = 10
and pla_periodos.compania = 1077
and extract(hour from pla_marcaciones.salida) = 17;
*/

select pla_marcaciones.salida, pla_marcaciones.*
from pla_tarjeta_tiempo, pla_periodos, pla_marcaciones
where pla_tarjeta_tiempo.id_periodos = pla_periodos.id
and pla_tarjeta_tiempo.id = pla_marcaciones.id_tarjeta_de_tiempo
and pla_periodos.tipo_de_planilla = '2'
and pla_periodos.year = 2012
and pla_periodos.numero_planilla = 10
and pla_periodos.compania = 1077
and extract(hour from pla_marcaciones.salida) = 17;
