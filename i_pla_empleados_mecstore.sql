insert into pla_empleados(compania, codigo_empleado,
tipo_de_planilla, grupo, dependientes, nombre, apellido,
tipo_contrato, estado_civil, fecha_inicio, 
fecha_nacimiento, tipo_de_salario, forma_de_pago, tipo_calculo_ir, status,
sexo, cedula, dv, declarante, ss, direccion1, direccion2, tasa_por_hora, salario_bruto, email)
select 791, codigo_empleado, tipo_planilla, grup_impto_renta, num_dependiente, primer_nombre, apellido_paterno,
tipo_contrato, estado_civil, fecha_inicio, fecha_nacimiento, tipo_de_salario, 
forma_de_pago, tipo_calculo_ir, status, sexo_empleado, numero_cedula, dv, declarante, numero_ss,
direccion1, direccion2, tasaporhora, salario_bruto, ''
from tmp_rhuempl
where compania = '06'
