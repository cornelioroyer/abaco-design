drop view v_verificador_cglposteo cascade;

create view v_verificador_cglposteo as 
select cglposteo.fecha_comprobante as fecha,
Anio(cglposteo.fecha_comprobante) as anio,
Mes(cglposteo.fecha_comprobante) as mes, 
cglposteo.cuenta,
cgl_financiero.d_fila, 
sum(cglposteo.debito-cglposteo.credito) as monto
from cglposteo, cgl_financiero
where cglposteo.cuenta = cgl_financiero.cuenta
and cglposteo.compania = '03'
and cglposteo.fecha_comprobante >= '2013-03-01'
and cgl_financiero.no_informe = 14
and cglposteo.consecutivo not in 
(select cgl_consecutivo from v_adc_verificador_contable)
group by 1, 2, 3, 4, 5;


