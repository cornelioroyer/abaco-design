drop view v_cgl_financiero_cglsldocuenta;
create view v_cgl_financiero_cglsldocuenta as
select cglsldocuenta.compania, gralcompanias.nombre,
cgl_financiero.no_informe, 
gralperiodos.inicio, cgl_financiero.d_fila, cglsldocuenta.cuenta, 
cglsldocuenta.debito, cglsldocuenta.credito
from cgl_financiero, cglsldocuenta, gralperiodos, gralcompanias
where cgl_financiero.cuenta = cglsldocuenta.cuenta
and cglsldocuenta.compania = gralperiodos.compania
and cglsldocuenta.year = gralperiodos.year
and cglsldocuenta.periodo = gralperiodos.periodo
and gralperiodos.aplicacion = 'CGL'
and cglsldocuenta.compania = gralcompanias.compania;

