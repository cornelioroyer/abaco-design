delete from rela_bcocheck1_cglposteo;
delete from rela_bcotransac1_cglposteo;
delete from rela_afi_cglposteo;
delete from rela_cxcfact1_cglposteo;
delete from rela_cxpajuste1_cglposteo;
delete from rela_cxpfact1_cglposteo;
delete from rela_eys1_cglposteo;
delete from rela_factura1_cglposteo;
delete from rela_caja_trx1_cglposteo where caja = 'SU' or caja = 'WS';
delete from rela_cxctrx1_cglposteo;
delete from dba.cglcomprobante1 where year = 2000 and compania = '03' and tipo_comp <> '013';
update dba.cglcomprobante1 set estado = 'R' where year = 2000 and compania = '03';
delete from cxpbalance;
delete from bcocircula where fecha_posteo >= '2000-1-1';
delete from bcobalance;
delete from cglposteo where year = 2000 and compania = '03';
delete from cajas_balance;
delete from cxpdocm where fecha_posteo >= '2000-1-1';
delete from afi_depreciacion where year >= 2000;
delete from invbalance;
delete from cxcdocm where fecha_posteo >= '2000-1-1';
delete from cxcbalance;
delete from factura1;
delete from cglsldocuenta where compania = '03' and year = 2000;
delete from cglsldoaux1 where compania = '03' and year = 2000;
delete from cglsldoaux2 where compania = '03' and year = 2000;
update cxpajuste1 set status = 'R';
update bcocheck1 set status = 'R';
update bcotransac1 set status = 'R';
update eys1 set status = 'R';
update cxpfact1 set status = 'R';
update cxcfact1 set status = 'R';
update cxctrx1 set status = 'R';
update caja_trx1 set status = 'R';
commit;
