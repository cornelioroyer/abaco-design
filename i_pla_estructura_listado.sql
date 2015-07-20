insert into pla_estructura_listado (cod_concepto_planilla, listado, tipo_de_columna)
select cod_concepto_planilla, 7, 1 from nomconce
where tipodeconcepto = '1'
and cod_concepto_planilla not in
(select cod_concepto_planilla from pla_estructura_listado
where listado = 7);

insert into pla_estructura_listado (cod_concepto_planilla, listado, tipo_de_columna)
select cod_concepto_planilla, 7, 7 from nomconce
where tipodeconcepto = '2'
and cod_concepto_planilla not in
(select cod_concepto_planilla from pla_estructura_listado
where listado = 7);
