drop view v_nomctrac_pla_reservas;

create view v_nomctrac_pla_reservas as
select pla_reservas.compania, pla_reservas.codigo_empleado, pla_reservas.tipo_calculo,
pla_reservas.tipo_planilla, pla_reservas.year, nomtpla2.mes, pla_reservas.numero_planilla, 
pla_reservas.numero_documento,
rhucargo.codigo_cargo as cargo, rhucargo.descripcion_cargo,
pla_reservas.concepto_reserva as concepto, 
'RESERVAS' as tipo_de_concepto, 
nomconce.nombre_concepto, 
sum(pla_reservas.monto) as monto
from pla_reservas, nomtpla2, nomconce, rhuempl, rhucargo
where pla_reservas.concepto_reserva = nomconce.cod_concepto_planilla
and nomtpla2.tipo_planilla = pla_reservas.tipo_planilla
and nomtpla2.year = pla_reservas.year
and nomtpla2.numero_planilla = pla_reservas.numero_planilla
and rhuempl.codigo_cargo = rhucargo.codigo_cargo
and rhuempl.compania = pla_reservas.compania
and rhuempl.codigo_empleado = pla_reservas.codigo_empleado
and nomtpla2.dia_d_pago >= '2012-06-01'
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13
union
select nomctrac.compania, nomctrac.codigo_empleado, nomctrac.tipo_calculo,
nomctrac.tipo_planilla, nomctrac.year, nomtpla2.mes, nomctrac.numero_planilla, 
nomctrac.numero_documento,
rhucargo.codigo_cargo as cargo, rhucargo.descripcion_cargo,
nomctrac.cod_concepto_planilla as concepto, 
(case when nomctrac.cod_concepto_planilla = '101' or
nomctrac.cod_concepto_planilla = '140' or
nomctrac.cod_concepto_planilla = '160' then 'SOBRETIEMPO' else 'SALARIO_REGULAR' end) as tipo_de_concepto,
nomconce.nombre_concepto, 
sum(nomctrac.monto*nomconce.signo) as monto
from nomctrac, nomtpla2, nomconce, rhuempl, rhucargo
where nomctrac.cod_concepto_planilla = nomconce.cod_concepto_planilla
and rhuempl.codigo_cargo = rhucargo.codigo_cargo
and rhuempl.compania = nomctrac.compania
and rhuempl.codigo_empleado = nomctrac.codigo_empleado
and nomtpla2.tipo_planilla = nomctrac.tipo_planilla
and nomtpla2.year = nomctrac.year
and nomtpla2.numero_planilla = nomctrac.numero_planilla
and nomconce.cod_concepto_planilla not in ('108', '109', '125', '130', '220')
and nomconce.tipodeconcepto = '1'
and nomtpla2.dia_d_pago >= '2012-06-01'
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13;




/*
(case when nomctrac.cod_concepto_planilla = '101' or
nomctrac.cod_concepto_planilla = '140' or
nomctrac.cod_concepto_planilla = '160' then 'SOBRETIEMPO' else 'SALARIO_REGULAR' end) as tipo_de_concepto,
*/
