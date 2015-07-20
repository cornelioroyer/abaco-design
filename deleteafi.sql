begin work;
delete from cglposteo where fecha_comprobante >= '2001-9-1' and aplicacion_origen in ('CGL', 'AFI');
delete from cglcomprobante1 where aplicacion_origen = 'AFI' and fecha_comprobante >= '2001-9-1';
delete from afi_depreciacion where year >= 2001 and periodo >= 9;
delete from cglsldocuenta where year >= 2001 and periodo >= 9;
delete from cglsldoaux1 where year >= 2001 and periodo >= 9;
delete from cglsldoaux2 where year >= 2001 and periodo >= 9;

update cglcomprobante1 set estado = 'R' where fecha_comprobante >= '2001-9-1';

commit work;














