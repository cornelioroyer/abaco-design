
update pla_marcaciones
set autorizado = 'S'
from pla_tarjeta_tiempo, pla_periodos
where pla_tarjeta_tiempo.id_periodos = pla_periodos.id
and pla_tarjeta_tiempo.id = pla_marcaciones.id_tarjeta_de_tiempo
and pla_periodos.tipo_de_planilla = '2'
and pla_periodos.year = 2015
and pla_periodos.numero_planilla = 2
and pla_periodos.compania = 1046;


/*

and pla_marcaciones.turno is null

*/




