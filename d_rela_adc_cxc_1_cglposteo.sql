
delete from rela_adc_cxc_1_cglposteo
using cglposteo, adc_cxc_1
where rela_adc_cxc_1_cglposteo.compania = adc_cxc_1.compania
and rela_adc_cxc_1_cglposteo.consecutivo = adc_cxc_1.consecutivo
and rela_adc_cxc_1_cglposteo.secuencia = adc_cxc_1.secuencia
and rela_adc_cxc_1_cglposteo.cgl_consecutivo = cglposteo.consecutivo
and adc_cxc_1.compania = '03'
and adc_cxc_1.fecha >= '2014-08-01'
and adc_cxc_1.fecha <> cglposteo.fecha_comprobante;


