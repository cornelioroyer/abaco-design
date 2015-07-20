drop view v_cf_ingresos;
create view v_cf_ingresos as
select cf_recibos_1.fecha, cf_recibos_1.referencia, cf_recibos_2.monto1, cf_recibos_2.monto2,
bcoctas.desc_ctabco, cglcuentas.nombre as d_cuenta, bcomotivos.desc_motivo_bco,
cf_bco_1.secuencia, cf_recibos_1.sec_recibo as no_recibo, fac_paises.nombre as d_pais,
trim(cf_recibos_1.observacion) as observacion, clientes.nomb_cliente as cliente,
Anio(cf_recibos_1.fecha) as anio, Mes(cf_recibos_1.fecha) as mes, bcoctas.pais as pais,
cglcuentas.cuenta, cf_bco_1.beneficiario
from cf_bco_1, cf_recibos_1, cf_recibos_2, bcoctas, bcomotivos, cglcuentas, fac_paises, clientes
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
and cf_recibos_1.status = 'R'
and bcoctas.pais = fac_paises.pais
and cf_recibos_1.cliente = clientes.cliente
union
select cf_bco_1.fecha, cf_bco_1.referencia, cf_bco_2.monto1,
cf_bco_2.monto2, bcoctas.desc_ctabco, cglcuentas.nombre, bcomotivos.desc_motivo_bco,
cf_bco_1.secuencia, 0, fac_paises.nombre, trim(cf_bco_1.observacion), null,
Anio(cf_bco_1.fecha), Mes(cf_bco_1.fecha), bcoctas.pais, cglcuentas.cuenta, cf_bco_1.beneficiario
from cf_bco_1, cf_bco_2, bcoctas, bcomotivos, cglcuentas, fac_paises
where cf_bco_1.cod_ctabco = bcoctas.cod_ctabco
and cf_bco_1.cod_ctabco = cf_bco_2.cod_ctabco
and cf_bco_1.motivo_bco = cf_bco_2.motivo_bco
and cf_bco_1.secuencia = cf_bco_2.secuencia
and cf_bco_1.motivo_bco = bcomotivos.motivo_bco
and cf_bco_2.cuenta = cglcuentas.cuenta
and bcomotivos.signo = 1
and cf_bco_1.status = 'R'
and bcoctas.pais = fac_paises.pais
and not exists
(select * from cf_recibos_1
where cf_recibos_1.cod_ctabco = cf_bco_1.cod_ctabco
and cf_recibos_1.motivo_bco = cf_bco_1.motivo_bco
and cf_recibos_1.secuencia = cf_bco_1.secuencia)
union
select cf_bco_1.fecha, cf_bco_1.referencia, cf_bco_1.monto1,
cf_bco_1.monto2, bcoctas.desc_ctabco, cglcuentas.nombre, bcomotivos.desc_motivo_bco,
cf_bco_1.secuencia, 0, fac_paises.nombre, trim(cf_bco_1.observacion), null,
Anio(cf_bco_1.fecha), Mes(cf_bco_1.fecha), bcoctas.pais, cglcuentas.cuenta, cf_bco_1.beneficiario
from cf_bco_1, bcoctas, bcomotivos, cglcuentas, fac_paises, cf_bco_2
where cf_bco_1.secuencia = cf_bco_2.secuencia
and cf_bco_1.motivo_bco = cf_bco_2.motivo_bco
and cf_bco_1.cod_ctabco = cf_bco_2.cod_ctabco
and cf_bco_1.cod_ctabco = bcoctas.cod_ctabco
and cf_bco_1.motivo_bco = bcomotivos.motivo_bco
and bcoctas.cuenta = cglcuentas.cuenta
and cf_bco_1.status = 'R'
and bcoctas.pais = fac_paises.pais

