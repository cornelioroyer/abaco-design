insert into clientes(cliente, forma_pago, cuenta, cli_cliente, 
vendedor, nomb_cliente, fecha_apertura, status,
usuario, fecha_captura, tel1_cliente, fax_cliente, direccion1, limite_credito,
promedio_dias_cobro, estado_cuenta, categoria_abc, dv, tipo_de_persona, concepto, tipo_de_compra)
select cliente, '30', '1050110', cliente, '00',
'no tiene', current_date, 'A', current_user, current_timestamp, 'x', 'x',
'x', 1, 0, 'S', 'A', '00', '1', '1', '1'
from tmp_cliente
