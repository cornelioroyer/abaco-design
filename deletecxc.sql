
begin work;

delete from cxcmorosidad;
delete from cxc_estado_de_cuenta;
delete from cglposteo where aplicacion_origen in ('CXC', 'CGL') and fecha_comprobante >= '2001-12-1';
delete from cglcomprobante1 where aplicacion_origen in ('CXC') and fecha_comprobante >= '2001-12-1';
delete from cxcdocm where aplicacion_origen in ('CXC') and fecha_posteo >= '2001-12-1';
delete from cglsldocuenta where year = 2001 and periodo >= 12;
delete from cglsldoaux1 where year = 2001 and periodo >= 12;
delete from cglsldoaux2 where year = 2001 and periodo >= 12;
delete from cxcbalance;

update cxcfact1 set status = 'R' where fecha_posteo_fact >= '2001-12-1';
update cxctrx1 set status = 'R' where fecha_posteo_ajuste_cxc >= '2001-12-1';
update cglcomprobante1 set estado = 'R' where fecha_comprobante >= '2001-12-1';

commit work;



