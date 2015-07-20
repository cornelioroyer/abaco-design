

delete from rela_bcotransac1_cglposteo
where not exists
(select * from cglposteo
where cglposteo.consecutivo = rela_bcotransac1_cglposteo.consecutivo);

