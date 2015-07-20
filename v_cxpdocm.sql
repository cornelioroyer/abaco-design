drop view v_cxpdocm;
create view v_cxpdocm as
select cxpfact1.compania, cxpfact1.proveedor, cxpfact1.fact_proveedor as documento, 
cxpfact1.fact_proveedor as docmto_aplicar, cxpfact1.motivo_cxp, 
cxpfact1.motivo_cxp as motivo_cxp_ref,
cxpfact1.aplicacion_origen, cxpfact1.fecha_posteo_fact_cxp as fecha_posteo, 
cxpfact1.vence_fact_cxp as fecha_vencimiento, sum(cxpfact2.monto*rubros_fact_cxp.signo_rubro_fact_cxp) as monto, 
cxpfact1.usuario, cxpfact1.obs_fact_cxp
from cxpfact1, cxpfact2, rubros_fact_cxp, cxpmotivos, proveedores, cglcuentas
where cxpfact1.proveedor = cxpfact2.proveedor and cxpfact1.fact_proveedor = cxpfact2.fact_proveedor 
and cxpfact1.compania = cxpfact2.compania and cxpfact2.rubro_fact_cxp = rubros_fact_cxp.rubro_fact_cxp 
and cxpfact1.motivo_cxp = cxpmotivos.motivo_cxp and cxpfact1.proveedor = proveedores.proveedor 
and proveedores.cuenta = cglcuentas.cuenta and cglcuentas.naturaleza = -1 and cxpmotivos.factura = 'S'
group by cxpfact1.proveedor, cxpfact1.compania, cxpfact1.fact_proveedor, cxpfact1.motivo_cxp, 
cxpfact1.aplicacion_origen, fecha_posteo, cxpfact1.vence_fact_cxp, cxpfact1.usuario, cxpfact1.obs_fact_cxp
union
select bcoctas.compania, bcocheck1.proveedor, trim(to_char(bcocheck1.no_cheque, '9999999999')),
bcocheck3.aplicar_a, bcomotivos.motivo_cxp, bcocheck3.motivo_cxp, 'BCO',
bcocheck1.fecha_posteo, bcocheck1.fecha_posteo, bcocheck3.monto, bcocheck1.usuario, 
trim(bcocheck1.en_concepto_de)
from bcocheck1, bcocheck3, bcoctas, bcomotivos, cxpdocm
where bcocheck1.cod_ctabco = bcocheck3.cod_ctabco 
and bcocheck1.no_cheque = bcocheck3.no_cheque 
and bcocheck1.motivo_bco = bcocheck3.motivo_bco 
and bcocheck1.cod_ctabco = bcoctas.cod_ctabco 
and bcocheck1.motivo_bco = bcomotivos.motivo_bco and bcocheck1.status <> 'A' 
and cxpdocm.compania = bcoctas.compania and cxpdocm.proveedor = bcocheck1.proveedor 
and cxpdocm.documento = bcocheck3.aplicar_a and cxpdocm.docmto_aplicar = bcocheck3.aplicar_a 
and cxpdocm.motivo_cxp = bcocheck3.motivo_cxp and bcomotivos.aplica_cheques = 'S' 
and bcocheck1.proveedor is not null and bcocheck3.monto <> 0
and bcomotivos.motivo_cxp is not null
union
select bcoctas.compania, bcotransac1.proveedor, bcotransac1.no_docmto,
bcotransac3.aplicar_a, bcomotivos.motivo_cxp, bcotransac3.motivo_cxp, 'BCO',
bcotransac1.fecha_posteo, bcotransac1.fecha_posteo, bcotransac3.monto,
bcotransac1.usuario, trim(bcotransac1.obs_transac_bco)
from bcotransac1, bcotransac3, bcoctas, cxpdocm, bcomotivos
where bcotransac1.cod_ctabco = bcotransac3.cod_ctabco
and bcotransac1.sec_transacc = bcotransac3.sec_transacc
and bcotransac1.cod_ctabco = bcoctas.cod_ctabco
and cxpdocm.compania = bcoctas.compania
and cxpdocm.proveedor = bcotransac1.proveedor
and cxpdocm.documento = bcotransac3.aplicar_a and cxpdocm.docmto_aplicar = bcotransac3.aplicar_a
and cxpdocm.motivo_cxp = bcotransac3.motivo_cxp 
and bcotransac1.proveedor is not null
and bcotransac1.motivo_bco = bcomotivos.motivo_bco
and bcomotivos.motivo_cxp is not null
union
select cxpajuste1.compania, cxpajuste1.proveedor, cxpajuste1.docm_ajuste_cxp, 
cxpajuste1.docm_ajuste_cxp, cxpajuste1.motivo_cxp, cxpajuste1.motivo_cxp, 'CXP',
cxpajuste1.fecha_posteo_ajuste_cxp, cxpajuste1.fecha_posteo_ajuste_cxp, 
sum(cxpajuste3.monto), current_user, trim(cxpajuste1.obs_ajuste_cxp)
from cxpajuste1, cxpajuste3
where cxpajuste1.compania = cxpajuste3.compania and cxpajuste1.sec_ajuste_cxp = cxpajuste3.sec_ajuste_cxp 
and not exists 
(select * from cxpajuste2 
where cxpajuste2.compania = cxpajuste1.compania 
and cxpajuste2.sec_ajuste_cxp = cxpajuste1.sec_ajuste_cxp
and cxpajuste2.monto <> 0)
group by cxpajuste1.compania, cxpajuste1.proveedor, cxpajuste1.docm_ajuste_cxp,
cxpajuste1.motivo_cxp, cxpajuste1.fecha_posteo_ajuste_cxp,
cxpajuste1.obs_ajuste_cxp
union
select cxpajuste1.compania, cxpajuste1.proveedor, cxpajuste1.docm_ajuste_cxp,
cxpajuste2.aplicar_a, cxpajuste1.motivo_cxp, 
cxpajuste2.motivo_cxp, 'CXP', cxpajuste1.fecha_posteo_ajuste_cxp, 
cxpajuste1.fecha_posteo_ajuste_cxp, sum(cxpajuste2.monto), 
current_user, trim(cxpajuste1.obs_ajuste_cxp)
from cxpajuste1, cxpajuste2, cxpdocm
where cxpajuste1.compania = cxpajuste2.compania 
and cxpajuste1.sec_ajuste_cxp = cxpajuste2.sec_ajuste_cxp 
and cxpajuste1.compania = cxpdocm.compania 
and cxpajuste1.proveedor = cxpdocm.proveedor 
and cxpajuste2.aplicar_a = cxpdocm.documento 
and cxpajuste2.aplicar_a = cxpdocm.docmto_aplicar 
and cxpajuste2.motivo_cxp = cxpdocm.motivo_cxp
and cxpajuste2.monto <> 0
group by cxpajuste1.compania, cxpajuste1.proveedor, cxpajuste1.docm_ajuste_cxp,
cxpajuste2.aplicar_a, cxpajuste1.motivo_cxp, 
cxpajuste2.motivo_cxp, cxpajuste1.fecha_posteo_ajuste_cxp, trim(cxpajuste1.obs_ajuste_cxp)
union
select compania, proveedor, factura, factura, motivo_cxp, motivo_cxp, 'CXP',
fecha, fecha, sum(saldo), current_user, null from cxp_saldos_iniciales
group by compania, proveedor, factura, motivo_cxp, fecha
union
select adc_manifiesto.compania, navieras.proveedor, trim(adc_master.container),
trim(adc_master.container), 
(select motivo_cxp from cxpmotivos where factura = 'S'), 
(select motivo_cxp from cxpmotivos where factura = 'S'), 
'CXP',
adc_manifiesto.fecha, adc_manifiesto.fecha, 
case when cargo_prepago = 'S' then sum(gtos_destino) else sum(cargo + gtos_destino) end,
current_user, trim(adc_master.no_bill) || ' / ' || trim(adc_manifiesto.no_referencia)
from navieras, adc_manifiesto, adc_master
where navieras.cod_naviera = adc_manifiesto.cod_naviera
and adc_manifiesto.compania = adc_master.compania
and adc_manifiesto.consecutivo = adc_master.consecutivo
and (gtos_destino <> 0 or cargo <> 0)
group by adc_manifiesto.compania, navieras.proveedor, adc_master.container,
adc_manifiesto.fecha, cargo_prepago;