drop view v_cxp_declaracion_pat;
create view v_cxp_declaracion_pat as
select '2' as tipo_de_persona,proveedores.id_proveedor,proveedores.dv_proveedor, proveedores.nomb_proveedor,
cxpfact1.fact_proveedor, cxpfact1.fecha_posteo_fact_cxp, '1' as concepto,'1' as local_importacion,0 as monto, (cglposteo.debito-cglposteo.credito) as itbms
from cxpfact1, rela_cxpfact1_cglposteo, cglposteo, proveedores, 
gralcompanias, cxpmotivos
where cxpfact1.proveedor = rela_cxpfact1_cglposteo.proveedor
and cxpfact1.compania = rela_cxpfact1_cglposteo.compania
and cxpfact1.fact_proveedor = rela_cxpfact1_cglposteo.fact_proveedor
and rela_cxpfact1_cglposteo.consecutivo = cglposteo.consecutivo
and cxpfact1.proveedor = proveedores.proveedor
and cxpfact1.motivo_cxp = cxpmotivos.motivo_cxp
and cglposteo.cuenta not in (select cuenta from proveedores group by 1)
and cglposteo.cuenta in (select cuenta from gral_impuestos)
union
select '2',proveedores.id_proveedor,proveedores.dv_proveedor, proveedores.nomb_proveedor,
cxpfact1.fact_proveedor, cxpfact1.fecha_posteo_fact_cxp, '1','1', (cglposteo.debito-cglposteo.credito), 0
from cxpfact1, rela_cxpfact1_cglposteo, cglposteo, proveedores, 
gralcompanias, cxpmotivos
where cxpfact1.proveedor = rela_cxpfact1_cglposteo.proveedor
and cxpfact1.compania = rela_cxpfact1_cglposteo.compania
and cxpfact1.fact_proveedor = rela_cxpfact1_cglposteo.fact_proveedor
and rela_cxpfact1_cglposteo.consecutivo = cglposteo.consecutivo
and cxpfact1.proveedor = proveedores.proveedor
and cxpfact1.motivo_cxp = cxpmotivos.motivo_cxp
and cglposteo.cuenta not in (select cuenta from proveedores group by 1)
and cglposteo.cuenta not in (select cuenta from gral_impuestos)
