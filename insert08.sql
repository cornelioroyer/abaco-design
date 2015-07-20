insert into cxcdocm(documento, docmto_aplicar, cliente, motivo_cxc, almacen,
docmto_ref, motivo_ref, aplicacion_origen, uso_interno, fecha_docmto,
fecha_vmto, monto, fecha_posteo, status, usuario, fecha_captura,
fecha_cancelo)
select documento, aplicar, cliente, motivo_cxc, '01', aplicar, motivo_cxc, 'SET', 'N', 
fecha, fecha, monto, fecha, 'R', 'dba', today(), fecha from trmes where 
documento = aplicar
group by documento, aplicar, cliente, motivo_cxc, aplicar, motivo_cxc, fecha, monto


