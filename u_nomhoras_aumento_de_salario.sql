update nomhoras
set tasaporhora = tasaporhora + .10, forma_de_registro = 'M'
where tipo_planilla = '1'
and fecha_laborable >= '2011-07-03';

