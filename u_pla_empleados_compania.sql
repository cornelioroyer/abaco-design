/*
select * from pla_empleados
where compania = 1146
and codigo_empleado = '0010';
*/

/*
update pla_empleados
set compania = 1201
where compania = 1146
and id_pla_proyectos in (1144);
*/

update pla_empleados
set id_pla_proyectos = 1597
where compania = 1201;

select codigo_empleado from pla_empleados, pla_departamentos
where pla_empleados.compania = 1201
and pla_departamentos.id = pla_empleados.departamento
and pla_departamentos.compania = pla_empleados.compania;
