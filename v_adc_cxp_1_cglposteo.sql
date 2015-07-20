drop view v_adc_cxp_1_cglposteo;
create view v_adc_cxp_1_cglposteo as
select adc_cxp_1.documento, adc_cxp_1.consecutivo as consecutivo, cglposteo.compania, 
cglposteo.consecutivo as cgl_consecutivo, 
cglposteo.cuenta, cglposteo.debito, cglposteo.credito,
cxpmotivos.desc_motivo_cxp
from rela_adc_cxp_1_cglposteo, cglposteo, cxpmotivos, adc_cxp_1
where rela_adc_cxp_1_cglposteo.cgl_consecutivo = cglposteo.consecutivo
and adc_cxp_1.motivo_cxp = cxpmotivos.motivo_cxp
and adc_cxp_1.compania = rela_adc_cxp_1_cglposteo.compania
and adc_cxp_1.consecutivo = rela_adc_cxp_1_cglposteo.consecutivo
and adc_cxp_1.secuencia = rela_adc_cxp_1_cglposteo.secuencia;
