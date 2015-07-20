
	insert into cxcdocm (documento, docmto_aplicar, cliente, motivo_cxc, almacen, docmto_ref,
	motivo_ref, aplicacion_origen, uso_interno, fecha_docmto, fecha_vmto, monto, fecha_posteo,
	status, usuario, fecha_captura, obs_docmto, fecha_cancelo, referencia)
	select trim(documento), trim(docmto_aplicar), trim(cliente), trim(motivo_cxc), 
    trim(v_cxcdocm_fac_fiscal.almacen), trim(docmto_ref),
	trim(motivo_ref), aplicacion_origen, 'N', fecha_docmto, fecha_vmto, monto, fecha_posteo,
	'R', current_user, current_timestamp, trim(obs_docmto), current_date, trim(referencia)
	from v_cxcdocm_fac_fiscal, almacen
    where v_cxcdocm_fac_fiscal.almacen = almacen.almacen
    and almacen.compania = '03'
	and (trim(documento) <> trim(docmto_aplicar)
    or trim(motivo_cxc) <> trim(motivo_ref))
    and documento = '3'
    and motivo_cxc = '9'
	and not exists
	(select * from cxcdocm
	where cxcdocm.almacen = v_cxcdocm_fac_fiscal.almacen
	and cxcdocm.cliente = v_cxcdocm_fac_fiscal.cliente
	and trim(cxcdocm.documento) = trim(v_cxcdocm_fac_fiscal.documento)
	and trim(cxcdocm.docmto_aplicar) = trim(v_cxcdocm_fac_fiscal.docmto_aplicar)
	and cxcdocm.motivo_cxc = v_cxcdocm_fac_fiscal.motivo_cxc)
    and exists
    (select * from cxcdocm
    where cxcdocm.almacen = v_cxcdocm_fac_fiscal.almacen
    and cxcdocm.cliente = v_cxcdocm_fac_fiscal.cliente
    and trim(cxcdocm.documento) = trim(v_cxcdocm_fac_fiscal.docmto_aplicar)
    and trim(cxcdocm.docmto_aplicar) = trim(v_cxcdocm_fac_fiscal.docmto_aplicar)
    and trim(cxcdocm.motivo_cxc) = trim(v_cxcdocm_fac_fiscal.motivo_ref));
