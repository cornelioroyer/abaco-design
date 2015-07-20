
update gralparaxcia
set valor = 'N'
where parametro = 'validar_fecha'
and aplicacion = 'CXC';

delete from cxcdocm
where documento <> docmto_aplicar or motivo_cxc <> motivo_ref;

delete from cxcdocm;

insert into cxcdocm (documento, docmto_aplicar, cliente,
motivo_cxc, almacen, docmto_ref, motivo_ref, aplicacion_origen,
uso_interno, fecha_docmto, fecha_vmto, monto, fecha_posteo,
status, usuario, fecha_captura, obs_docmto, fecha_cancelo, referencia)
select documento,docmto_aplicar, cliente,
motivo_cxc, almacen, docmto_ref, motivo_ref, aplicacion_origen,
uso_interno, fecha_docmto, fecha_vmto, monto, fecha_posteo,
status, usuario, fecha_captura, obs_docmto, fecha_cancelo, referencia
from tmp_cxcdocm
where documento = docmto_aplicar;

insert into cxcdocm (documento, docmto_aplicar, cliente,
motivo_cxc, almacen, docmto_ref, motivo_ref, aplicacion_origen,
uso_interno, fecha_docmto, fecha_vmto, monto, fecha_posteo,
status, usuario, fecha_captura, obs_docmto, fecha_cancelo, referencia)
select documento,docmto_aplicar, cliente,
motivo_cxc, almacen, docmto_ref, motivo_ref, aplicacion_origen,
uso_interno, fecha_docmto, fecha_vmto, monto, fecha_posteo,
status, usuario, fecha_captura, obs_docmto, fecha_cancelo, referencia
from tmp_cxcdocm
where documento <> docmto_aplicar;

update gralparaxcia
set valor = 'S'
where parametro = 'validar_fecha'
and aplicacion = 'CXC';
