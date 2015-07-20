
insert into pla_empleados(compania, codigo_empleado,
tipo_de_planilla, grupo, dependientes, nombre, apellido,
tipo_contrato, estado_civil, fecha_inicio, 
fecha_nacimiento, tipo_de_salario, forma_de_pago, tipo_calculo_ir, status,
sexo, cedula, dv, declarante, ss, direccion1, direccion2, tasa_por_hora, salario_bruto, email)
select 1304, pla_empleados.codigo_empleado,
tipo_de_planilla, grupo, dependientes, pla_empleados.nombre, pla_empleados.apellido,
tipo_contrato, estado_civil, fecha_inicio, 
fecha_nacimiento, tipo_de_salario, forma_de_pago, tipo_calculo_ir, status,
sexo, cedula, dv, declarante, ss, direccion1, direccion2, tasa_por_hora, salario_bruto, email
from pla_empleados, tmp_empleados
where pla_empleados.compania = tmp_empleados.compania
and trim(pla_empleados.codigo_empleado) = trim(tmp_empleados.codigo_empleado)
and pla_empleados.compania = 749
