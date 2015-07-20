
--delete from nom_conceptos_para_calculo
--where cod_concepto_planilla = '410';

/*
insert into nom_conceptos_para_calculo (cod_concepto_planilla, concepto_aplica)
select '430', concepto_aplica from nom_conceptos_para_calculo
where cod_concepto_planilla = '102';
*/


insert into nom_conceptos_para_calculo (cod_concepto_planilla, concepto_aplica)
select cod_concepto_planilla, '105' from nom_conceptos_para_calculo
where concepto_aplica = '100';


