update pla_marcaciones
set entrada = f_timestamp(Date(entrada), '05:00:00')
from pla_tarjeta_tiempo, pla_periodos
where pla_tarjeta_tiempo.id_periodos = pla_periodos.id
and pla_tarjeta_tiempo.id = pla_marcaciones.id_tarjeta_de_tiempo
and pla_periodos.tipo_de_planilla = '2'
and pla_periodos.year = 2013
and pla_periodos.numero_planilla = 6
and pla_periodos.compania = 1046
