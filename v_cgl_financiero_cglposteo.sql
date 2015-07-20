drop view v_cgl_financiero_cglposteo;
create view v_cgl_financiero_cglposteo as
select cglposteo.compania, cgl_financiero.no_informe, cglposteo.fecha_comprobante, 
cgl_financiero.d_fila, cglposteo.cuenta, cglposteo.debito, 
cglposteo.credito
from cglposteo, cgl_financiero
where cglposteo.cuenta = cgl_financiero.cuenta;
