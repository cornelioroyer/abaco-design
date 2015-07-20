begin work;
delete from rela_afi_cglposteo;
delete from cglcomprobante1 where aplicacion_origen = 'AFI';
update cglcomprobante1 set estado = 'R';
delete from cglposteo where aplicacion_origen = 'AFI';
update afi_depreciacion set status = 'P' where periodo = 3;
update afi_depreciacion set status = 'R' where periodo = 4;
commit work;












