begin work;
delete from cxcdocm where fecha_posteo >= '2003-2-1';
commit work;

	begin work;
    update factura1
	set documento = trim(cast(num_documento as char(10)))
	where documento is null or trim(documento) <> trim(cast(num_documento as char(10)));

	update factura1
	set aplicacion = 'FAC'
	where aplicacion is null;
    commit work;



begin work;
	insert into cxcdocm (documento, docmto_aplicar, cliente,
	motivo_cxc, almacen, docmto_ref, motivo_ref,
	aplicacion_origen, uso_interno, fecha_docmto, fecha_vmto, monto,
	fecha_posteo, status, usuario, fecha_captura, fecha_cancelo)
	select factura1.documento, factura1.documento, factura1.cliente,
	factura1.tipo, factura1.almacen, factura1.documento, factura1.tipo,
	'FAC', 'N', factura1.fecha_factura, factura1.fecha_vencimiento, -sum(factura4.monto*rubros_fact_cxc.signo_rubro_fact_cxc),
	factura1.fecha_factura, 'R', 'dba', today(), today() 
	from factura1, factura4, gral_forma_de_pago, rubros_fact_cxc, factmotivos
	where factura1.almacen = factura4.almacen 
	and factura1.tipo = factura4.tipo 
	and factura1.num_documento = factura4.num_documento 
	and factura1.forma_pago = gral_forma_de_pago.forma_pago 
	and factura1.tipo = factmotivos.tipo 
	and factura4.rubro_fact_cxc = rubros_fact_cxc.rubro_fact_cxc 
	and factura1.status > 'A' 
	and factmotivos.donacion = 'N' 
	and factmotivos.cotizacion = 'N'
	and gral_forma_de_pago.dias > 0
	and factura1.aplicacion = 'FAC'
	and not exists
	(select * from cxcdocm
	where documento = factura1.documento
	and docmto_aplicar = factura1.documento
	and motivo_cxc = factura1.tipo
	and almacen = factura1.almacen
	and cliente = factura1.cliente)
	group by factura1.documento, factura1.cliente, factura1.tipo, factura1.almacen, factura1.fecha_factura,
	factura1.fecha_vencimiento;
commit work;


begin work;
	insert into cxcdocm
	select documento, documento, cliente, tipo,
	almacen, documento, tipo, 'FAC', 'N',
	fecha_factura, fecha_factura, total, fecha_factura,
	'R', 'dba', today(), null, today() 
	from f_conytram_resumen
	where not exists
	(select * from cxcdocm
	where documento = f_conytram_resumen.documento
	and docmto_aplicar = f_conytram_resumen.documento
	and cliente = f_conytram_resumen.cliente
	and motivo_cxc = f_conytram_resumen.tipo
	and almacen = f_conytram_resumen.almacen);
    
	update cxctrx1
	set aplicacion = 'CXC'
	where aplicacion is null;

	update cxcfact1
	set aplicacion = 'CXC'
	where aplicacion is null;

	insert into cxcdocm (documento, docmto_aplicar, cliente,
	motivo_cxc, almacen, docmto_ref, motivo_ref,
	aplicacion_origen, uso_interno, fecha_docmto, fecha_vmto, monto,
	fecha_posteo, status, usuario, fecha_captura, fecha_cancelo)
	select no_factura, no_factura, cliente, motivo_cxc,
	almacen, no_factura, motivo_cxc, aplicacion, 'N', fecha_posteo, 
	fecha_vencimiento, monto, fecha_posteo, 'R', 'dba', today(), today()
	from cxc_cxcfact1
	where not exists
	(select * from cxcdocm
	where cxcdocm.documento = cxc_cxcfact1.no_factura
	and cxcdocm.docmto_aplicar = cxc_cxcfact1.no_factura
	and cxcdocm.cliente = cxc_cxcfact1.cliente
	and cxcdocm.motivo_cxc = cxc_cxcfact1.motivo_cxc
	and cxcdocm.almacen = cxc_cxcfact1.almacen);

	insert into cxcdocm (documento, docmto_aplicar, cliente,
	  motivo_cxc, almacen, docmto_ref, motivo_ref,
	  aplicacion_origen, uso_interno, fecha_docmto, fecha_vmto, monto,
	  fecha_posteo, status, usuario, fecha_captura, fecha_cancelo)
	select cxctrx1.docm_ajuste_cxc, cxctrx1.docm_ajuste_cxc, cxctrx1.cliente,
	cxctrx1.motivo_cxc, cxctrx1.almacen, cxctrx1.docm_ajuste_cxc,
	cxctrx1.motivo_cxc, 'CXC', 'N', cxctrx1.fecha_posteo_ajuste_cxc,
	cxctrx1.fecha_posteo_ajuste_cxc, (cxctrx1.efectivo+cxctrx1.cheque),
	cxctrx1.fecha_posteo_ajuste_cxc, 'R', 'dba', today(), today()
	from cxctrx1, cxctrx3
	where cxctrx1.almacen = cxctrx3.almacen
	and cxctrx1.sec_ajuste_cxc = cxctrx3.sec_ajuste_cxc
	and cxctrx1.aplicacion = 'CXC'
	and (cxctrx1.efectivo+cxctrx1.cheque) > 0
	and not exists 
	(select * from cxctrx2 where cxctrx2.almacen = cxctrx1.almacen
	and cxctrx2.sec_ajuste_cxc = cxctrx1.sec_ajuste_cxc)
	and not exists
	(select * from cxcdocm
	where cxcdocm.documento = cxctrx1.docm_ajuste_cxc
	and cxcdocm.docmto_aplicar = cxctrx1.docm_ajuste_cxc
	and cxcdocm.cliente = cxctrx1.cliente
	and cxcdocm.motivo_cxc = cxctrx1.motivo_cxc
	and cxcdocm.almacen = cxctrx1.almacen);
commit work;


begin work;
	 insert into cxcdocm (documento, docmto_aplicar, cliente,
	 motivo_cxc, almacen, docmto_ref, motivo_ref,
	 aplicacion_origen, uso_interno, fecha_docmto, fecha_vmto, monto,
	 fecha_posteo, status, usuario, fecha_captura, fecha_cancelo)
	select docm_ajuste_cxc, aplicar_a, cliente,
	tipo_trx, almacen, aplicar_a,
	motivo_cxc, 'CXC', 'N', fecha_posteo,
	fecha_posteo, monto,
	fecha_posteo, 'R', 'dba', today(), today()
	from cxc_hijos
	where fecha_posteo >= '2003-1-1'
	and not exists
	(select * from cxcdocm
	where cxcdocm.documento = cxc_hijos.docm_ajuste_cxc
	and cxcdocm.docmto_aplicar = cxc_hijos.aplicar_a
	and cxcdocm.cliente = cxc_hijos.cliente
	and cxcdocm.motivo_cxc = cxc_hijos.tipo_trx
	and cxcdocm.almacen = cxc_hijos.almacen);

commit work;
	


