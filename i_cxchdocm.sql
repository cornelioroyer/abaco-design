insert into cxchdocm (documento, docmto_aplicar, cliente,
motivo_cxc, almacen, docmto_ref, motivo_ref, aplicacion_origen,
uso_interno, fecha_docmto, fecha_vmto, monto, fecha_posteo,
status, usuario, fecha_captura, obs_docmto, fecha_cancelo, referencia)
select documento,docmto_aplicar, cliente,
motivo_cxc, almacen, docmto_ref, motivo_ref, aplicacion_origen,
uso_interno, fecha_docmto, fecha_vmto, monto, fecha_posteo,
status, usuario, fecha_captura, obs_docmto, fecha_cancelo, referencia
from tmp_cxcdocm
where documento = docmto_aplicar
and cliente in (select cliente from tmp_matame)
and not exists
(select * from cxchdocm
where cxchdocm.almacen = tmp_cxcdocm.almacen
and cxchdocm.documento = tmp_cxcdocm.documento
and cxchdocm.docmto_aplicar = tmp_cxcdocm.docmto_aplicar
and cxchdocm.motivo_cxc = tmp_cxcdocm.motivo_cxc
and cxchdocm.cliente = tmp_cxcdocm.cliente)