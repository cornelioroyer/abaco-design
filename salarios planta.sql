select Mes(nomtpla2.dia_d_pago), rhuempl.nombre_del_empleado, 
nomctrac.codigo_empleado, nomconce.nombre_concepto,
nomctrac.cod_concepto_planilla, sum(nomctrac.monto)
from nomctrac, nomconce, nomtpla2, rhuempl
where nomctrac.compania = rhuempl.compania
and nomctrac.codigo_empleado = rhuempl.codigo_empleado
and nomctrac.cod_concepto_planilla = nomconce.cod_concepto_planilla
and nomctrac.tipo_planilla = nomtpla2.tipo_planilla
and nomctrac.numero_planilla = nomtpla2.numero_planilla
and nomctrac.year = nomtpla2.year
and nomctrac.compania = '03'
and nomconce.tipodeconcepto = '1'
and nomtpla2.dia_d_pago between '2004-01-02' and '2004-08-31'
and rhuempl.departamento in ('001', '002', '5')
group by 1, 2, 3, 5, 4
order by 1, 2, 3, 5, 4