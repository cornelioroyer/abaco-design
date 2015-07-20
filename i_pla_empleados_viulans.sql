delete from pla_preelboradas where compania = 790;
delete from pla_auxiliares where compania = 790;
delete from pla_empleados where compania = 790;

insert into pla_empleados(compania, codigo_empleado,
tipo_de_planilla, grupo, dependientes, nombre, apellido,
tipo_contrato, estado_civil, fecha_inicio, 
fecha_nacimiento, tipo_de_salario, forma_de_pago, tipo_calculo_ir, status,
sexo, cedula, dv, declarante, ss, direccion1, direccion2, tasa_por_hora, salario_bruto, email)
select 790, codigo_empleado, tipo_planilla, grup_impto_renta, num_dependiente, primer_nombre, apellido_paterno,
tipo_contrato, estado_civil, fecha_inicio, fecha_nacimiento, tipo_de_salario, 
forma_de_pago, tipo_calculo_ir, status, sexo_empleado, numero_cedula, dv, declarante, numero_ss,
direccion1, direccion2, tasaporhora, salario_bruto, ''
from tmp_rhuempl
where compania = '05';

insert into pla_preelaboradas (compania, codigo_empleado, concepto, fecha, monto)
select 791, codigo_empleado, tmp_nomconce.concepto_pp, tmp_nomtpla2.dia_d_pago, 
sum(tmp_nomctrac.monto)
from tmp_nomctrac, tmp_nomconce, tmp_nomtpla2
where tmp_nomctrac.cod_concepto_planilla = tmp_nomconce.cod_concepto_planilla
and tmp_nomctrac.tipo_planilla = tmp_nomtpla2.tipo_planilla
and tmp_nomctrac.numero_planilla = tmp_nomtpla2.numero_planilla
and tmp_nomctrac.year = tmp_nomtpla2.year
and tmp_nomctrac.compania = '05'
group by codigo_empleado, tmp_nomconce.concepto_pp, tmp_nomtpla2.dia_d_pago