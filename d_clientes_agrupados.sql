/*
delete from clientes_agrupados
using clientes
where clientes.cliente = clientes_agrupados.cliente
and clientes.cuenta = '1103'
and clientes_agrupados.codigo_valor_grupo in ('01');
*/

insert into clientes_agrupados (cliente, codigo_valor_grupo)
select cliente, '03' from clientes
where cuenta = '1103'
and not exists
(select * from clientes_agrupados a
where a.cliente = clientes.cliente
and a.codigo_valor_grupo = '03');
