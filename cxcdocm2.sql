begin work;
delete from cxcdocm
where documento = docmto_aplicar
and motivo_cxc = motivo_ref
and aplicacion_origen = 'FAC'
and not exists
(select * from factura1, gral_forma_de_pago
where factura1.forma_pago = gral_forma_de_pago.forma_pago
and gral_forma_de_pago.dias > 0
and factura1.almacen = cxcdocm.almacen
and factura1.tipo = cxcdocm.motivo_cxc
and factura1.documento = cxcdocm.documento
and factura1.cliente = cxcdocm.cliente
and factura1.fecha_factura = cxcdocm.fecha_posteo);
commit work;

begin work;
insert into cxcdocm (documento, docmto_aplicar, cliente,
motivo_cxc, almacen, docmto_ref, motivo_ref,
aplicacion_origen, uso_interno, fecha_docmto, fecha_vmto, monto,
fecha_posteo, status, usuario, fecha_captura, fecha_cancelo)
select documento, documento, cliente,
tipo, almacen, documento, tipo, 'FAC', 'N',
fecha_factura, fecha_factura, monto,
fecha_factura, 'R', 'dba', today(),
today()
from fact_totales
where dias > 0 and monto > 0 and not exists
(select * from cxcdocm
where cxcdocm.documento = fact_totales.documento
and cxcdocm.docmto_aplicar = fact_totales.documento
and cxcdocm.cliente = fact_totales.cliente
and cxcdocm.motivo_cxc = fact_totales.tipo
and cxcdocm.almacen = fact_totales.almacen);
commit work;


