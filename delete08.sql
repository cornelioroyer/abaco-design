delete from cglcomprobante1 where aplicacion_origen not in ('CGL');

delete from rela_bcocheck1_cglposteo;

delete from rela_bcotransac1_cglposteo;

update bcocheck1 set status = 'R';

update bcotransac1 set status = 'R';

update cglcomprobante1 set estado = 'R' ;

delete from cglsldocuenta;

delete from cglsldoaux1;

delete from cglposteo;

delete from cglsldoaux2;
