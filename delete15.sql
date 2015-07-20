delete from rela_caja_trx1_cglposteo where caja = 'SU' or caja = 'WS';
delete from dba.cglcomprobante1 where year = 2000 and compania = '03' and aplicacion_origen = 'CAJ';
delete from cglposteo where year = 2000 and compania = '03' and aplicacion_origen = 'CAJ';
delete from cajas_balance;
update caja_trx1 set status = 'R';
delete from cglsldocuenta where compania = '03' and year = 2000;
delete from cglsldoaux1 where compania = '03' and year = 2000;
delete from cglsldoaux2 where compania = '03' and year = 2000;
commit;
