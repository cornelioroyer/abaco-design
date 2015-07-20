

delete from rela_cxpajuste1_cglposteo
where not exists
(select * from cglposteo
where cglposteo.consecutivo = rela_cxpajuste1_cglposteo.consecutivo);

