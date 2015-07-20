

rollback work;

update gralparaxcia
set valor = 'N'
where parametro = 'validar_fecha'
and aplicacion = 'CXP';

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
    fecha_cancelo, referencia
    from cxphdocm
    where cxphdocm.documento = cxphdocm.docmto_aplicar 
    and cxphdocm.motivo_cxp = cxphdocm.motivo_cxp_ref
    and cxphdocm.compania = '03'
    and not exists
    (select * from cxpdocm
    where cxpdocm.compania = cxphdocm.compania
    and cxpdocm.proveedor = cxphdocm.proveedor
    and cxpdocm.documento = cxphdocm.documento
    and cxpdocm.docmto_aplicar = cxphdocm.docmto_aplicar
    and cxpdocm.motivo_cxp = cxphdocm.motivo_cxp);    
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
    fecha_cancelo, referencia
    from cxphdocm
    where cxphdocm.compania = '03'
    and not exists
    (select * from cxpdocm
    where cxpdocm.compania = cxphdocm.compania
    and cxpdocm.proveedor = cxphdocm.proveedor
    and cxpdocm.documento = cxphdocm.documento
    and cxpdocm.docmto_aplicar = cxphdocm.docmto_aplicar
    and cxpdocm.motivo_cxp = cxphdocm.motivo_cxp);    
commit work;

update gralparaxcia
set valor = 'S'
where parametro = 'validar_fecha'
and aplicacion = 'CXP';
