

update pla_empleados
set fecha_terminacion_real = fecha_inicio
where compania = 1324
and fecha_terminacion_real is null
and status = 'I'
