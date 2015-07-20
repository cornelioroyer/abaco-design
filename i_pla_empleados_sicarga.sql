
insert into pla_empleados(compania, codigo_empleado,
apellido, nombre, cargo, departamento, id_pla_proyectos,
tipo_de_planilla, grupo, dependientes, dependientes_no_declarados,
tipo_contrato, estado_civil, fecha_inicio, fecha_nacimiento,
tipo_de_salario, forma_de_pago, tipo_calculo_ir,
status, sexo, tipo, cedula, dv, declarante, ss, direccion1,
tasa_por_hora, salario_bruto, email)
select 960, codigo, ' ', nombre, 1262, 
(select id from pla_departamentos where trim(pla_departamentos.departamento) = trim(tmp_empleados.departamento)
and compania = 960),
(select id from pla_proyectos where compania = 960),
'2', 'A', 0, 0, 'P', 'C', '2010-01-01', f_nac, 'F',
'C', 'A', 'A', sexo, '1', cedula, '00', 'N', cedula, 'poner', 1, salario, ' '
from tmp_empleados
