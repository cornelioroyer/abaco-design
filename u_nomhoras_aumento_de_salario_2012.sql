update nomhoras
set tasaporhora = tasaporhora + tmp_aumento_harinas.aumento, forma_de_registro = 'M'
from tmp_aumento_harinas
where trim(tmp_aumento_harinas.codigo_empleado) = trim(nomhoras.codigo_empleado)
and nomhoras.tipo_planilla = '1'
and nomhoras.year = 2012
and nomhoras.numero_planilla = 27
and fecha_laborable >= '2012-07-04'
