insert into clientes (cliente, forma_pago, cuenta,
cli_cliente, vendedor, nomb_cliente, fecha_apertura,
fecha_cierre, status, usuario, fecha_captura,
tel1_cliente, direccion1, limite_credito, promedio_dias_cobro,
estado_cuenta, categoria_abc)
select trim(codigo), '30', '111000', trim(codigo), '00', nombre, current_date,
current_date, 'A', current_user, current_timestamp, '1', '1', 0, 0, 'S', 'X'
from tmp_clientes
where codigo is not null
and Length(Trim(codigo)) <= 6
and trim(codigo) not in (select cliente from clientes)
group by codigo, nombre