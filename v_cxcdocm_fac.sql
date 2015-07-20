drop view v_cxcdocm_fac;


create view v_cxcdocm_fac as
select factura1.almacen as almacen, factura1.cliente as cliente, 
trim(to_char(factura1.num_documento, '9999999999')) as documento,
trim(to_char(factura1.num_documento, '9999999999')) as docmto_aplicar,
factura1.tipo as motivo_cxc, 
trim(to_char(factura1.num_documento, '9999999999')) as docmto_ref,
factura1.tipo as motivo_ref, 
factura1.fecha_factura as fecha_posteo, 
factura1.fecha_factura as fecha_docmto,
factura1.fecha_vencimiento as fecha_vmto, trim(factura1.observacion) as obs_docmto,
factura1.no_referencia as referencia, 'FAC' as aplicacion_origen, 
-sum(factura4.monto * rubros_fact_cxc.signo_rubro_fact_cxc * factmotivos.signo) as monto 
from factura1, factmotivos, factura4, rubros_fact_cxc, gral_forma_de_pago, clientes, cglcuentas
where factura1.tipo = factmotivos.tipo and factmotivos.factura = 'S' 
and factura1.cliente = clientes.cliente
and clientes.cuenta = cglcuentas.cuenta
and cglcuentas.naturaleza = 1
and cglcuentas.tipo_cuenta = 'B'
and factura1.forma_pago = gral_forma_de_pago.forma_pago
and gral_forma_de_pago.dias > 0
and factura1.status <> 'A'
and factura1.almacen = factura4.almacen 
and factura1.tipo = factura4.tipo
and factura1.num_documento = factura4.num_documento
and factura4.rubro_fact_cxc = rubros_fact_cxc.rubro_fact_cxc
and factura1.tipo <> 'DA'
group by factura1.almacen, factura1.cliente, factura1.num_documento,
factura1.tipo, factura1.fecha_factura, factura1.fecha_vencimiento, factura1.observacion,
factura1.no_referencia
union
select factura1.almacen as almacen, factura1.cliente as cliente, 
trim(to_char(factura1.num_documento, '9999999999')) as documento,
trim(to_char(factura1.num_factura, '9999999999')) as docmto_aplicar,
factura1.tipo as motivo_cxc, 
trim(to_char(factura1.num_factura, '9999999999')) as docmto_ref,
(select tipo from factmotivos where factura = 'S') as motivo_ref, 
factura1.fecha_factura as fecha_posteo, 
factura1.fecha_factura as fecha_docmto,
factura1.fecha_vencimiento as fecha_vmto, trim(factura1.observacion) as obs_docmto,
factura1.no_referencia as referencia, 'FAC' as aplicacion_origen, 
sum(factura4.monto * rubros_fact_cxc.signo_rubro_fact_cxc * factmotivos.signo) as monto 
from factura1, factmotivos, factura4, rubros_fact_cxc, gral_forma_de_pago, clientes, cglcuentas
where factura1.tipo = factmotivos.tipo 
and factura1.cliente = clientes.cliente
and clientes.cuenta = cglcuentas.cuenta
and cglcuentas.naturaleza = 1
and cglcuentas.tipo_cuenta = 'B'
and (factmotivos.devolucion = 'S' or factmotivos.nota_credito = 'S')
and factura1.forma_pago = gral_forma_de_pago.forma_pago
and gral_forma_de_pago.dias > 0
and factura1.status <> 'A'
and factura1.almacen = factura4.almacen 
and factura1.tipo = factura4.tipo
and factura1.num_documento = factura4.num_documento
and factura4.rubro_fact_cxc = rubros_fact_cxc.rubro_fact_cxc
and factura1.num_factura <> 0
and factura1.tipo <> 'DA'
group by factura1.almacen, factura1.cliente, factura1.num_documento,
factura1.tipo, factura1.fecha_factura, factura1.fecha_vencimiento, factura1.observacion,
factura1.no_referencia, factura1.num_factura
union
select factura1.almacen as almacen, factura1.cliente as cliente, 
trim(to_char(factura1.num_documento, '9999999999')) as documento,
trim(to_char(factura1.num_documento, '9999999999')) as docmto_aplicar,
factura1.tipo as motivo_cxc, 
trim(to_char(factura1.num_documento, '9999999999')) as docmto_ref,
factura1.tipo as motivo_ref, 
factura1.fecha_factura as fecha_posteo, 
factura1.fecha_factura as fecha_docmto,
factura1.fecha_vencimiento as fecha_vmto, trim(factura1.observacion) as obs_docmto,
factura1.no_referencia as referencia, 'FAC' as aplicacion_origen, 
sum(factura4.monto * rubros_fact_cxc.signo_rubro_fact_cxc * factmotivos.signo) as monto 
from factura1, factmotivos, factura4, rubros_fact_cxc, gral_forma_de_pago,
clientes, cglcuentas
where factura1.tipo = factmotivos.tipo and (factmotivos.devolucion = 'S' or factmotivos.nota_credito = 'S')
and factura1.forma_pago = gral_forma_de_pago.forma_pago
and factura1.cliente = clientes.cliente
and clientes.cuenta = cglcuentas.cuenta
and cglcuentas.naturaleza = 1
and cglcuentas.tipo_cuenta = 'B'
and gral_forma_de_pago.dias > 0
and factura1.status <> 'A'
and factura1.almacen = factura4.almacen 
and factura1.tipo = factura4.tipo
and factura1.num_documento = factura4.num_documento
and factura4.rubro_fact_cxc = rubros_fact_cxc.rubro_fact_cxc
and factura1.num_factura = 0
and factura1.tipo <> 'DA'
group by factura1.almacen, factura1.cliente, factura1.num_documento,
factura1.tipo, factura1.fecha_factura, factura1.fecha_vencimiento, factura1.observacion,
factura1.no_referencia, factura1.num_factura;

