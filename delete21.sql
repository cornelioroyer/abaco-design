begin work;
delete from rela_caja_trx1_cglposteo;
delete from cglcomprobante1 where aplicacion_origen = 'CAJ';
update cglcomprobante1 set estado = 'R';
delete from cglposteo where aplicacion_origen = 'CAJ';
delete from cajas_balance;
delete from cglsldocuenta;
delete from cglsldoaux1;
delete from cglsldoaux2;
update caja_trx1 set status = 'R';
commit work;













