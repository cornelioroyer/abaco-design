insert into cxcdocm(documento, docmto_aplicar, cliente, motivo_cxc, almacen,
docmto_ref, motivo_ref, aplicacion_origen, uso_interno, fecha_docmto,
fecha_vmto, monto, fecha_posteo, status, usuario, fecha_captura,
fecha_cancelo)
select 'ABRIL/1995', 'ABRIL/1995', cliente, '1', '01', 'ABRIL/1995', '1', 'SET',
'N', '30-4-1995', '30-4-1995', saldo, '30-4-1995', 'R', 'dba', today(), '30-4-1995'
 from balance495;

