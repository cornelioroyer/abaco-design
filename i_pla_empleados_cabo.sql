insert into pla_empleados(compania, codigo_empleado,
cargo, departamento, tipo_de_planilla, grupo, dependientes, nombre, apellido,
tipo_contrato, estado_civil, fecha_inicio, 
fecha_nacimiento, tipo_de_salario, forma_de_pago, tipo_calculo_ir, status,
sexo, cedula, dv, declarante, ss, direccion1, tasa_por_hora, salario_bruto, email)
select 757, codigo_empleado,
cargo, departamento, tipo_de_planilla, grupo, dependientes, nombre, apellido,
tipo_contrato, estado_civil, fecha_inicio, 
fecha_nacimiento, tipo_de_salario, forma_de_pago, tipo_calculo_ir, status,
sexo, cedula, dv, declarante, ss, direccion1, tasa_por_hora, salario_bruto, email
from pla_empleados
where compania = 749