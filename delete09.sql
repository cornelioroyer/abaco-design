delete from cglsldocuenta;
delete from cglsldoaux1;
delete from cglsldoaux2;
delete from rela_bcocheck1_cglposteo;
delete from rela_bcotransac1_cglposteo;
delete from rela_afi_cglposteo;
delete from rela_caja_trx1_cglposteo;
delete from rela_cxcfact1_cglposteo;
delete from rela_cxctrx1_cglposteo;
delete from rela_cxpajuste1_cglposteo;
delete from rela_cxpfact1_cglposteo;
delete from rela_eys1_cglposteo;
delete from rela_factura1_cglposteo;
delete from dba.cglcomprobante1 where aplicacion_origen <> 'CGL';
update cglcomprobante1 set estado = 'R';
update cxpfact1 set status = 'R';
delete from cxpbalance;
delete from bcocircula;
delete from bcobalance;
delete from cglposteo;
update bcotransac1 set status = 'R';
update bcocheck1 set status = 'R';
update caja_trx1 set status = 'R';
delete from cajas_balance;
delete from cxpdocm;
update eys1 set status = 'R';
commit;
