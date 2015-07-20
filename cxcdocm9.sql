select * from cxcdocm
where documento = docmto_aplicar
and motivo_cxc = motivo_ref
and documento = '470835'
and exists
(select (sum(factura4.monto*rubros_fact_cxc.signo_rubro_fact_cxc) - cxcdocm.monto) as monto 
from factura4, rubros_fact_cxc
where factura4.rubro_fact_cxc = rubros_fact_cxc.rubro_fact_cxc and monto <> 0
and factura4.almacen = cxcdocm.almacen
and factura4.tipo = cxcdocm.motivo_cxc
and cast(factura4.num_documento as char(10)) = cxcdocm.documento)
