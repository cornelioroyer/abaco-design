select compania, numero_oc, fact_proveedor, aplicacion_origen 
from cxpfact1
where aplicacion_origen in ('COM','TAL')
and fecha_posteo_fact_cxp >= '2006-01-01'
and not exists
(select * from eys2
where cxpfact1.compania = eys2.compania
and cxpfact1.proveedor = eys2.proveedor
and cxpfact1.fact_proveedor = eys2.fact_proveedor)
order by numero_oc