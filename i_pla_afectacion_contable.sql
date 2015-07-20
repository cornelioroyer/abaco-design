insert into pla_afectacion_contable (departamento, cuenta, cod_concepto_planilla, porcentaje)
select '41', cuenta, cod_concepto_planilla, porcentaje
from pla_afectacion_contable
where departamento = '001'
and not exists
    (select * from pla_afectacion_contable a
    where a.departamento = '41'
    and a.cuenta = pla_afectacion_contable.cuenta
    and a.cod_concepto_planilla = pla_afectacion_contable.cod_concepto_planilla);

    
    

