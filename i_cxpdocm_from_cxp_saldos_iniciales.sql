


rollback work;
begin work;
    delete from cxpdocm;
commit work;



begin work;
    insert into cxpdocm
    (proveedor, compania, documento, docmto_aplicar,
    motivo_cxp, docmto_aplicar_ref, motivo_cxp_ref,
    aplicacion_origen, uso_interno, fecha_docmto,
    fecha_vmto, monto, fecha_posteo, status,
    usuario, fecha_captura, obs_docmto, 
    fecha_cancelo, referencia)
    select proveedor, compania, factura, factura, motivo_cxp, factura, motivo_cxp,
    'SET', 'N', fecha, fecha, saldo, fecha, 'R', current_user, current_timestamp,
    null, fecha, null
    from cxp_saldos_iniciales;
commit work;