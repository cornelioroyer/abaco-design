update rhuempl
set tasaporhora = tasaporhora + .10
where compania = '03'
and tipo_planilla = '2'
and sindicalizado = 'S'
and tipo_de_salario = 'F'
and status in ('A','V');

update rhuempl
set salario_bruto = ((tasaporhora * 48) * 52)/24
where compania = '03'
and tipo_planilla = '2'
and tipo_de_salario = 'F'
and sindicalizado = 'S'
and status in ('A','V');
