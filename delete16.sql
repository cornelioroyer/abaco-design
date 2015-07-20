update dba.cglcomprobante1 set estado = 'R' where year = 2000 and compania = '03';
delete from cglsldocuenta where compania = '03' and year = 2000;
delete from cglsldoaux1 where compania = '03' and year = 2000;
delete from cglsldoaux2 where compania = '03' and year = 2000;
commit;
