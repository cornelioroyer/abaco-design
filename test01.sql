select pla_departamentos.descripcion, pla_conceptos.tipo_de_concepto, 
pla_conceptos.descripcion, sum(pla_conceptos.signo*pla_dinero.monto) as monto
from pla_dinero, pla_periodos, pla_conceptos, pla_departamentos
where pla_dinero.id_periodos = pla_periodos.id
and pla_dinero.id_pla_departamentos = pla_departamentos.id
and pla_dinero.concepto = pla_conceptos.concepto
and pla_periodos.dia_d_pago between '2009-08-01' and '2009-08-31'
and pla_dinero.compania = 749
group by 1, 2, 3
order by 1, 2, 3