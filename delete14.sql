delete from rela_cxcfact1_cglposteo;
delete from rela_cxpajuste1_cglposteo;
delete from rela_cxpfact1_cglposteo;
delete from rela_cxctrx1_cglposteo;
delete from dba.cglcomprobante1 where year = 2000 and compania = '03' and (aplicacion_origen = 'CXC' or aplicacion_origen = 'CXP');
delete from cxpbalance;
delete from cglposteo where year = 2000 and compania = '03'  and (aplicacion_origen = 'CXC' or aplicacion_origen = 'CXP');
delete from cxpdocm where fecha_posteo >= '2000-1-1';
delete from cxcdocm where fecha_posteo >= '2000-1-1';
delete from cxcbalance;
delete from cglsldocuenta where compania = '03' and year = 2000;
delete from cglsldoaux1 where compania = '03' and year = 2000;
delete from cglsldoaux2 where compania = '03' and year = 2000;
update cxpajuste1 set status = 'R';
update cxpfact1 set status = 'R';
update cxcfact1 set status = 'R';
update cxctrx1 set status = 'R';
commit;