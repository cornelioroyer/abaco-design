
select cxc_recibo1.documento from cxc_recibo1, cxc_recibo2
where cxc_recibo1.almacen = cxc_recibo2.almacen
and cxc_recibo1.caja = cxc_recibo2.caja
and cxc_recibo1.consecutivo = cxc_recibo2.consecutivo
and cxc_recibo1.fecha >= '2014-08-01'
and not exists
(select * from cxcdocm
where cxcdocm.almacen = cxc_recibo2.almacen_aplicar
and cxcdocm.caja = cxc_recibo2.caja_aplicar
and cxcdocm.cliente = cxc_recibo1.cliente
and cxcdocm.documento = cxc_recibo2.documento_aplicar
and cxcdocm.docmto_aplicar = cxc_recibo2.documento_aplicar
and cxcdocm.motivo_cxc = cxc_recibo2.motivo_aplicar);
