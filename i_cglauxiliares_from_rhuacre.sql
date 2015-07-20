begin work;
insert into cglauxiliares (auxiliar, nombre, tipo_persona)
select cod_acreedores, substring(nombre_acreedores from 1 for 30), '1'
from rhuacre
where cod_acreedores not in 
(select auxiliar from cglauxiliares);
commit work;

begin work;
update cglauxiliares
set nombre = substring(trim(rhuacre.nombre_acreedores) from 1 for 30)
where rhuacre.cod_acreedores = cglauxiliares.auxiliar;
commit work;

