


begin work;
delete from cglposteo where fecha_comprobante >= '2002-3-1' and aplicacion_origen in ('COM','CGL');
delete from cglcomprobante1 where fecha_comprobante >= '2002-3-1' and aplicacion_origen = 'COM';
delete from cglsldocuenta where year >= 2002 and periodo >= 3;
delete from cglsldoaux1 where year >= 2002 and periodo >= 3;
delete from cglsldoaux2 where year >= 2002 and periodo >= 3;
delete from cxc_estado_de_cuenta;
update cglcomprobante1 set estado = 'R' where fecha_comprobante >= '2002-3-1';
commit work;
begin work;
update cxpfact1 set status = 'R' where fecha_posteo_fact_cxp >= '2002-3-1' and aplicacion_origen = 'COM';
commit work;














