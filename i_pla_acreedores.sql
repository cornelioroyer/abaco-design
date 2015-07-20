insert into pla_acreedores (compania, acreedor,
concepto, nombre, status, telefono, direccion, 
observacion, prioridad, ahorro)
select 1201,acreedor,
concepto, nombre, status, telefono, direccion, 
observacion, prioridad, ahorro  
from pla_acreedores a
where compania = 1146
and not exists
(select * from pla_acreedores
where pla_acreedores.compania = 1201
and pla_acreedores.acreedor = a.acreedor)
