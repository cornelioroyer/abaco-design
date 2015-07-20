begin work;
delete from cglposteo where aplicacion_origen in ('CAJ', 'CGL') and fecha_comprobante >= '2002-1-1';
delete from cglcomprobante1 where aplicacion_origen = 'CAJ'and fecha_comprobante >= '2002-1-1';
delete from cglsldocuenta where year = 2002 and periodo >= 1;
delete from cglsldoaux1 where year = 2002 and periodo >= 1;
delete from cglsldoaux2 where year = 2002 and periodo >= 1;
delete from cajas_balance where year = 2002 and periodo >= 1;

update caja_trx1 set status = 'R' where fecha_posteo >= '2002-1-1';
update cglcomprobante1 set estado = 'R' where fecha_comprobante >= '2002-1-1';

commit work;






