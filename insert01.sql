insert into cxpdocm (proveedor, compania, documento, docmto_aplicar, motivo_cxp, docmto_aplicar_ref, motivo_cxp_ref, 
 aplicacion_origen, uso_interno, fecha_docmto, fecha_vmto, monto, fecha_posteo, status, usuario, fecha_captura, fecha_cancelo)

select proveedor, '03', factura, factura, 'FA', factura, 'FA', 'SET', 'N', fecha, fecha, saldo, fecha, 'R', 'dba', today(), today() from 
saldo_de_proveedores;

