drop view v_cxp_facturas;

create view v_cxp_facturas as
select cxpfact1.proveedor, cxpfact1.compania, cxpfact1.fact_proveedor, cxpfact1.motivo_cxp, 
cxpfact1.aplicacion_origen, cxpfact1.fecha_posteo_fact_cxp as fecha_posteo, 
cxpfact1.vence_fact_cxp, sum(cxpfact2.monto*rubros_fact_cxp.signo_rubro_fact_cxp) as monto, 
cxpfact1.usuario, cxpfact1.obs_fact_cxp
from cxpfact1, cxpfact2, rubros_fact_cxp, cxpmotivos, proveedores, cglcuentas
where cxpfact1.proveedor = cxpfact2.proveedor and cxpfact1.fact_proveedor = cxpfact2.fact_proveedor 
and cxpfact1.compania = cxpfact2.compania and cxpfact2.rubro_fact_cxp = rubros_fact_cxp.rubro_fact_cxp 
and cxpfact1.motivo_cxp = cxpmotivos.motivo_cxp and cxpfact1.proveedor = proveedores.proveedor 
and proveedores.cuenta = cglcuentas.cuenta and cglcuentas.naturaleza = -1 and cxpmotivos.factura = 'S'
group by cxpfact1.proveedor, cxpfact1.compania, cxpfact1.fact_proveedor, cxpfact1.motivo_cxp, 
cxpfact1.aplicacion_origen, fecha_posteo, cxpfact1.vence_fact_cxp, cxpfact1.usuario, cxpfact1.obs_fact_cxp;
