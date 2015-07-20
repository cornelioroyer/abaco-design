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
		where fecha_posteo between :ld_desde and :ld_hasta
		and not exists
		(select * from cxcdocm
		where trim(cxcdocm.documento) = trim(cxc_hijos.docm_ajuste_cxc)
		and trim(cxcdocm.docmto_aplicar) = trim(cxc_hijos.aplicar_a)
		and trim(cxcdocm.cliente) = trim(cxc_hijos.cliente)
		and trim(cxcdocm.motivo_cxc) = trim(cxc_hijos.tipo_trx)
		and trim(cxcdocm.almacen) = trim(cxc_hijos.almacen))	using sqlca;