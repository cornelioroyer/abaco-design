drop view v_nomctrac_x_cuenta;
create view v_nomctrac_x_cuenta as
select rhuempl.compania, nomtpla2.dia_d_pago, pla_afectacion_contable.cuenta,
sum(nomctrac.monto * nomconce.signo) as monto
from nomctrac, rhuempl, nomconce, pla_afectacion_contable, nomtpla2
where nomctrac.compania = rhuempl.compania
and nomctrac.codigo_empleado = rhuempl.codigo_empleado
and nomctrac.cod_concepto_planilla = nomconce.cod_concepto_planilla
and pla_afectacion_contable.departamento = rhuempl.departamento
and pla_afectacion_contable.cod_concepto_planilla = nomctrac.cod_concepto_planilla
and nomtpla2.tipo_planilla = nomctrac.tipo_planilla
and nomtpla2.numero_planilla = nomctrac.numero_planilla 
and nomtpla2.year = nomctrac.year
and nomtpla2.dia_d_pago >= '2005-01-01'
group by 1, 2, 3
order by 1, 2, 3