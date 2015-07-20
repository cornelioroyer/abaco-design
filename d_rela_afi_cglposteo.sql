
delete from rela_afi_cglposteo
where not exists
(select * from afi_depreciacion
where afi_depreciacion.compania = rela_afi_cglposteo.compania
and afi_depreciacion.codigo = rela_afi_cglposteo.codigo
and afi_depreciacion.aplicacion = rela_afi_cglposteo.aplicacion
and afi_depreciacion.year = rela_afi_cglposteo.year
and afi_depreciacion.periodo = rela_afi_cglposteo.periodo);

