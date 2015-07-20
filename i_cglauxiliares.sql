insert into cglauxiliares (auxiliar, nombre, tipo_persona)
select cliente, substring(nomb_cliente from 1 for 30), '1'
from clientes
where cliente not in 
(select auxiliar from cglauxiliares);

update cglauxiliares
set nombre = substring(trim(clientes.nomb_cliente) from 1 for 30)
where clientes.cliente = cglauxiliares.auxiliar;
