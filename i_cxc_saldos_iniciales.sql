begin work;
insert into clientes (cliente, forma_pago, cuenta,
cli_cliente, vendedor, nomb_cliente, fecha_apertura,
fecha_cierre, status, usuario, fecha_captura,
tel1_cliente, direccion1, limite_credito, promedio_dias_cobro,
estado_cuenta, categoria_abc)
select trim(cliente), '30', '111000', trim(cliente), '00', nomb_cliente, current_date,
current_date, 'A', current_user, current_timestamp, '1', '1', 0, 0, 'S', 'X'
from cxc_clientes_panama
where cliente is not null
and trim(cliente) not in (select cliente from clientes)
group by cliente, nomb_cliente;
commit work;

update clientes
set cuenta = '111000';

insert into cxc_saldos_iniciales (almacen, cliente, documento, motivo_cxc,
fecha, monto)
select '01', trim(cliente), trim(factura), '01', fecha_posteo, saldo
from cxc_clientes_panama;