update nomhoras
set tasaporhora = tasaporhora - .1, forma_de_registro = 'M'
where tipo_planilla = '1'
and year = 2010
and numero_planilla = 27
and fecha_laborable <= '2010-07-02'
