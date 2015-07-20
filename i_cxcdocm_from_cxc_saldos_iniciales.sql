
begin work;
delete from cxcdocm where documento <> docmto_aplicar;
delete from cxcdocm;
commit work;


begin work;
    insert into cxcdocm (almacen, cliente, documento, docmto_aplicar, motivo_cxc,
    docmto_ref, motivo_ref, fecha_posteo, fecha_docmto, fecha_vmto,
    fecha_cancelo, fecha_captura, usuario, obs_docmto, referencia, uso_interno,
    status, aplicacion_origen, monto)
    select almacen, cliente, documento, documento, motivo_cxc,
    documento, motivo_cxc, fecha, fecha, fecha,
    fecha, current_timestamp, current_user, null, null, 'N',
    'R', 'SET', monto 
    from cxc_saldos_iniciales;
commit work;

