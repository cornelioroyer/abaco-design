begin work;
insert into cglauxiliares (auxiliar, nombre, tipo_persona, status)
select codigo, substring(trim(descripcion) from 1 for 30), '1', 'A' from departamentos
where codigo not in 
(select auxiliar from cglauxiliares);
commit work;

begin work;
update cglauxiliares
set nombre = substring(trim(departamentos.descripcion) from 1 for 30)
where departamentos.codigo = cglauxiliares.auxiliar;
commit work;
