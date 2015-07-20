insert into clientes(cliente, forma_pago, cuenta, cli_cliente, 
vendedor, nomb_cliente, fecha_apertura, status,
usuario, fecha_captura, tel1_cliente, fax_cliente, direccion1, limite_credito,
promedio_dias_cobro, estado_cuenta, categoria_abc)
select codigo, '30', '1103', codigo, vendedor,
nombre, current_date, 'A', current_user, current_timestamp, telefono, fax,
substring(direccion1 from 1 for 50), limite_credito, 0, 'S', 'A'
from tmp_agentes
where codigo_abaco like '%Activar%'
