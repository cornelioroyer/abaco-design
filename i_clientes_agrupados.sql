delete from clientes_agrupados where codigo_valor_grupo = 'C1';

insert into clientes_agrupados(cliente, codigo_valor_grupo)
select cliente, 'C1' from clientes;

