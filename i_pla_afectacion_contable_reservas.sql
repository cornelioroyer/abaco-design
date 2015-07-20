insert into pla_afectacion_contable
select '06', cuenta, cod_concepto_planilla, 100 from pla_afectacion_contable
where departamento = '00'
and not exists
(select * from pla_afectacion_contable b
where b.departamento = '06'
and b.cuenta = pla_afectacion_contable.cuenta
and b.cod_concepto_planilla = pla_afectacion_contable.cod_concepto_planilla);