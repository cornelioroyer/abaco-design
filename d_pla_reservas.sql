delete from pla_reservas
where not exists
(select * from nomctrac, nomtpla2
where nomctrac.tipo_planilla = nomtpla2.tipo_planilla
and nomctrac.year = nomtpla2.year
and nomctrac.numero_planilla = nomtpla2.numero_planilla
and nomtpla2.dia_d_pago >= '1900-12-01'
and nomctrac.codigo_empleado = pla_reservas.codigo_empleado
and nomctrac.compania = pla_reservas.compania
and nomctrac.tipo_calculo = pla_reservas.tipo_calculo
and nomctrac.cod_concepto_planilla = pla_reservas.cod_concepto_planilla
and nomctrac.tipo_planilla = pla_reservas.tipo_planilla
and nomctrac.numero_planilla = pla_reservas.numero_planilla
and nomctrac.year = pla_reservas.year
and nomctrac.numero_documento = pla_reservas.numero_documento);
