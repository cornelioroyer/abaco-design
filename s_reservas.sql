create view v_pla_reservas_x_departamento as
select nomtpla2.dia_d_pago, rhuempl.departamento, pla_reservas.concepto_reserva,
pla_afectacion_contable.cuenta, sum(nomctrac.monto*nomconce.signo) as base,
sum(pla_reservas.monto) as reserva
from rhuempl, pla_afectacion_contable, nomconce, nomtpla2, nomctrac, pla_reservas
where nomctrac.codigo_empleado = pla_reservas.codigo_empleado
and nomctrac.compania = pla_reservas.compania
and nomctrac.tipo_calculo = pla_reservas.tipo_calculo
and nomctrac.cod_concepto_planilla = pla_reservas.cod_concepto_planilla
and nomctrac.tipo_planilla = pla_reservas.tipo_planilla
and nomctrac.numero_planilla = pla_reservas.numero_planilla
and nomctrac.year = pla_reservas.year
and nomctrac.numero_documento = pla_reservas.numero_documento
and nomctrac.tipo_planilla = nomtpla2.tipo_planilla
and nomctrac.numero_planilla = nomtpla2.numero_planilla
and nomctrac.year = nomtpla2.year
and rhuempl.compania = nomctrac.compania
and rhuempl.codigo_empleado = nomctrac.codigo_empleado
and pla_afectacion_contable.departamento = rhuempl.departamento
and pla_afectacion_contable.cod_concepto_planilla = pla_reservas.concepto_reserva
and nomctrac.cod_concepto_planilla = nomconce.cod_concepto_planilla
group by 1, 2, 3, 4
order by 1