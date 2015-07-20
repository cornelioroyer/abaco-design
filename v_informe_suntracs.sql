
drop view v_informe_suntracs;

create view v_informe_suntracs as
select pla_dinero.compania, trim(pla_empleados.apellido) as apellido,
trim(pla_empleados.nombre) as nombre,
trim(pla_empleados.cedula) as cedula,
trim(pla_cargos.descripcion) as calificacion,
pla_periodos.dia_d_pago as fecha,
pla_empleados.tasa_por_hora as salario_por_hora,
sum(case when pla_periodos.periodo = 1 and trim(pla_dinero.concepto) <> '108' then pla_dinero.monto * pla_conceptos.signo else 0 end) as primera_bisemana,
sum(case when pla_periodos.periodo = 2 and trim(pla_dinero.concepto) <> '108' then pla_dinero.monto * pla_conceptos.signo else 0 end) as segunda_bisemana,
sum(case when pla_periodos.periodo = 3 and trim(pla_dinero.concepto) <> '108' then pla_dinero.monto * pla_conceptos.signo else 0 end) as tercera_bisemana,
sum(case when trim(pla_dinero.concepto) = '108' then pla_dinero.monto * pla_conceptos.signo else 0 end) as vacaciones
from pla_empleados, pla_dinero, pla_conceptos, 
pla_conceptos_acumulan, pla_periodos,
pla_cargos
where pla_empleados.compania = pla_dinero.compania
and pla_empleados.codigo_empleado = pla_dinero.codigo_empleado
and pla_dinero.concepto = pla_conceptos.concepto
and pla_dinero.id_periodos = pla_periodos.id
and pla_cargos.id = pla_empleados.cargo
and pla_dinero.concepto = pla_conceptos_acumulan.concepto_aplica
and pla_conceptos_acumulan.concepto = '202'
and pla_empleados.sindicalizado = 'S'
group by 1, 2, 3, 4, 5, 6, 7;







