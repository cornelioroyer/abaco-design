insert into clientes_exentos(impuesto, cliente, cuenta)
select '00', cliente, '2300170' from clientes
where cliente like 'T%'
and cliente not in (select cliente from clientes_exentos)
