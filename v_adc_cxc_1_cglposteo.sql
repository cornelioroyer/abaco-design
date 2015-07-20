drop view v_adc_cxc_1_cglposteo;
create view v_adc_cxc_1_cglposteo as
select adc_cxc_1.documento, adc_cxc_1.consecutivo as consecutivo, cglposteo.compania, 
cglposteo.consecutivo as cgl_consecutivo, 
cglposteo.cuenta, cglposteo.debito, cglposteo.credito,
cxcmotivos.desc_motivo_cxc
from rela_adc_cxc_1_cglposteo, cglposteo, cxcmotivos, adc_cxc_1
where rela_adc_cxc_1_cglposteo.cgl_consecutivo = cglposteo.consecutivo
and adc_cxc_1.motivo_cxc = cxcmotivos.motivo_cxc
and adc_cxc_1.compania = rela_adc_cxc_1_cglposteo.compania
and adc_cxc_1.consecutivo = rela_adc_cxc_1_cglposteo.consecutivo
and adc_cxc_1.secuencia = rela_adc_cxc_1_cglposteo.secuencia