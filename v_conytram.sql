drop view v_cheques_conytram;
create view v_cheques_conytram as
select cglcuentas.nombre as nombre_cuenta, cglcuentas.cuenta, cglauxiliares.nombre as nombre_auxiliar, 
cglauxiliares.auxiliar,
cglposteo.fecha_comprobante, cglposteo.year, cglposteo.periodo, 
Trim(bcocheck1.paguese_a) as beneficiario, (cglposteo.debito-cglposteo.credito) as monto
from cglcuentas, cglauxiliares, cglposteo, cglposteoaux1, rela_bcocheck1_cglposteo, bcocheck1
where cglcuentas.cuenta = cglposteo.cuenta
and cglposteo.consecutivo = cglposteoaux1.consecutivo
and cglposteoaux1.auxiliar = cglauxiliares.auxiliar
and rela_bcocheck1_cglposteo.consecutivo = cglposteo.consecutivo
and rela_bcocheck1_cglposteo.cod_ctabco = bcocheck1.cod_ctabco
and rela_bcocheck1_cglposteo.motivo_bco = bcocheck1.motivo_bco
and rela_bcocheck1_cglposteo.no_cheque = bcocheck1.no_cheque
and cglposteo.aplicacion_origen in ('BCO','CAJ')
and cglposteo.compania = '01'
and cglposteo.fecha_comprobante >= '2007-01-01'
union
select cglcuentas.nombre, cglcuentas.cuenta, null, null,
cglposteo.fecha_comprobante, cglposteo.year, cglposteo.periodo, 
Trim(bcocheck1.paguese_a), (cglposteo.debito-cglposteo.credito) as monto
from cglcuentas, cglposteo, rela_bcocheck1_cglposteo, bcocheck1
where cglcuentas.cuenta = cglposteo.cuenta
and cglcuentas.auxiliar_1 = 'N'
and rela_bcocheck1_cglposteo.consecutivo = cglposteo.consecutivo
and rela_bcocheck1_cglposteo.cod_ctabco = bcocheck1.cod_ctabco
and rela_bcocheck1_cglposteo.motivo_bco = bcocheck1.motivo_bco
and rela_bcocheck1_cglposteo.no_cheque = bcocheck1.no_cheque
and cglposteo.aplicacion_origen in ('BCO','CAJ')
and cglposteo.compania = '01'
and cglposteo.fecha_comprobante >= '2007-01-01'