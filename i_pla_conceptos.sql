insert into pla_conceptos (concepto, descripcion, signo,
prioridad_impresion, porcentaje, solo_patrono, tipo_de_concepto)
SELECT '105', 'VACACIONES PROPORCIONALES', signo,
prioridad_impresion, porcentaje, solo_patrono, tipo_de_concepto
from pla_conceptos
where concepto = '108'
