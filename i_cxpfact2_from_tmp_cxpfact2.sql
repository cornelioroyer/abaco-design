insert into cxpfact2 select * from tmp_cxpfact2
where not exists
(select * from cxpfact2 a
where a.compania = tmp_cxpfact2.compania
and a.proveedor = tmp_cxpfact2.proveedor
and a.fact_proveedor = tmp_cxpfact2.fact_proveedor
and a.rubro_fact_cxp = tmp_cxpfact2.rubro_fact_cxp
and a.linea = tmp_cxpfact2.linea)
