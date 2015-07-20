/*
select f_cxc_recibo1_cglposteo(almacen, consecutivo) from cxc_recibo1
where fecha >= '2005-12-15'
and not exists
(select * from rela_cxc_recibo1_cglposteo
where rela_cxc_recibo1_cglposteo.almacen = cxc_recibo1.almacen
and rela_cxc_recibo1_cglposteo.consecutivo = cxc_recibo1.consecutivo);


select f_factura1_cglposteo(almacen, tipo, num_documento)
from factura1
where fecha_factura between '2006-01-01' and '2006-12-31'
and not exists
(select * from rela_factura1_cglposteo
where rela_factura1_cglposteo.almacen = factura1.almacen
and rela_factura1_cglposteo.tipo = factura1.tipo
and rela_factura1_cglposteo.num_documento = factura1.num_documento);
*/


select cxc_recibo2.* from cxc_recibo1, cxc_recibo2
where cxc_recibo1.almacen = cxc_recibo2.almacen
and cxc_recibo1.consecutivo = cxc_recibo2.consecutivo
and cxc_recibo2.monto_aplicar <> 0
and cxc_recibo1.fecha >= '2005-12-01'
and not exists
(select * from cxcdocm
where cxcdocm.almacen = cxc_recibo2.almacen_aplicar
and cxcdocm.cliente = cxc_recibo1.cliente
and cxcdocm.documento = cxc_recibo2.documento_aplicar
and cxcdocm.docmto_aplicar = cxc_recibo2.documento_aplicar
and cxcdocm.motivo_cxc = cxc_recibo2.motivo_aplicar);

