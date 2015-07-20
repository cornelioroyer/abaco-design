update nomhoras
set tasaporhora = tasaporhora + .10, forma_de_registro = 'M'
where compania = '03'
and nomhoras.tipo_planilla = '1'
and nomhoras.year = 2013
and nomhoras.numero_planilla = 26
and fecha_laborable >= '2013-07-04'
