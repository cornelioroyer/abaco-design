select 
from pla_horas, pla_marcaciones, pla_tarjeta_tiempo
where pla_marcaciones.id_tarjeta_de_tiempo = pla_tarjeta_tiempo.id
and pla_marcaciones.id = pla_hora.id_marcaciones