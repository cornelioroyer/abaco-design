drop function f_cxcdocm();
create function f_cxcdocm() returns integer as '

begin work;
update factura1
set documento = trim(cast(num_documento as char(10)))
where documento is null or trim(documento) <> trim(cast(num_documento as char(10)));

delete from cxcdocm
where documento = docmto_aplicar
and motivo_cxc = motivo_ref
and aplicacion_origen = ''FAC''
and not exists
(select * from factura1, gral_forma_de_pago, factmotivos
where factura1.forma_pago = gral_forma_de_pago.forma_pago
and factura1.tipo = factmotivos.tipo
and factmotivos.cotizacion = ''N'' and factmotivos.donacion = ''N''
and gral_forma_de_pago.dias > 0
and factura1.almacen = cxcdocm.almacen
and factura1.tipo = cxcdocm.motivo_cxc
and factura1.documento = cxcdocm.documento
and factura1.cliente = cxcdocm.cliente
and factura1.fecha_factura = cxcdocm.fecha_posteo
and factura1.status > ''A'')
and not exists
(select * from f_conytram, factmotivos
where f_conytram.tipo = factmotivos.tipo
and factmotivos.cotizacion = ''N'' and factmotivos.donacion = ''N''
and f_conytram.tipo = cxcdocm.motivo_cxc
and f_conytram.almacen = cxcdocm.almacen
and cast(no_documento as char(10)) = cxcdocm.documento
and cliente = cxcdocm.cliente);

insert into cxcdocm (documento, docmto_aplicar, cliente,
motivo_cxc, almacen, docmto_ref, motivo_ref,
aplicacion_origen, uso_interno, fecha_docmto, fecha_vmto, monto,
fecha_posteo, status, usuario, fecha_captura, fecha_cancelo)
select factura1.documento, factura1.documento, factura1.cliente,
factura1.tipo, factura1.almacen, factura1.documento, factura1.tipo,
''FAC'', ''N'', factura1.fecha_factura, factura1.fecha_vencimiento, -sum(factura4.monto*rubros_fact_cxc.signo_rubro_fact_cxc),
factura1.fecha_factura, ''R'', ''dba'', today(), today() 
from factura1, factura4, gral_forma_de_pago, rubros_fact_cxc, factmotivos
where factura1.almacen = factura4.almacen 
and factura1.tipo = factura4.tipo 
and factura1.num_documento = factura4.num_documento 
and factura1.forma_pago = gral_forma_de_pago.forma_pago 
and factura1.tipo = factmotivos.tipo 
and factura4.rubro_fact_cxc = rubros_fact_cxc.rubro_fact_cxc 
and factura1.status > ''A'' 
and factmotivos.donacion = ''N'' 
and factmotivos.cotizacion = ''N''
and gral_forma_de_pago.dias > 0
and factura1.aplicacion = ''FAC''
and not exists
(select * from cxcdocm
where documento = factura1.documento
and docmto_aplicar = factura1.documento
and motivo_cxc = factura1.tipo
and almacen = factura1.almacen
and cliente = factura1.cliente)
group by factura1.documento, factura1.cliente, factura1.tipo, factura1.almacen, factura1.fecha_factura,
factura1.fecha_vencimiento;

delete from cxcdocm
where trim(documento) = trim(docmto_aplicar)
and trim(motivo_cxc) = trim(motivo_ref)
and aplicacion_origen = ''CXC''
and motivo_cxc in (select motivo_cxc from cxcmotivos where ajustes = ''S'')
and not exists
(select * from cxctrx1, cxctrx3
where cxctrx1.almacen = cxctrx3.almacen
and cxctrx1.sec_ajuste_cxc = cxctrx3.sec_ajuste_cxc
and cxcdocm.documento = cxctrx1.docm_ajuste_cxc
and cxcdocm.docmto_aplicar = cxctrx1.docm_ajuste_cxc
and cxcdocm.cliente = cxctrx1.cliente
and cxcdocm.motivo_cxc = cxctrx1.motivo_cxc
and cxcdocm.almacen = cxctrx1.almacen
and cxcdocm.monto = (cxctrx1.efectivo + cxctrx1.cheque)
and not exists (select * from cxctrx2 where cxctrx2.almacen = cxctrx1.almacen
and cxctrx2.sec_ajuste_cxc = cxctrx1.sec_ajuste_cxc));

delete from cxcdocm
where (documento <> docmto_aplicar or motivo_cxc <> motivo_ref)
and aplicacion_origen = ''CXC''
and not exists
(select * from cxctrx1 a, cxctrx2 b
where a.almacen = b.almacen
and a.sec_ajuste_cxc = b.sec_ajuste_cxc
and cxcdocm.almacen = a.almacen
and cxcdocm.docmto_aplicar = b.aplicar_a
and cxcdocm.cliente = a.cliente
and cxcdocm.motivo_cxc = a.motivo_cxc
and cxcdocm.documento = a.docm_ajuste_cxc
and b.monto <> 0
and cxcdocm.monto = b.monto);

insert into cxcdocm (documento, docmto_aplicar, cliente,
  motivo_cxc, almacen, docmto_ref, motivo_ref,
  aplicacion_origen, uso_interno, fecha_docmto, fecha_vmto, monto,
  fecha_posteo, status, usuario, fecha_captura, fecha_cancelo)
select cxctrx1.docm_ajuste_cxc, cxctrx1.docm_ajuste_cxc, cxctrx1.cliente,
cxctrx1.motivo_cxc, cxctrx1.almacen, cxctrx1.docm_ajuste_cxc,
cxctrx1.motivo_cxc, ''CXC'', ''N'', cxctrx1.fecha_posteo_ajuste_cxc,
cxctrx1.fecha_posteo_ajuste_cxc, (cxctrx1.efectivo+cxctrx1.cheque),
cxctrx1.fecha_posteo_ajuste_cxc, ''R'', ''dba'', today(), today()
from cxctrx1, cxctrx3
where cxctrx1.almacen = cxctrx3.almacen
and cxctrx1.sec_ajuste_cxc = cxctrx3.sec_ajuste_cxc
and cxctrx1.aplicacion = ''CXC''
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

 insert into cxcdocm (documento, docmto_aplicar, cliente,
 motivo_cxc, almacen, docmto_ref, motivo_ref,
 aplicacion_origen, uso_interno, fecha_docmto, fecha_vmto, monto,
 fecha_posteo, status, usuario, fecha_captura, fecha_cancelo)
select cxctrx1.docm_ajuste_cxc, cxctrx2.aplicar_a, cxctrx1.cliente,
cxctrx1.motivo_cxc, cxctrx1.almacen, cxctrx2.aplicar_a,
cxctrx2.motivo_cxc, ''CXC'', ''N'', cxctrx1.fecha_posteo_ajuste_cxc,
cxctrx1.fecha_posteo_ajuste_cxc, cxctrx2.monto,
cxctrx1.fecha_posteo_ajuste_cxc, ''R'', ''dba'', today(), today()
from cxctrx1, cxctrx2
where cxctrx1.almacen = cxctrx2.almacen
and cxctrx1.sec_ajuste_cxc = cxctrx2.sec_ajuste_cxc
and cxctrx1.aplicacion = ''CXC''
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
commit work;

select 1;
' language 'sql';
