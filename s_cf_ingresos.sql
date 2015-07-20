drop view v_cf_ingresos;
create view v_cf_ingresos as
select cf_bco_1.fecha, cf_bco_1.referencia, cf_bco_1.monto1 as deposito1, cf_bco_1.monto2 as deposito2, 
cf_recibos_2.monto1, cf_recibos_2.monto2,
bcoctas.desc_ctabco, cglcuentas.nombre
from cf_bco_1, cf_recibos_1, cf_recibos_2, bcoctas, bcomotivos, cglcuentas
where cf_recibos_2.cuenta = cglcuentas.cuenta
and cf_bco_1.motivo_bco = bcomotivos.motivo_bco
and bcoctas.cod_ctabco = cf_bco_1.cod_ctabco
and cf_bco_1.secuencia = cf_recibos_1.secuencia
and cf_bco_1.motivo_bco = cf_recibos_1.motivo_bco
and cf_bco_1.secuencia = cf_recibos_1.secuencia
and cf_recibos_1.secuencia = cf_recibos_2.secuencia
and cf_recibos_1.motivo_bco = cf_recibos_2.motivo_bco
and cf_recibos_1.cod_ctabco = cf_recibos_2.cod_ctabco
and cf_recibos_1.sec_recibo = cf_recibos_2.sec_recibo