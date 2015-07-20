delete from pla_marcaciones 
using pla_tarjeta_tiempo, pla_periodos
where pla_tarjeta_tiempo.id_periodos = pla_periodos.id
and pla_marcaciones.id_tarjeta_de_tiempo = pla_tarjeta_tiempo.id
and pla_periodos.compania in (1142)
and pla_periodos.year = 2012;


delete from pla_dinero
using pla_periodos
where pla_dinero.id_periodos = pla_periodos.id
and pla_periodos.compania in (1142)
and pla_periodos.year = 2012;




