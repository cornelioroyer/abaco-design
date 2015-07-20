select pla_tipos_de_horas.tipo_de_hora, pla_tipos_de_horas.descripcion,
pla_conceptos.concepto, pla_conceptos.descripcion
from pla_conceptos, pla_tipos_de_horas, pla_rela_horas_conceptos
where pla_conceptos.concepto = pla_rela_horas_conceptos.concepto
and pla_tipos_de_horas.tipo_de_hora = pla_rela_horas_conceptos.tipo_de_hora
order by 1, 2, 3, 4
