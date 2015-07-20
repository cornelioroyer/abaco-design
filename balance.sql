select cglsldocuenta.compania, cgl_financiero.no_informe,
cglsldocuenta.year, cglsldocuenta.periodo, 
cgl_financiero.d_fila,
(cglsldocuenta.debito-cglsldocuenta.credito) as corriente,
(cglsldocuenta.balance_inicio+cglsldocuenta.debito-cglsldocuenta.credito) as acumulado
from cglcuentas, cglsldocuenta, cgl_financiero,
cglniveles
where cglcuentas.cuenta = cglsldocuenta.cuenta
and cglcuentas.cuenta = cgl_financiero.cuenta
and cglcuentas.nivel = cglniveles.nivel
and cglniveles.recibe = 'S'
order by cglsldocuenta.compania, cgl_financiero.no_informe,
cglsldocuenta.year, cglsldocuenta.periodo, cgl_financiero.d_fila
