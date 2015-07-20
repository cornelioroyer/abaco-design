delete from pla_marcaciones using pla_tarjeta_tiempo, pla_empleados
where pla_marcaciones.id_tarjeta_de_tiempo = pla_tarjeta_tiempo.id
and pla_tarjeta_tiempo.compania = pla_empleados.compania
and pla_tarjeta_tiempo.codigo_empleado = pla_empleados.codigo_empleado
and pla_tarjeta_tiempo.compania = 745
and pla_empleados.status in ('I','E');

delete from pla_auxiliares
where compania = 745;

delete from pla_tarjeta_tiempo
where exists
(select * from pla_empleados
where compania = 745
and status in ('I', 'E'));

delete from pla_dinero using pla_empleados
where pla_dinero.compania = pla_empleados.compania
and pla_dinero.codigo_empleado = pla_empleados.codigo_empleado
and pla_empleados.compania = 745
and pla_empleados.status in ('I','E');


delete from pla_retenciones using pla_empleados
where pla_retenciones.compania = pla_empleados.compania
and pla_retenciones.codigo_empleado = pla_empleados.codigo_empleado
and pla_empleados.compania = 745
and pla_empleados.status in ('I','E');



delete from pla_empleados
where compania = 745
and status in ('I', 'E');

