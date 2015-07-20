create view v_pla_historico_pp as
select pla_dinero.compania, pla_dinero.codigo_empleado,
pla_dinero.concepto, pla_conceptos.descripcion,
Anio(pla_periodos.dia_d_pago) as anio,
Mes(pla_periodos.dia_d_pago) as mes,
pla_periodos.dia_d_pago as fecha,
(pla_dinero.monto*pla_conceptos.signo) as monto
from pla_dinero, pla_conceptos, pla_periodos
where pla_dinero.concepto = pla_conceptos.concepto
and pla_dinero.id_periodos = pla_periodos.id
