begin work;
delete from cglposteo where fecha_comprobante >= '2002-2-1' and aplicacion_origen = 'CGL';
delete from cglsldocuenta where year >= 2002 and periodo >= 2;
delete from cglsldoaux1 where year >= 2002 and periodo >= 2;
delete from cglsldoaux2 where year >= 2002 and periodo >= 2;
delete from cxc_estado_de_cuenta;
update cglcomprobante1 set estado = 'R' where fecha_comprobante >= '2002-2-1';

commit work;














