


insert into pla_liquidacion(compania, codigo_empleado, fecha, fecha_d_pago, fecha_indemnizacion, 
preliminar, justificado)
select compania, codigo_empleado, fecha, fecha_d_pago, fecha_indemnizacion, preliminar, justificado
from tmp_pla_liquidacion_apra;


/*

insert into pla_liquidacion(compania, codigo_empleado, fecha, preliminar, justificado)
values (1142,'1048',current_date,true,false);


*/



