update pla_marcaciones
set turno = 2
from pla_tarjeta_tiempo, pla_periodos
where pla_tarjeta_tiempo.id_periodos = pla_periodos.id
and pla_tarjeta_tiempo.id = pla_marcaciones.id_tarjeta_de_tiempo
and pla_periodos.tipo_de_planilla = '3'
and pla_periodos.year = 2015
and pla_periodos.numero_planilla = 8
and f_to_date(pla_marcaciones.entrada) = '2015-04-11'
and pla_periodos.compania = 1289

