begin work;
delete from rela_bcocheck1_cglposteo;
delete from rela_bcotransac1_cglposteo;
delete from rela_afi_cglposteo;
delete from rela_cxcfact1_cglposteo;
delete from rela_cxpajuste1_cglposteo;
delete from rela_cxpfact1_cglposteo;
delete from rela_eys1_cglposteo;
delete from rela_caja_trx1_cglposteo;
delete from rela_cxctrx1_cglposteo;
delete from cglcomprobante1 where aplicacion_origen <> 'CGL';
update cglcomprobante1 set estado = 'R';
delete from cxpbalance;
delete from bcocircula where fecha_posteo >= '2001-3-1';
delete from cglposteo;
delete from cajas_balance;
delete from cxpdocm where aplicacion_origen <> 'SET';
delete from afi_depreciacion;
delete from invbalance;
delete from cxcbalance;
delete from cglsldocuenta;
delete from cglsldoaux1;
delete from cglsldoaux2;
update cxpajuste1 set status = 'R';
update bcocheck1 set status = 'R' where (status = 'U' or status = 'P');
update bcotransac1 set status = 'R';
update eys1 set status = 'R';
update cxpfact1 set status = 'R';
update cxcfact1 set status = 'R';
update cxctrx1 set status = 'R';
update caja_trx1 set status = 'R';
update factura1 set status = 'R';
commit work;












