

delete from rela_adc_cxp_1_cglposteo
using adc_cxp_1, cglposteo
where rela_adc_cxp_1_cglposteo.compania = adc_cxp_1.compania
and rela_adc_cxp_1_cglposteo.consecutivo = adc_cxp_1.consecutivo
and rela_adc_cxp_1_cglposteo.secuencia = adc_cxp_1.secuencia
and rela_adc_cxp_1_cglposteo.cgl_consecutivo = cglposteo.consecutivo
and adc_cxp_1.fecha <> cglposteo.fecha_comprobante
and adc_cxp_1.compania = '03'
and adc_cxp_1.fecha >= '2014-10-01'
