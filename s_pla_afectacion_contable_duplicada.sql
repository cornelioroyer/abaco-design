select departamento, pla_afectacion_contable.cod_concepto_planilla, count(*)
from pla_afectacion_contable, nomconce
where pla_afectacion_contable.cod_concepto_planilla = nomconce.cod_concepto_planilla
and nomconce.solo_patrono = 'N'
group by 1, 2
having count(*) > 1
order by 1, 2
