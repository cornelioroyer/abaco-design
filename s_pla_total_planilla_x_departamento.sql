select rhuempl.departamento, sum(nomctrac.monto*nomconce.signo) as monto
from nomctrac, nomtpla2, nom_conceptos_para_calculo, nomconce, rhuempl
where nomctrac.compania = rhuempl.compania
and nomctrac.codigo_empleado = rhuempl.codigo_empleado
and nomctrac.tipo_planilla = nomtpla2.tipo_planilla
and nomctrac.numero_planilla = nomtpla2.numero_planilla
and nomctrac.year = nomtpla2.year
and nomctrac.cod_concepto_planilla = nom_conceptos_para_calculo.concepto_aplica
and nomconce.cod_concepto_planilla = nomctrac.cod_concepto_planilla
and nom_conceptos_para_calculo.cod_concepto_planilla = '402'
and nomtpla2.year = 2008
and Mes(nomtpla2.dia_d_pago) = 12
group by 1
order by 1