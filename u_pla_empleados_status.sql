update pla_empleados
set status = 'I' 
where compania = 992
and fecha_terminacion_real is not null;
