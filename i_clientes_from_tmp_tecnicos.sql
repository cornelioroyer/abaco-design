insert into clientes (cliente, forma_pago, cuenta,
cli_cliente, vendedor, nomb_cliente, fecha_apertura,
fecha_cierre, status, usuario, fecha_captura,
tel1_cliente, direccion1, limite_credito, promedio_dias_cobro,
estado_cuenta, categoria_abc, id)
select trim(codigo), '30', '2200300', trim(codigo), '01', nombre, 
current_date, current_date, 'A', current_user, current_timestamp, '1', '1', 
0, 0, 'S', 'X', ruc
from tmp_tecnicos
where trim(codigo) not in (select trim(cliente) from clientes)
and codigo not in ('T0039', 'T1129')
group by codigo, nombre, ruc



