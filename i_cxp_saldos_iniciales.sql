insert into proveedores (proveedor, forma_pago, cuenta, nomb_proveedor,
tel1_proveedor, id_proveedor, dv_proveedor, status, usuario,
fecha_captura, limite_credito, fecha_apertura, direccion1)
select proveedor, '30', '1', nombre_proveedor, '1', '1', '1', 'A', 'dba',
today(), 9999999, today(), '1' from cxpdocm_bl
where proveedor not in (select proveedor from proveedores)
group by proveedor, nombre_proveedor;

insert into cxp_saldos_iniciales (compania, proveedor,
factura, fecha, saldo, motivo_cxp)
select '03', proveedor, factura, fecha, sum(saldo), '01' from cxpdocm_bl
group by proveedor, factura, fecha