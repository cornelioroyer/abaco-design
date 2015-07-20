begin work;
delete from cglposteo where fecha_comprobante >= '2001-11-1' and aplicacion_origen in ('CXP', 'BCO', 'CGL');
delete from cglcomprobante1 where aplicacion_origen in ('CXP','BCO') and fecha_comprobante >= '2001-11-1';
delete from cxpbalance where year >= 2001 and periodo >= 11;
delete from cglsldocuenta where year >= 2001 and periodo >= 11;
delete from cglsldoaux1 where year >= 2001 and periodo >= 11;
delete from cglsldoaux2 where year >= 2001 and periodo >= 11;
delete from bcobalance where year >= 2001 and periodo >= 11;
delete from cxc_estado_de_cuenta;
delete from bcocircula where fecha_posteo >= '2001-11-1' and status <> 'C';
delete from cxpdocm where fecha_posteo >= '2001-11-1';


update cxpfact1 set status = 'R' where fecha_posteo_fact_cxp >= '2001-11-1';
update cxpajuste1 set status = 'R' where fecha_posteo_ajuste_cxp >= '2001-11-1';
update bcocheck1 set status = 'R' where status <> 'A' and fecha_posteo >= '2001-11-1';
update bcotransac1 set status = 'R' where fecha_posteo >= '2001-11-1';
update cglcomprobante1 set estado = 'R' where fecha_comprobante >= '2001-11-1';

commit work;














