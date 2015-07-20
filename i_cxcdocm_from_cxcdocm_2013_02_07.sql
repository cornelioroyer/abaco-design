
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
from cxcdocm_2013_02_07
where fecha_posteo <= '2014-12-31'
and not exists
(select * from cxcdocm
where cxcdocm_2013_02_07.almacen = cxcdocm.almacen
and cxcdocm_2013_02_07.documento = cxcdocm.documento
and cxcdocm_2013_02_07.docmto_aplicar = cxcdocm.docmto_aplicar
and cxcdocm_2013_02_07.motivo_cxc = cxcdocm.motivo_cxc
and cxcdocm_2013_02_07.caja = cxcdocm.caja
and cxcdocm_2013_02_07.cliente = cxcdocm.cliente);

update gralparaxcia
set valor = 'S'
where parametro = 'validar_fecha'
and aplicacion = 'CXC';
