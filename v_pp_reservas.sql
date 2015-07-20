
-- set search_path to planilla;
drop view v_pp_reservas;
create view v_pp_reservas as
select pla_companias.compania, pla_companias.nombre as nombre_compania, 
pla_empleados.nombre, pla_empleados.apellido, pla_empleados.fecha_inicio as fecha_de_inicio,
f_vacacion_proporcional(pla_empleados.compania, codigo_empleado, '2013-12-31') as vacacion_proporcional,
f_xiii_proporcional(pla_empleados.compania, codigo_empleado, '2013-12-31') as xiii_proporcional,
f_prima_de_antiguedad(pla_empleados.compania, codigo_empleado, '2013-12-31') as prima_de_antiguedad,
f_indemnizacion(pla_empleados.compania, codigo_empleado, '2013-12-31') as indemnizacion,
(pla_empleados.salario_bruto*2) as preaviso
from pla_empleados, pla_companias
where pla_empleados.compania = pla_companias.compania
and pla_empleados.compania in (745,746,747,1075)
and fecha_terminacion_real is null and pla_empleados.status in ('A','V')



