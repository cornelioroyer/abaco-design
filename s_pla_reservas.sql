select pla_reservas.* from pla_reservas, nomtpla2
where pla_reservas.tipo_planilla = nomtpla2.tipo_planilla
and pla_reservas.year = nomtpla2.year
and pla_reservas.numero_planilla = nomtpla2.numero_planilla
and nomtpla2.dia_d_pago between '2010-12-01' and '2010-12-31'
and pla_reservas.tipo_planilla = '1'
