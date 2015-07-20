begin work;
insert into cglauxiliares (auxiliar, nombre, tipo_persona, status)
select cliente, substring(nomb_cliente from 1 for 30), '1', 'A'
from clientes
where cliente not in 
(select auxiliar from cglauxiliares);
commit work;

begin work;
update cglauxiliares
set nombre = substring(trim(clientes.nomb_cliente) from 1 for 30)
where clientes.cliente = cglauxiliares.auxiliar;
commit work;
