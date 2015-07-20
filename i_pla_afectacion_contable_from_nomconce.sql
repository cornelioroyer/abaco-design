
insert into pla_afectacion_contable (departamento, cuenta, cod_concepto_planilla, porcentaje)
select '05','61103101',cod_concepto_planilla,100 from nomconce
where not exists
(select * from pla_afectacion_contable
where pla_afectacion_contable.departamento = '05'
and pla_afectacion_contable.cod_concepto_planilla = nomconce.cod_concepto_planilla)
