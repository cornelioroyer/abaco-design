select pla_liquidacion_acumulados.* 
from pla_liquidacion, pla_liquidacion_calculo, pla_liquidacion_acumulados
where pla_liquidacion.id = pla_liquidacion_calculo.id_pla_liquidacion
and pla_liquidacion_calculo.id = pla_liquidacion_acumulados.id_pla_liquidacion_calculo
and pla_liquidacion.compania = 30