update rhuempl
set tasaporhora = tasaporhora + .04
where tipo_planilla = '1'
and status in ('A','V')
and tipo_de_salario = 'H'
