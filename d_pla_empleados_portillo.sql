

delete from pla_preelaboradas
where exists
(select * from pla_empleados
where compania = 1289
and tipo_de_planilla = '2');


delete from pla_empleados
where compania = 1289
and tipo_de_planilla = '2';

