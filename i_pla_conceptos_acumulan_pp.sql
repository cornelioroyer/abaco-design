/*
select * FROM PLA_CONCEPTOS_ACUMULAN
where concepto_aplica = '03';


delete from pla_conceptos_acumulan 
where concepto_aplica = '82';
*/

insert into pla_conceptos_acumulan (concepto, concepto_aplica)
select concepto,  '161' from pla_conceptos_acumulan
where concepto_aplica = '03';
