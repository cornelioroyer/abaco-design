

update clientes
set cliente = '1'||trim(cliente)
where fecha_apertura >= '2013-07-17'
and usuario in ('juan', 'dba');



select cliente
from clientes
where fecha_apertura >= '2013-07-17'
and usuario in ('juan', 'dba')
order by cliente;



