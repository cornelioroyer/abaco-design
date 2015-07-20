rollback work;

begin work;
select f_planilla_regular_empleado(compania, codigo_empleado)
from pla_empleados
where tipo_de_planilla = '2'
and compania = 992
and fecha_inicio between '1930-01-01' and '2000-12-31';
commit work;

begin work;
select f_planilla_regular_empleado(compania, codigo_empleado)
from pla_empleados
where tipo_de_planilla = '2'
and compania = 992
and fecha_inicio between '2001-01-01' and '2010-12-31';
commit work;


begin work;
select f_planilla_regular_empleado(compania, codigo_empleado)
from pla_empleados
where tipo_de_planilla = '2'
and compania = 992
and fecha_inicio between '2011-01-01' and '2030-12-31';
commit work;
