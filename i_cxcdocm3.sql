			 insert into cxcdocm (documento, docmto_aplicar, cliente,
			 motivo_cxc, almacen, docmto_ref, motivo_ref,
			 aplicacion_origen, uso_interno, fecha_docmto, fecha_vmto, monto,
			 fecha_posteo, status, usuario, fecha_captura, fecha_cancelo)
			select cxctrx1.docm_ajuste_cxc, cxctrx2.aplicar_a, cxctrx1.cliente,
			cxctrx1.motivo_cxc, cxctrx1.almacen, cxctrx2.aplicar_a,
			cxctrx2.motivo_cxc, 'CXC', 'N', cxctrx1.fecha_posteo_ajuste_cxc,
			cxctrx1.fecha_posteo_ajuste_cxc, cxctrx2.monto,
			cxctrx1.fecha_posteo_ajuste_cxc, 'R', 'dba', today(), today()
			from cxctrx1, cxctrx2
			where cxctrx1.almacen = cxctrx2.almacen
			and cxctrx1.sec_ajuste_cxc = cxctrx2.sec_ajuste_cxc
			and cxctrx1.aplicacion = 'CXC'
			and cxctrx2.monto > 0
			and not exists
			(select * from cxcdocm
			where cxcdocm.documento = cxctrx1.docm_ajuste_cxc
			and cxcdocm.docmto_aplicar = cxctrx2.aplicar_a
			and cxcdocm.cliente = cxctrx1.cliente
			and cxcdocm.motivo_cxc = cxctrx1.motivo_cxc
			and cxcdocm.almacen = cxctrx1.almacen)
			and exists
			(select * from cxcdocm
			where cxcdocm.almacen = cxctrx1.almacen
			and cxcdocm.cliente = cxctrx1.cliente
			and cxcdocm.documento = cxctrx2.aplicar_a
			and cxcdocm.docmto_aplicar = cxctrx2.aplicar_a
			and cxcdocm.motivo_cxc = cxctrx2.motivo_cxc);