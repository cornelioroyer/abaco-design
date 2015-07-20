select factura1.fecha_factura, factura1.almacen, factura1.tipo, factura1.num_documento, 
gral_forma_de_pago.dias, factura1.cliente, factura1.documento, 
-sum(factura4.monto*rubros_fact_cxc.signo_rubro_fact_cxc) as monto
from factura1, factura4, gral_forma_de_pago, rubros_fact_cxc, factmotivos
where factura1.almacen = factura4.almacen 
and factura1.tipo = factura4.tipo 
and factura1.num_documento = factura4.num_documento 
and factura1.forma_pago = gral_forma_de_pago.forma_pago
and factura1.tipo = factmotivos.tipo
and factura4.rubro_fact_cxc = rubros_fact_cxc.rubro_fact_cxc 
and factura1.status > 'A' and factmotivos.donacion = 'N' 
and factmotivos.cotizacion = 'N'
group by factura1.fecha_factura, factura1.almacen, factura1.tipo, factura1.num_documento, 
gral_forma_de_pago.dias, factura1.cliente, factura1.documento;

