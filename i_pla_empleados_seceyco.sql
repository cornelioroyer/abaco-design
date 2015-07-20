
insert into pla_empleados(compania, codigo_empleado,
apellido, nombre, cargo, departamento, id_pla_proyectos,
tipo_de_planilla, grupo, dependientes, dependientes_no_declarados,
tipo_contrato, estado_civil, fecha_inicio, fecha_nacimiento,
tipo_de_salario, forma_de_pago, tipo_calculo_ir,
status, sexo, tipo, cedula, dv, declarante, ss, direccion1,
tasa_por_hora, salario_bruto, email)
select 1046, codigo_empleado, apellido, nombre, 1575, 1359,
(select id from pla_proyectos where compania = 1046),
'2', grupo, dependientes, 0, 'P', 'C', fecha_inicio, 
fecha_nacimiento, 'F',
'T', 'A', 'A', sexo, '1', cedula, '00', 'N', ss, 'poner', tasa_por_hora, 
salario_mensual/2, ' '
from tmp_empleados_seceyco
