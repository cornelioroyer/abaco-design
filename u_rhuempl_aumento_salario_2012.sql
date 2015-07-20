update rhuempl
set tasaporhora = tasaporhora + tmp_aumento_harinas.aumento
from tmp_aumento_harinas
where trim(tmp_aumento_harinas.codigo_empleado) = trim(rhuempl.codigo_empleado)
