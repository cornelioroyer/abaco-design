
--delete from pla_afectacion_contable where cod_concepto_planilla = '';

insert into pla_afectacion_contable (departamento, cuenta, cod_concepto_planilla, porcentaje)
select 'BD', cuenta , cod_concepto_planilla, porcentaje 
from pla_afectacion_contable
where departamento = 'VT'
