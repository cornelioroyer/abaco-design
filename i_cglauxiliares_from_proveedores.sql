begin work;
insert into cglauxiliares (auxiliar, nombre, tipo_persona, status)
select proveedor, substring(nomb_proveedor from 1 for 30), '1', 'A'
from proveedores
where proveedor like 'T%'
and proveedor not in 
(select auxiliar from cglauxiliares);
commit work;


/*
begin work;
update cglauxiliares
set nombre = substring(trim(clientes.nomb_cliente) from 1 for 30)
where clientes.cliente = cglauxiliares.auxiliar;
commit work;
*/
