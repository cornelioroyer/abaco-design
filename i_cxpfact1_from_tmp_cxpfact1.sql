insert into cxpfact1
select * from tmp_cxpfact1
where not exists
(select * from cxpfact1 a
where a.compania = tmp_cxpfact1.compania
and a.proveedor = tmp_cxpfact1.proveedor
and a.fact_proveedor = tmp_cxpfact1.fact_proveedor);

