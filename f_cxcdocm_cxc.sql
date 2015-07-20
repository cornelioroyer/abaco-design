drop function f_cxcdocm_cxc();
create function f_cxcdocm_cxc() returns integer as '

begin work;
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
commit work;

begin work;
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
commit work;

begin work;
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
commit work;

begin work;
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
