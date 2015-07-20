drop view v_pla_implementos_valorizados cascade;

create view v_pla_implementos_valorizados as
select '1' as tipo_de_calculo, pla_marcaciones.id as id_pla_marcaciones, pla_marcaciones.compania, pla_tarjeta_tiempo.codigo_empleado,
date(pla_marcaciones.entrada) as fecha,
pla_empleados.departamento as id_pla_departamentos,
pla_marcaciones.id_pla_proyectos,
pla_periodos.tipo_de_planilla, pla_periodos.year, pla_periodos.numero_planilla,
pla_horas.tipo_de_hora, pla_implementos.concepto, pla_conceptos.descripcion,
pla_periodos.dia_d_pago, pla_tipos_de_horas.recargo, pla_implementos.recargo as recargo_implemento, 
pla_tipos_de_horas.tiempo_regular, 
pla_tipos_de_horas.signo, 
pla_periodos.id as id_periodos,
Round(sum((pla_horas.minutos_implemento)*pla_tipos_de_horas.signo), 2) as minutos,
Round(sum((pla_horas.minutos*pla_tipos_de_horas.signo))*avg(pla_tipos_de_horas.recargo*pla_horas.tasa_por_minuto) * (pla_implementos.recargo/100),2) as monto
from pla_horas, pla_marcaciones, pla_tarjeta_tiempo, pla_periodos, 
pla_tipos_de_horas, pla_conceptos, pla_empleados, pla_implementos
where pla_horas.compania = pla_implementos.compania
and pla_horas.implemento = pla_implementos.implemento
and pla_empleados.compania = pla_tarjeta_tiempo.compania
and pla_empleados.codigo_empleado = pla_tarjeta_tiempo.codigo_empleado
and pla_implementos.concepto = pla_conceptos.concepto
and pla_horas.id_marcaciones = pla_marcaciones.id
and pla_marcaciones.id_tarjeta_de_tiempo = pla_tarjeta_tiempo.id
and pla_tarjeta_tiempo.id_periodos = pla_periodos.id
and pla_horas.tipo_de_hora = pla_tipos_de_horas.tipo_de_hora
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,11, 12, 13, 14, 15,16, 17, 18, 19;



