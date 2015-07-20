insert into clientes (cliente, forma_pago, cuenta,
cli_cliente, vendedor, nomb_cliente, fecha_apertura,
fecha_cierre, status, usuario, fecha_captura,
tel1_cliente, direccion1, limite_credito, promedio_dias_cobro,
estado_cuenta, categoria_abc)
select trim(proveedor), '30', '2200300', trim(proveedor), '01', nomb_proveedor, current_date,
current_date, 'A', current_user, current_timestamp, tel1_proveedor, direccion1, 0, 0, 'S', 'X'
from proveedores
where proveedor like 'T%'
