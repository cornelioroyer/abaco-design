
/*
delete from pla_conceptos_acumulan 
where concepto = '410';
*/

insert into pla_conceptos_acumulan (concepto, concepto_aplica)
select '410',  concepto_aplica 
from pla_conceptos_acumulan
where concepto = '402';
