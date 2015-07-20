begin work;
insert into cglauxiliares (auxiliar, nombre, tipo_persona, status)
select pais, substring(nombre from 1 for 30), '1', 'A'
from fac_paises
where pais not in 
(select auxiliar from cglauxiliares);
commit work;

begin work;
update cglauxiliares
set nombre = substring(trim(fac_paises.nombre) from 1 for 30)
where fac_paises.pais = cglauxiliares.auxiliar;
commit work;


begin work;
insert into cglauxiliares (auxiliar, nombre, tipo_persona, status)
select ciudad, substring(nombre from 1 for 30), '1', 'A'
from fac_ciudades
where ciudad not in 
(select auxiliar from cglauxiliares);
commit work;

begin work;
update cglauxiliares
set nombre = substring(trim(fac_ciudades.nombre) from 1 for 30)
where fac_ciudades.ciudad = cglauxiliares.auxiliar;
commit work;
