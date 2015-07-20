delete from cglposteo where aplicacion_origen in ('CXC', 'CGL', 'FAC') 
and fecha_comprobante >= '2001-8-1';

delete from cglcomprobante1 where aplicacion_origen in ('CXC', 'FAC') 
and fecha_comprobante >= '2001-8-1';

delete from cxcdocm where aplicacion_origen in ('CXC', 'FAC')
and fecha_posteo >= '2001-8-1';

delete from cglsldocuenta where year = 2001 and periodo >= 8;
delete from cglsldoaux1 where year = 2001 and periodo >= 8;
delete from cglsldoaux2 where year = 2001 and periodo >= 8;

delete from eys1 where aplicacion_origen = 'FAC' and fecha >= '2001-8-1';

update cxctrx1 set status = 'R' where fecha_posteo_ajuste_cxc >= '2001-8-1';
update factura1 set status = 'C' where fecha_factura >= '2001-8-1' and status <> 'A';

update cglcomprobante1 set estado = 'R' where 
fecha_comprobante >= '2001-8-1';





