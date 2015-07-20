insert into pla_afectacion_contable (departamento, cuenta, cod_concepto_planilla, porcentaje)
select codigo, '50.11', '145', 100 from departamentos
where not exists
    (select * from pla_afectacion_contable
    where departamento = departamentos.codigo
    and cuenta = '50.11'
    and cod_concepto_planilla = '145')