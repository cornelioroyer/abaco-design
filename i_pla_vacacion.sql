insert into pla_vacacion
select b.pagar_desde, b.codigo_empleado,
b.compania, b.pagar_hasta, b.status
from pla_vacacion1 a, pla_vacacion2 b
where a.codigo_empleado = b.codigo_empleado
and a.compania = b.compania
and a.legal_desde = b.legal_desde
