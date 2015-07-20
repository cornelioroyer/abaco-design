
delete from pla_auxiliares
where compania = 1324;

delete from pla_marcaciones
using pla_tarjeta_tiempo
where pla_marcaciones.id_tarjeta_de_tiempo = pla_tarjeta_tiempo.id
and pla_tarjeta_tiempo.compania = 1324
and pla_tarjeta_tiempo.codigo_empleado = '31';

delete from pla_tarjeta_tiempo where compania = 1324
and codigo_empleado = '31';

delete from pla_dinero where compania = 1324
and codigo_empleado = '31';

delete from pla_empleados where compania = 1324
and codigo_empleado = '31';



/*
update pla_periodos
set status = 'C'
where compania = 1324;

update pla_periodos
set status = 'A'
where compania = 1324
and year >= 2010;


delete from pla_deducciones
where id_pla_dinero in (select id from pla_dinero 
                        where compania = 1324);

delete from pla_permisos
where compania = 1324;

delete from pla_certificados_medico
where compania = 1324;


delete from pla_retenciones
where compania = 1324;


delete from pla_otros_ingresos_fijos
where compania = 1324;

delete from pla_marcaciones
where id_tarjeta_de_tiempo in (select id from pla_tarjeta_tiempo
                                    where compania = 1324);

delete from pla_tarjeta_tiempo where compania = 1324;

delete from pla_dinero where compania = 1324;

delete from pla_auxiliares where compania = 1324;

*/
