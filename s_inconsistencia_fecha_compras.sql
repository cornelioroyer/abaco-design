select cxpfact1.fecha_posteo_fact_cxp as fecha_posteo_cxp, eys1.fecha as fecha_inv, 
eys2.compania, eys2.fact_proveedor
from eys1, eys2, cxpfact1
where eys1.almacen = eys2.almacen
and eys1.no_transaccion = eys2.no_transaccion
and eys2.proveedor = cxpfact1.proveedor
and eys2.compania = cxpfact1.compania
and eys2.fact_proveedor = cxpfact1.fact_proveedor
and eys1.fecha <> cxpfact1.fecha_posteo_fact_cxp
and eys1.fecha >= '2009-01-01'
order by 1;

/*
and cxpfact1.fecha_posteo_fact_cxp <= '2009-07-31'
*/