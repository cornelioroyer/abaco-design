
insert into rhuempl (compania, codigo_empleado, apellido_paterno,
primer_nombre, nombre_del_empleado,
tipo_contrato, estado_civil, fecha_inicio, fecha_terminacion,
fecha_nacimiento, tipo_de_salario, codigo_cargo, forma_de_pago,
tipo_calculo_ir, cod_id_turnos, turnosabado, tipo_planilla, grup_impto_renta,
num_dependiente, departamento, 
telefono_1, status, sexo_empleado, numero_cedula, numero_ss, 
direccion1, sindicalizado, tasaporhora, dv,
declarante, salario_bruto, monto_ult_aumento,cuenta, tipo_d_turno )
select '03',numemp,apellido, 'poner',apellido,'P',estado_civil,date(fecha_entrada),
date(fecha_salida), date(fecha_nacimiento), fijo_hora, '00','C','R','01','01', tipo_planilla,
crenta, nrenta, 'NO', 'telefono', status,
sexo, cedula, ss, 'direccion',sindicalizado,tasa_por_hora,'00','N', salario, 0, '1', 'R'
from tmp_empleados
where status is not null