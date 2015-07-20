create table tmp2_cxpfact1 as
select * from cxpfact1
where exists
(select * from cxpfact2
where cxpfact2.compania = cxpfact1.compania
and cxpfact2.proveedor = cxpfact1.proveedor
and cxpfact2.fact_proveedor = cxpfact1.fact_proveedor
and cxpfact2.monto  <> 0
and cxpfact2.cuenta is null)
and not exists
(select * from eys2
where eys2.compania = cxpfact1.compania
and eys2.proveedor = cxpfact1.proveedor
and eys2.fact_proveedor = cxpfact1.fact_proveedor);

