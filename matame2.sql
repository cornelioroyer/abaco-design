/*
delete from pla_auxiliares
where compania = 1363;

delete from pla_empleados
where compania = 1363
and codigo_empleado in (select codigo_empleado from tmp_empleados)
*/

delete from pla_empleados
where compania in (1363, 1357)
and status in ('E','I')
