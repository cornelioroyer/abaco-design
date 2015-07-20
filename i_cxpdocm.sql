

update gralparaxcia
set valor = 'N'
where parametro = 'validar_fecha'
and aplicacion = 'CXP';

rollback work;
begin work;
    delete from cxpdocm
    where documento <> docmto_aplicar or motivo_cxp <> motivo_cxp_ref;
commit work;

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
    select proveedor, compania, documento, docmto_aplicar,
    motivo_cxp, docmto_aplicar_ref, motivo_cxp_ref,
    aplicacion_origen, uso_interno, fecha_docmto,
    fecha_vmto, monto, fecha_posteo, status,
    usuario, fecha_captura, status,
    fecha_cancelo, null
    from tmp_cxpdocm
    where documento = docmto_aplicar;
commit work;

begin work;
    insert into cxpdocm
    (proveedor, compania, documento, docmto_aplicar,
    motivo_cxp, docmto_aplicar_ref, motivo_cxp_ref,
    aplicacion_origen, uso_interno, fecha_docmto,
    fecha_vmto, monto, fecha_posteo, status,
    usuario, fecha_captura, obs_docmto, 
    fecha_cancelo, referencia)
    select proveedor, compania, documento, docmto_aplicar,
    motivo_cxp, docmto_aplicar_ref, motivo_cxp_ref,
    aplicacion_origen, uso_interno, fecha_docmto,
    fecha_vmto, monto, fecha_posteo, status,
    usuario, fecha_captura, status,
    fecha_cancelo, null
    from tmp_cxpdocm
    where documento <> docmto_aplicar;
commit work;

update gralparaxcia
set valor = 'S'
where parametro = 'validar_fecha'
and aplicacion = 'CXP';
