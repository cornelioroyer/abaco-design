drop view v_pla_horas_valorizadas;
create view v_pla_horas_valorizadas as
select nomhoras.compania, nomhoras.codigo_empleado, nomtpla2.tipo_planilla, 
nomtpla2.year, nomtpla2.numero_planilla, nomhoras.tipodhora,
pla_rela_horas_conceptos.cod_concepto_planilla, 
nomtpla2.dia_d_pago,
round(sum((nomhoras.horas + (nomhoras.minutos/60))*nomtipodehoras.signo), 2) as horas,
round((sum((nomhoras.horas + (nomhoras.minutos/60))*nomtipodehoras.signo)*avg(nomtipodehoras.recargo*nomhoras.tasaporhora)), 2) as monto
from nomtpla2, nomhoras, pla_rela_horas_conceptos, nomtipodehoras
where nomtpla2.tipo_planilla = nomhoras.tipo_planilla
and nomtpla2.numero_planilla = nomhoras.numero_planilla
and nomtpla2.year = nomhoras.year
and pla_rela_horas_conceptos.tipodhora = nomhoras.tipodhora
and nomtipodehoras.tipodhora = nomhoras.tipodhora
group by 1, 2, 3, 4, 5, 6, 7, 8

