

set search_path to planilla;
-- drop view v_pla_marcaciones_grupo_deg;
drop view v_pla_horarios_grupo_deg;
create view v_pla_horarios_grupo_deg as
select pla_tarjeta_tiempo.compania, pla_tarjeta_tiempo.codigo_empleado,
trim(trim(pla_empleados.nombre) || ' ' || trim(pla_empleados.apellido)) as nombre, 
pla_periodos.numero_planilla as numero_de_planilla,
f_to_date(pla_marcaciones.entrada) as fecha, pla_marcaciones.turno,pla_marcaciones.status, pla_marcaciones.autorizado, 
trim(pla_proyectos.proyecto) as proyecto, null as entrada, null as salida
from pla_tarjeta_tiempo, pla_marcaciones, pla_periodos, pla_empleados, pla_proyectos
where pla_proyectos.id = pla_marcaciones.id_pla_proyectos
and pla_empleados.compania = pla_tarjeta_tiempo.compania
and pla_empleados.codigo_empleado = pla_tarjeta_tiempo.codigo_empleado
and pla_tarjeta_tiempo.id_periodos = pla_periodos.id
and pla_tarjeta_tiempo.id = pla_marcaciones.id_tarjeta_de_tiempo
and pla_tarjeta_tiempo.compania = 1075
and pla_periodos.dia_d_pago >= '2014-10-01';

