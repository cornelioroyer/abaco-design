update pla_empleados
set tasa_por_hora = 2.14, salario_bruto = (2.14 * 48 * 52) / 24
where compania = 839
and tasa_por_hora <= 2.14
