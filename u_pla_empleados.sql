

update pla_empleados
set tipo_de_salario = 'H'
where compania = 1378
and tipo_de_planilla = '3';



/*

update pla_empleados
set tasa_por_hora = salario_bruto / 104
where compania = 1378
and tipo_de_planilla = '2';


update pla_empleados
set salario_bruto = salario_bruto / 2
where compania = 1378
and tipo_de_planilla = '2';

update pla_empleados
set tasa_por_hora = 2.14, salario_bruto = (2.14 * 48 * 52) / 24
where compania = 839
and tasa_por_hora <= 2.14

*/
