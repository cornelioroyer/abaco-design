update factura1
set descto_porcentaje =
(select sum(factura4.monto*rubros_fact_cxc.signo_rubro_fact_cxc) 
from factura4, rubros_fact_cxc
where factura4.rubro_fact_cxc = rubros_fact_cxc.rubro_fact_cxc)
where fecha_factura >= '2002-12-5';

