update cxpfact2
set cuenta = '6400600'
from cxpfact1
where cxpfact1.compania = cxpfact2.compania
and cxpfact1.proveedor = cxpfact2.proveedor
and cxpfact1.fact_proveedor = cxpfact2.fact_proveedor
and cxpfact2.cuenta = '2200110'
and cxpfact1.fecha_posteo_fact_cxp >= '2011-07-01'
and cxpfact1.fact_proveedor in ('94758')
