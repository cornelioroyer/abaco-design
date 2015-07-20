	
    
    
    insert into cxcdocm (caja, documento, docmto_aplicar, cliente, motivo_cxc, almacen, docmto_ref,
	motivo_ref, aplicacion_origen, uso_interno, fecha_docmto, fecha_vmto, monto, fecha_posteo,
	status, usuario, fecha_captura, obs_docmto, fecha_cancelo, referencia)
	select fac_cajas.caja, documento, docmto_aplicar, cliente, motivo_cxc, cxcdocm_2013_05_20.almacen, docmto_ref,
	motivo_ref, aplicacion_origen, 'N', fecha_docmto, fecha_vmto, monto, fecha_posteo,
	'R', current_user, current_timestamp, obs_docmto, current_date, referencia
	from cxcdocm_2013_05_20, almacen, fac_cajas
	where fac_cajas.almacen = almacen.almacen
	and cxcdocm_2013_05_20.almacen = almacen.almacen
	and not exists
	(select * from cxcdocm
	where cxcdocm.almacen = cxcdocm_2013_05_20.almacen
	and cxcdocm.cliente = cxcdocm_2013_05_20.cliente
	and cxcdocm.documento = cxcdocm_2013_05_20.documento
	and cxcdocm.docmto_aplicar = cxcdocm_2013_05_20.docmto_aplicar
	and cxcdocm.motivo_cxc = cxcdocm_2013_05_20.motivo_cxc)
