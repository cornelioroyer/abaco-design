
update gralparaxcia
set valor = 'N'
where parametro = 'validar_fecha'
and aplicacion = 'CXC';

insert into cxcdocm (documento, docmto_aplicar, cliente,
motivo_cxc, almacen, docmto_ref, motivo_ref, aplicacion_origen,
uso_interno, fecha_docmto, fecha_vmto, monto, fecha_posteo,
status, usuario, fecha_captura, obs_docmto, fecha_cancelo, referencia, caja)
select documento,docmto_aplicar, cliente,
motivo_cxc, almacen, docmto_ref, motivo_ref, aplicacion_origen,
uso_interno, fecha_docmto, fecha_vmto, monto, fecha_posteo,
status, usuario, fecha_captura, obs_docmto, fecha_cancelo, referencia, caja
from cxchdocm
where cliente not in ('xxxx0000824')
and documento <> docmto_aplicar
and not exists
(select * from cxcdocm
where cxchdocm.almacen = cxcdocm.almacen
and cxchdocm.documento = cxcdocm.documento
and cxchdocm.docmto_aplicar = cxcdocm.docmto_aplicar
and cxchdocm.motivo_cxc = cxcdocm.motivo_cxc
and cxchdocm.caja = cxcdocm.caja
and cxchdocm.cliente = cxcdocm.cliente);

update gralparaxcia
set valor = 'S'
where parametro = 'validar_fecha'
and aplicacion = 'CXC';
