begin work;
delete from cglposteo where fecha_comprobante >= '2002-1-1' and aplicacion_origen in ('BCO', 'CGL') and compania <> '03';
delete from cglcomprobante1 where aplicacion_origen in ('BCO') and fecha_comprobante >= '2002-1-1' and compania <> '03';
delete from cglsldocuenta where year >= 2002 and periodo >= 1 and compania <> '03';
delete from cglsldoaux1 where year >= 2002 and periodo >= 1 and compania <> '03';
delete from cglsldoaux2 where year >= 2002 and periodo >= 1 and compania <> '03';
delete from bcobalance where year >= 2002 and periodo >= 1 and cod_ctabco = '02';
delete from bcocircula where fecha_posteo >= '2002-1-1' and status <> 'C' and cod_ctabco = '02';

update bcocheck1 set status = 'R' where status <> 'A' and fecha_posteo >= '2002-1-1' and cod_ctabco = '02';
update bcotransac1 set status = 'R' where fecha_posteo >= '2002-1-1' and cod_ctabco = '02';
update cglcomprobante1 set estado = 'R' where fecha_comprobante >= '2002-1-1' and compania <> '03';

commit work;














