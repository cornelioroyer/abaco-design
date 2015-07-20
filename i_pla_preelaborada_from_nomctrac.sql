insert into pla_preelaborada(cod_concepto_planilla, codigo_empleado, compania, fecha, monto)
select cod_concepto_planilla, '0000162', '05', nomtpla2.dia_d_pago, sum(nomctrac.monto)
from nomctrac, nomtpla2
where nomctrac.tipo_planilla = nomtpla2.tipo_planilla
and nomctrac.numero_planilla = nomtpla2.numero_planilla
and nomctrac.year = nomtpla2.year
and nomctrac.compania = '01'
and nomctrac.codigo_empleado = '010217'
group by cod_concepto_planilla, nomtpla2.dia_d_pago