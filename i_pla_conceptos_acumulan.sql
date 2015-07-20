
insert into pla_conceptos_acumulan(concepto, concepto_aplica)
select concepto, '03S' 
from pla_conceptos_acumulan
where concepto_aplica = '03'

/*
and not exists 
(select * from pla_conceptos_acumulan a
where a.concepto = '203'
and a.concepto_aplica = pla_conceptos_acumulan.concepto_aplica)
*/
