
set search_path to planilla;

select pla_marcaciones.entrada, pla_horas.*
from pla_tarjeta_tiempo, pla_marcaciones, pla_periodos, pla_horas
where pla_tarjeta_tiempo.id = pla_marcaciones.id_tarjeta_de_tiempo
and pla_tarjeta_tiempo.id_periodos = pla_periodos.id
and pla_marcaciones.id = pla_horas.id_marcaciones
and pla_tarjeta_tiempo.compania = 749 and pla_tarjeta_tiempo.codigo_empleado = '2205'
and pla_periodos.year = 2014
and pla_periodos.numero_planilla = 18
