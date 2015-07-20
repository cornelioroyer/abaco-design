			update cxctrx1
            set aplicacion = 'CXC'
            where fecha_posteo_ajuste_cxc >= '2002-11-1';

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
