drop view v_adc_cxc_1;
create view v_adc_cxc_1 as
select gralcompanias.*, cxcmotivos.desc_motivo_cxc,
adc_cxc_1.secuencia, adc_cxc_1.fecha, adc_cxc_1.monto,
clientes.nomb_cliente, clientes.cliente,
trim(adc_cxc_1.observacion)
from adc_manifiesto, adc_cxc_1, cxcmotivos, gralcompanias, 
fact_referencias, clientes
where adc_manifiesto.compania = adc_cxc_1.compania
and adc_manifiesto.consecutivo = adc_cxc_1.consecutivo
and adc_cxc_1.motivo_cxc = cxcmotivos.motivo_cxc
and adc_manifiesto.compania = gralcompanias.compania
and adc_manifiesto.referencia = fact_referencias.referencia
and fact_referencias.tipo = 'I'
and adc_manifiesto.from_agent = clientes.cliente
union
select gralcompanias.*, cxcmotivos.desc_motivo_cxc,
adc_cxc_1.secuencia, adc_cxc_1.fecha, adc_cxc_1.monto,
clientes.nomb_cliente, clientes.cliente,
trim(adc_cxc_1.observacion)
from adc_manifiesto, adc_cxc_1, cxcmotivos, gralcompanias, 
fact_referencias, clientes
where adc_manifiesto.compania = adc_cxc_1.compania
and adc_manifiesto.consecutivo = adc_cxc_1.consecutivo
and adc_cxc_1.motivo_cxc = cxcmotivos.motivo_cxc
and adc_manifiesto.compania = gralcompanias.compania
and adc_manifiesto.referencia = fact_referencias.referencia
and fact_referencias.tipo <> 'I'
and adc_manifiesto.to_agent = clientes.cliente

