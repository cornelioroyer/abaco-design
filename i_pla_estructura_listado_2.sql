insert into pla_estructura_listado (cod_concepto_planilla, listado, tipo_de_columna)
select concepto_aplica, 5, 1
from nom_conceptos_para_calculo
where cod_concepto_planilla = '102'
and not exists
(select * from pla_estructura_listado
where pla_estructura_listado.cod_concepto_planilla = nom_conceptos_para_calculo.concepto_aplica
and pla_estructura_listado.listado = 5
and pla_estructura_listado.tipo_de_columna = 1)




