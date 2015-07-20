begin work;
drop view v_matame;
create view v_matame as
select 791 as compania, codigo_empleado, tmp_nomconce.concepto_pp as concepto, 
tmp_nomtpla2.dia_d_pago as fecha, 
sum(tmp_nomctrac.monto) as monto
from tmp_nomctrac, tmp_nomconce, tmp_nomtpla2
where tmp_nomctrac.cod_concepto_planilla = tmp_nomconce.cod_concepto_planilla
and tmp_nomctrac.tipo_planilla = tmp_nomtpla2.tipo_planilla
and tmp_nomctrac.numero_planilla = tmp_nomtpla2.numero_planilla
and tmp_nomctrac.year = tmp_nomtpla2.year
and tmp_nomctrac.compania = '06'
group by codigo_empleado, tmp_nomconce.concepto_pp, tmp_nomtpla2.dia_d_pago
union
select 791, codigo_empleado, tmp_nomconce.concepto_pp, fecha,
sum(tmp_pla_preelaborada.monto)
from tmp_pla_preelaborada, tmp_nomconce
where tmp_pla_preelaborada.cod_concepto_planilla = tmp_nomconce.cod_concepto_planilla
and tmp_pla_preelaborada.compania = '06'
group by codigo_empleado, tmp_nomconce.concepto_pp, fecha;
commit work;



begin work;
delete from pla_preelaboradas where compania = 791;
delete from pla_auxiliares where compania = 791;
delete from pla_empleados where compania = 791;
commit work;

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
where compania = '06';



insert into pla_preelaboradas (compania, codigo_empleado, concepto, fecha, monto)
select compania, codigo_empleado, concepto, fecha, sum(monto)
from v_matame
group by 1, 2, 3, 4;



