
begin work;

delete from cxcmorosidad;
delete from cxc_estado_de_cuenta;
delete from cglposteo where aplicacion_origen in ('CXC', 'CGL', 'FAC') and fecha_comprobante >= '2002-3-1';
commit work;

begin work;
delete from cglcomprobante1 where aplicacion_origen in ('CXC', 'FAC') and fecha_comprobante >= '2002-3-1';
delete from cglsldocuenta where year = 2002 and periodo >= 3;
delete from cglsldoaux1 where year = 2002 and periodo >= 3;
delete from cglsldoaux2 where year = 2002 and periodo >= 3;

update cxctrx1 set status = 'R' where fecha_posteo_ajuste_cxc >= '2002-3-1';
update factura1 set status = 'C' where fecha_factura >= '2002-3-1' and status = 'P';
update cglcomprobante1 set estado = 'R' where fecha_comprobante >= '2002-3-1';

commit work;



