

delete from pla_tarjeta_tiempo
where not exists
(select * from pla_empleados
where pla_empleados.compania = pla_tarjeta_tiempo.compania
and pla_empleados.codigo_empleado = pla_tarjeta_tiempo.codigo_empleado)

/*

delete from pla_retenciones
where not exists
(select * from pla_empleados
where pla_empleados.compania = pla_retenciones.compania
and pla_empleados.codigo_empleado = pla_retenciones.codigo_empleado)


*/
