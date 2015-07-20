set search_path to planilla;

select (select pla_conceptos.descripcion from pla_conceptos
where pla_conceptos.concepto = pla_conceptos_acumulan.concepto),
pla_conceptos_acumulan.concepto,
(select pla_conceptos.descripcion from pla_conceptos
where pla_conceptos.concepto = pla_conceptos_acumulan.concepto_aplica),
pla_conceptos_acumulan.concepto_aplica
from pla_conceptos_acumulan
order by 2, 4
