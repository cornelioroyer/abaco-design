drop view v_cxpfact1_cglposteo;
create view v_cxpfact1_cglposteo as
select gralcompanias.compania, gralcompanias.nombre, proveedores.proveedor,
proveedores.nomb_proveedor, cxpfact1.fecha_posteo_fact_cxp, cxpfact1.fact_proveedor, 
trim(cxpfact1.obs_fact_cxp) as observacion,
cglposteo.cuenta, cglcuentas.nombre as d_cuenta,
cglposteoaux1.auxiliar, cglposteo.debito, cglposteo.credito
from cglposteoaux1 RIGHT OUTER JOIN cglposteo ON cglposteoaux1.consecutivo = cglposteo.consecutivo,
gralcompanias, cxpfact1, rela_cxpfact1_cglposteo, proveedores, cglcuentas
where gralcompanias.compania = cxpfact1.compania
and cxpfact1.compania = rela_cxpfact1_cglposteo.compania
and cxpfact1.proveedor = rela_cxpfact1_cglposteo.proveedor
and cxpfact1.fact_proveedor = rela_cxpfact1_cglposteo.fact_proveedor
and rela_cxpfact1_cglposteo.consecutivo = cglposteo.consecutivo
and proveedores.proveedor = cxpfact1.proveedor
and cglcuentas.cuenta = cglposteo.cuenta;


