delete from clientes;
insert into clientes (cliente, forma_pago, cuenta, cli_cliente, vendedor, nomb_cliente,
 id, fecha_apertura, fecha_cierre, status, usuario, fecha_captura, tel1_cliente, apartado, 
direccion1, direccion2, limite_credito, categoria_abc, estado_cuenta, promedio_dias_cobro)
select cliente, '30', '1', cliente, '01', nomb_cliente, ruc, today(), today(), 
'A', 'dba', today(), telefono, apartado, direccion1, direccion2, limite_de_credito, 
'A1',  estado_de_cuenta, 0 from clients where cliente is not null;





