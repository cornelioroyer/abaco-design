update rhuempl
set tasaporhora = tasaporhora + .1
where status in ('A', 'V')
and tipo_planilla = '1'
and sindicalizado = 'S'
and tipo_de_salario = 'H'
