
/*
begin work;
delete from pla_certificados;
commit work;
*/


begin work;
insert into pla_certificados (codigo_empleado, compania,
f_desde, h_desde, f_hasta, h_hasta, horas,
pagado, observacion, usuario, fecha_captura)
select codigo_empleado, compania, fecha, '07:00', fecha,
'07:00', ((dias*8)+horas), pagado, observacion, current_user, current_timestamp
from placertificadosmedico;
commit work;