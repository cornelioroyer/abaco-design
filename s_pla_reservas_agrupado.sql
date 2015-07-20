select pla_reservas.compania, nomtpla2.dia_d_pago, rhuempl.departamento, pla_reservas.tipo_planilla,
pla_reservas.numero_planilla, pla_reservas.year, pla_reservas.concepto_reserva, 
sum(pla_reservas.monto) as reserva
from nomtpla2, rhuempl, pla_reservas
where nomtpla2.tipo_planilla = pla_reservas.tipo_planilla
and nomtpla2.numero_planilla = pla_reservas.numero_planilla
and nomtpla2.year = pla_reservas.year
and rhuempl.compania = pla_reservas.compania
and rhuempl.codigo_empleado = pla_reservas.codigo_empleado
and nomtpla2.dia_d_pago between '2010-12-01' and '2010-12-31'
and nomtpla2.tipo_planilla = '1'
group by 1, 2, 3, 4, 5, 6, 7
order by 1, 2, 3, 4, 5, 6, 7
