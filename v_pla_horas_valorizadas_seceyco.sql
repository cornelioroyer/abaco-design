
set search_path to planilla;

drop view v_pla_horas_valorizadas_seceyco;

create view v_pla_horas_valorizadas_seceyco as
select pla_marcaciones.id as id_pla_marcaciones, 
pla_marcaciones.compania, pla_tarjeta_tiempo.codigo_empleado,
trim(pla_empleados.nombre) as nombre, trim(pla_empleados.apellido) as apellido,
pla_periodos.desde, pla_periodos.hasta,
date(pla_marcaciones.entrada) as fecha,
pla_empleados.departamento as id_pla_departamentos,
pla_marcaciones.id_pla_proyectos, trim(pla_proyectos.descripcion) as nombre_proyecto,
pla_periodos.tipo_de_planilla, pla_periodos.year, pla_periodos.numero_planilla,
pla_horas.tipo_de_hora, pla_rela_horas_conceptos.concepto, pla_conceptos.descripcion,
pla_periodos.dia_d_pago, pla_tipos_de_horas.recargo, pla_tipos_de_horas.tiempo_regular, 
pla_tipos_de_horas.signo, 
pla_periodos.id as id_periodos,
((pla_horas.minutos/60)*pla_tipos_de_horas.signo) as horas,
(pla_horas.tasa_por_minuto*60) as tasa_por_hora,
Round(((pla_horas.minutos*pla_tipos_de_horas.signo))*(pla_tipos_de_horas.recargo*pla_horas.tasa_por_minuto), 2) as monto
from pla_horas, pla_marcaciones, pla_tarjeta_tiempo, pla_periodos, 
pla_rela_horas_conceptos, pla_tipos_de_horas, pla_conceptos, pla_empleados, pla_proyectos
where pla_empleados.compania = pla_tarjeta_tiempo.compania
and pla_marcaciones.id_pla_proyectos = pla_proyectos.id
and pla_empleados.codigo_empleado = pla_tarjeta_tiempo.codigo_empleado
and pla_rela_horas_conceptos.concepto = pla_conceptos.concepto
and pla_horas.id_marcaciones = pla_marcaciones.id
and pla_marcaciones.id_tarjeta_de_tiempo = pla_tarjeta_tiempo.id
and pla_tarjeta_tiempo.id_periodos = pla_periodos.id
and pla_horas.tipo_de_hora = pla_rela_horas_conceptos.tipo_de_hora
and pla_horas.tipo_de_hora = pla_tipos_de_horas.tipo_de_hora
and pla_empleados.compania in (1046)
and trim(pla_empleados.codigo_empleado) in ('141')
and date(pla_marcaciones.entrada) >= '2014-03-01';

