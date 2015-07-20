delete from cglcomprobante1 where aplicacion_origen not in ('CGL');

delete from rela_bcocheck1_cglposteo;

delete from rela_bcotransac1_cglposteo;

update bcocheck1 set status = 'R';

update bcotransac1 set status = 'R';

update cglcomprobante1 set estado = 'R' where year = 2000
and (periodo = 4 or periodo = 5 or periodo = 6 or periodo = 7);

delete from cglposteo where year = 2000
and (periodo = 4 or periodo = 5 or periodo = 6 or periodo = 7);

delete from cglsldocuenta where year = 2000
and (periodo = 4 or periodo = 5 or periodo = 6 or periodo = 7);

delete from cglsldoaux1 where year = 2000
and (periodo = 4 or periodo = 5 or periodo = 6 or periodo = 7);

delete from cglsldoaux2 where year = 2000
and (periodo = 4 or periodo = 5 or periodo = 6 or periodo = 7);

