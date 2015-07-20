update rhuempl
set tasaporhora = tasaporhora + .10
where compania = '03'
and tipo_planilla = '1'
and status in ('A','V')
