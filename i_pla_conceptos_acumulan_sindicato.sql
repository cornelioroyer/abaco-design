delete from pla_conceptos_acumulan
where concepto = '150';

insert into pla_conceptos_acumulan(concepto, concepto_aplica)
select '150', concepto_aplica
from pla_conceptos_acumulan
where concepto = '102'
