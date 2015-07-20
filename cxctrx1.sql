select * from cxcdocm
where documento <> docmto_aplicar
and aplicacion_origen = 'CXC'
and not exists
(select * from cxctrx1 a, cxctrx2 b
where a.almacen = b.almacen
and a.sec_ajuste_cxc = b.sec_ajuste_cxc
and cxcdocm.almacen = a.almacen
and cxcdocm.docmto_aplicar = b.aplicar_a
and cxcdocm.cliente = a.cliente
and cxcdocm.motivo_cxc = a.motivo_cxc
and cxcdocm.documento = a.docm_ajuste_cxc
and b.monto <> 0
and cxcdocm.monto = b.monto);
