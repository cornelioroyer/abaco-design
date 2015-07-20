drop view v_adc_cxp_1;
create view v_adc_cxp_1 as
select gralcompanias.*, adc_cxp_1.consecutivo, cxpmotivos.desc_motivo_cxp,
adc_cxp_1.secuencia, adc_cxp_1.fecha, adc_cxp_1.monto,
trim(adc_cxp_1.observacion) as observacion,
trim(adc_cxp_1.documento) as documento, adc_manifiesto.no_referencia,
proveedores.proveedor, proveedores.nomb_proveedor
from adc_manifiesto, adc_cxp_1, cxpmotivos, gralcompanias, navieras, proveedores
where navieras.proveedor = proveedores.proveedor
and adc_manifiesto.cod_naviera = navieras.cod_naviera
and adc_manifiesto.compania = adc_cxp_1.compania
and adc_manifiesto.consecutivo = adc_cxp_1.consecutivo
and adc_cxp_1.motivo_cxp = cxpmotivos.motivo_cxp
and adc_manifiesto.compania = gralcompanias.compania;