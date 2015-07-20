begin work;
delete from cglposteo where aplicacion_origen in ('CGL', 'FAC') and fecha_comprobante >= '2002-3-1';
delete from cglcomprobante1 where aplicacion_origen in ('FAC') and fecha_comprobante >= '2002-3-1';
delete from cglsldocuenta where year = 2002 and periodo >= 3;
delete from cglsldoaux1 where year = 2002 and periodo >= 3;
delete from cglsldoaux2 where year = 2002 and periodo >= 3;
update factura1 set status = 'C' where fecha_factura >= '2002-3-1' and status = 'P';
update cglcomprobante1 set estado = 'R' where fecha_comprobante >= '2002-3-1';

commit work;





