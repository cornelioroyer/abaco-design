

set search_path to planilla;

select pla_marcaciones.*, pla_tarjeta_tiempo.codigo_empleado
from pla_tarjeta_tiempo, pla_periodos, pla_marcaciones
where pla_tarjeta_tiempo.id_periodos = pla_periodos.id
and pla_tarjeta_tiempo.id = pla_marcaciones.id_tarjeta_de_tiempo
and pla_periodos.tipo_de_planilla = '2'
and pla_periodos.year = 2015
and pla_periodos.numero_planilla = 1
and pla_tarjeta_tiempo.codigo_empleado = '0082'
and pla_periodos.compania = 1288
order by entrada


/*


and f_intervalo(pla_marcaciones.entrada, pla_marcaciones.salida) > 2880

*/

