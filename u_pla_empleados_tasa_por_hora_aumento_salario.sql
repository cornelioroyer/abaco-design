update pla_empleados
set tasa_por_hora = 2.47, salario_bruto = (2.47 * 48 * 52) / 24
where compania = 1075
and tasa_por_hora <= 2.14
and status in ('A', 'V');
