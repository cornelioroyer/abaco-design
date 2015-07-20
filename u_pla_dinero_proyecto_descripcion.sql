update pla_dinero
set descripcion = trim(pla_conceptos.descripcion)
from pla_conceptos, pla_periodos
where pla_dinero.concepto = pla_conceptos.concepto
and pla_dinero.id_periodos = pla_periodos.id
and pla_dinero.compania = 1142
and pla_periodos.dia_d_pago >= '2013-09-01';
