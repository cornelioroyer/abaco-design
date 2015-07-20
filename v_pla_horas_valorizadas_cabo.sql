set search_path to planilla;

drop view v_pla_horas_valorizadas_cabo;

create view v_pla_horas_valorizadas_cabo as
select pla_marcaciones.compania, pla_proyectos.descripcion, pla_tarjeta_tiempo.codigo_empleado,
pla_periodos.dia_d_pago, 
pla_marcaciones.entrada as fecha,
pla_tipos_de_horas.recargo, 
trim(pla_empleados.nombre) || '  ' || trim(pla_empleados.apellido) as nombre_empleado,
trim(pla_cargos.descripcion) as cargo,
round(sum((pla_horas.minutos)*pla_tipos_de_horas.signo)/60, 2) as horas,
Round(sum((pla_horas.minutos*pla_tipos_de_horas.signo))*avg(pla_tipos_de_horas.recargo*pla_horas.tasa_por_minuto),2) as monto
from pla_horas, pla_marcaciones, pla_tarjeta_tiempo, pla_periodos, 
 pla_tipos_de_horas, pla_empleados, pla_proyectos, pla_cargos
where pla_empleados.compania = pla_tarjeta_tiempo.compania
and pla_empleados.cargo = pla_cargos.id
and pla_empleados.codigo_empleado = pla_tarjeta_tiempo.codigo_empleado
and pla_marcaciones.id_pla_proyectos = pla_proyectos.id
and pla_horas.id_marcaciones = pla_marcaciones.id
and pla_marcaciones.id_tarjeta_de_tiempo = pla_tarjeta_tiempo.id
and pla_tarjeta_tiempo.id_periodos = pla_periodos.id
and pla_horas.tipo_de_hora = pla_tipos_de_horas.tipo_de_hora
and pla_periodos.dia_d_pago >= '2013-06-01'
and pla_empleados.compania in (749)
group by 1, 2, 3, 4, 5, 6, 7;
