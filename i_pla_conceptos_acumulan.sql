
delete from pla_conceptos_acumulan
where concepto_aplica = '186';


/*
and not exists 
(select * from pla_conceptos_acumulan a
where a.concepto = '203'
and a.concepto_aplica = pla_conceptos_acumulan.concepto_aplica)

insert into pla_conceptos_acumulan(concepto, concepto_aplica)
select concepto, '187' 
from pla_conceptos_acumulan
where concepto_aplica = '03'


*/
