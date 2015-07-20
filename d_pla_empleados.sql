
update pla_periodos
set status = 'C'
where compania = 716;

update pla_periodos
set status = 'A'
where compania = 716
and year >= 2010;


delete from pla_deducciones
where id_pla_dinero in (select id from pla_dinero 
                        where compania = 716);

delete from pla_permisos
where compania = 716;

delete from pla_certificados_medico
where compania = 716;


delete from pla_retenciones
where compania = 716;


delete from pla_otros_ingresos_fijos
where compania = 716;

delete from pla_marcaciones
where id_tarjeta_de_tiempo in (select id from pla_tarjeta_tiempo
                                    where compania = 716);

delete from pla_tarjeta_tiempo where compania = 716;

delete from pla_dinero where compania = 716;

delete from pla_auxiliares where compania = 716;

delete from pla_empleados where compania = 716;