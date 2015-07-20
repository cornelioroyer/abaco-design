delete from pla_empleados where compania = 866;

insert into pla_empleados(compania, codigo_empleado,
tipo_de_planilla, grupo, dependientes, nombre, apellido,
tipo_contrato, estado_civil, fecha_inicio, 
fecha_nacimiento, tipo_de_salario, forma_de_pago, tipo_calculo_ir, status,
sexo, cedula, dv, declarante, ss, direccion1, direccion2, tasa_por_hora, salario_bruto, email)
select 866, codigo_empleado, '2', 'A', 0, nombre, '', 
'P', 'S', '2008-01-01', '1980-01-01', 'H', 'C', 'A', 'A', 'M', cedula, '00', 'N', ss,
null, null, tasa_por_hora, (tasa_por_hora*48*52)/12, ' ' 
from tmp_empleados
where trim(codigo_empleado) <> '0';

