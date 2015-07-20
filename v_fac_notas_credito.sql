drop view fac_notas_credito;

/*==============================================================*/
/* View: fac_notas_credito                                      */
/*==============================================================*/
create view fac_notas_credito as
select 'FAC' as aplicacion, factura1.almacen, factura1.tipo, factura1.documento, 
trim(cast(factura1.num_factura as char(25))) as docmto_aplicar, 
factura1.cliente, factura1.fecha_factura, 
sum(factura4.monto*rubros_fact_cxc.signo_rubro_fact_cxc*factmotivos.signo) as monto
from factura1, factmotivos, factura4, rubros_fact_cxc, gral_forma_de_pago
where factura1.forma_pago = gral_forma_de_pago.forma_pago and gral_forma_de_pago.dias > 0 
and factura1.tipo = factmotivos.tipo and ( factmotivos.nota_credito = 'S' or factmotivos.devolucion = 'S' ) 
and factura1.status > 'A' and factura1.almacen = factura4.almacen and factura1.tipo = factura4.tipo 
and factura1.num_documento = factura4.num_documento 
and factura4.rubro_fact_cxc = rubros_fact_cxc.rubro_fact_cxc
group by factura1.almacen, factura1.tipo, factura1.documento, factura1.cliente, factura1.fecha_factura, factura1.num_factura;
