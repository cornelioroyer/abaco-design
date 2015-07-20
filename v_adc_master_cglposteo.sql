drop view v_adc_master_cglposteo;
create view v_adc_master_cglposteo as
select adc_master.*, cglposteo.consecutivo as cgl_consecutivo,
cglposteo.cuenta, cglposteo.debito, cglposteo.credito
from adc_master, rela_adc_master_cglposteo, cglposteo
where adc_master.compania = rela_adc_master_cglposteo.compania
and adc_master.consecutivo = rela_adc_master_cglposteo.consecutivo
and adc_master.linea_master = rela_adc_master_cglposteo.linea_master
and rela_adc_master_cglposteo.cgl_consecutivo = cglposteo.consecutivo