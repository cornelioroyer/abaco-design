begin work;
delete from cglposteo where fecha_comprobante >= '2002-1-1';
delete from cglcomprobante1 where aplicacion_origen <> 'CGL' and fecha_comprobante >= '2002-1-1';
delete from cxpbalance where year >= 2002 and periodo >= 1;
delete from cxcbalance where year >= 2002 and periodo >= 1;
delete from cglsldocuenta where year >= 2002 and periodo >= 1;
delete from cglsldoaux1 where year >= 2002 and periodo >= 1;
delete from cglsldoaux2 where year >= 2002 and periodo >= 1;
delete from afi_depreciacion where year >= 2002 and periodo >= 1;
delete from invbalance where year >= 2002 and periodo >= 1;
delete from cajas_balance where year >= 2002 and periodo >= 1;
delete from cxc_estado_de_cuenta;
delete from bcocircula where fecha_posteo >= '2002-1-1' and status <> 'C';
delete from cxpdocm where fecha_posteo >= '2002-1-1';
delete from cxcdocm where fecha_posteo >= '2002-1-1';
delete from eys1 where fecha >= '2002-1-1' and aplicacion_origen <> 'INV';


update cxpfact1 set status = 'R' where fecha_posteo_fact_cxp >= '2002-1-1';
update cxpajuste1 set status = 'R' where fecha_posteo_ajuste_cxp >= '2002-1-1';
update bcocheck1 set status = 'R' where status <> 'A' and fecha_posteo >= '2002-1-1';
update bcotransac1 set status = 'R' where fecha_posteo >= '2002-1-1';
update eys1 set status = 'R' where fecha >= '2002-1-1';
update cxcfact1 set status = 'R' where fecha_posteo_fact >= '2002-1-1';
update cxctrx1 set status = 'R' where fecha_posteo_ajuste_cxc >= '2002-1-1';
update caja_trx1 set status = 'R' where fecha_posteo >= '2002-1-1';
update factura1 set status = 'C' where status = 'P' and fecha_factura >= '2002-1-1';
update cglcomprobante1 set estado = 'R' where fecha_comprobante >= '2002-1-1';

commit work;














