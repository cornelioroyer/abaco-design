update pla_marcaciones
set entrada_descanso = null, salida_descanso = null
from pla_tarjeta_tiempo, pla_periodos
where pla_tarjeta_tiempo.id_periodos = pla_periodos.id
and pla_tarjeta_tiempo.id = pla_marcaciones.id_tarjeta_de_tiempo
and pla_periodos.tipo_de_planilla = '2'
and pla_periodos.year = 2011
and pla_periodos.numero_planilla = 14
and pla_periodos.compania = 992;




