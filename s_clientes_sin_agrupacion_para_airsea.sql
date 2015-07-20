select clientes.cliente
from clientes
where clientes.cuenta = '1103'
and not exists
(select * from clientes_agrupados
where clientes_agrupados.cliente = clientes.cliente
and codigo_valor_grupo in ('02','03'))
order by 1
