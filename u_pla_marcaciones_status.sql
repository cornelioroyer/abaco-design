
update pla_marcaciones
set status = 'R'
from pla_tarjeta_tiempo, pla_periodos
where pla_tarjeta_tiempo.id_periodos = pla_periodos.id
and pla_tarjeta_tiempo.id = pla_marcaciones.id_tarjeta_de_tiempo
and pla_periodos.compania in (1360)
and pla_periodos.tipo_de_planilla = '2'
and pla_periodos.year = 2015
and pla_periodos.numero_planilla = 13
and f_to_date(pla_marcaciones.entrada) <= '2015-07-07';


/*

and pla_marcaciones.status = 'R';

and f_to_date(pla_marcaciones.entrada) between '2014-12-08' and '2014-12-08'

*/
