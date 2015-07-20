select f_cxpfact1_cglposteo(compania, proveedor, fact_proveedor) from cxpfact1
where fecha_posteo_fact_cxp between '2005-12-01' and '2006-12-02'
and not exists
(select * from rela_cxpfact1_cglposteo
where rela_cxpfact1_cglposteo.compania = cxpfact1.compania
and rela_cxpfact1_cglposteo.proveedor = cxpfact1.proveedor
and rela_cxpfact1_cglposteo.fact_proveedor = cxpfact1.fact_proveedor)