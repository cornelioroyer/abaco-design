drop rule r_cxcdocm_fac;
create rule r_cxcdocm_fac as on delete to abaco_lock
do
update factura1
set documento = trim(cast(num_documento as char(10)))
where documento is null or trim(documento) <> trim(cast(num_documento as char(10)));

delete from cxcdocm
where documento = docmto_aplicar
and motivo_cxc = motivo_ref
and aplicacion_origen = 'FAC'
and not exists
(select * from factura1, gral_forma_de_pago, factmotivos
where factura1.forma_pago = gral_forma_de_pago.forma_pago
and factura1.tipo = factmotivos.tipo
and factmotivos.cotizacion = 'N' and factmotivos.donacion = 'N'
and gral_forma_de_pago.dias > 0
and factura1.almacen = cxcdocm.almacen
and factura1.tipo = cxcdocm.motivo_cxc
and factura1.documento = cxcdocm.documento
and factura1.cliente = cxcdocm.cliente
and factura1.fecha_factura = cxcdocm.fecha_posteo
and factura1.status > 'A')
and not exists
(select * from f_conytram, factmotivos
where f_conytram.tipo = factmotivos.tipo
and factmotivos.cotizacion = 'N' and factmotivos.donacion = 'N'
and f_conytram.tipo = cxcdocm.motivo_cxc
and f_conytram.almacen = cxcdocm.almacen
and cast(no_documento as char(10)) = cxcdocm.documento
and cliente = cxcdocm.cliente);


insert into cxcdocm (documento, docmto_aplicar, cliente,
motivo_cxc, almacen, docmto_ref, motivo_ref,
aplicacion_origen, uso_interno, fecha_docmto, fecha_vmto, monto,
fecha_posteo, status, usuario, fecha_captura, fecha_cancelo)
select factura1.documento, factura1.documento, factura1.cliente,
factura1.tipo, factura1.almacen, factura1.documento, factura1.tipo,
'FAC', 'N', factura1.fecha_factura, factura1.fecha_vencimiento, -sum(factura4.monto*rubros_fact_cxc.signo_rubro_fact_cxc),
factura1.fecha_factura, 'R', 'dba', today(), today() 
from factura1, factura4, gral_forma_de_pago, rubros_fact_cxc, factmotivos
where factura1.almacen = factura4.almacen 
and factura1.tipo = factura4.tipo 
and factura1.num_documento = factura4.num_documento 
and factura1.forma_pago = gral_forma_de_pago.forma_pago 
and factura1.tipo = factmotivos.tipo 
and factura4.rubro_fact_cxc = rubros_fact_cxc.rubro_fact_cxc 
and factura1.status > 'A' 
and factmotivos.donacion = 'N' 
and factmotivos.cotizacion = 'N'
and gral_forma_de_pago.dias > 0
and factura1.aplicacion = 'FAC'
and not exists
(select * from cxcdocm
where documento = factura1.documento
and docmto_aplicar = factura1.documento
and motivo_cxc = factura1.tipo
and almacen = factura1.almacen
and cliente = factura1.cliente)
group by factura1.documento, factura1.cliente, factura1.tipo, factura1.almacen, factura1.fecha_factura,
factura1.fecha_vencimiento;


