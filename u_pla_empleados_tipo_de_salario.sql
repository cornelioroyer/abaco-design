set search_path to planilla;

update pla_empleados
set tipo_de_salario = 'F'
where compania = 1046
and tipo_de_planilla = '2';

