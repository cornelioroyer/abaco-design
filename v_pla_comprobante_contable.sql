drop view v_pla_comprobante_contable;

create view v_pla_comprobante_contable as
select pla_dinero.compania, pla_periodos.dia_d_pago,
Anio(pla_periodos.dia_d_pago) as anio, Mes(pla_periodos.dia_d_pago) as mes,
pla_cuentas.nombre, pla_cuentas.cuenta,
case when sum(pla_dinero.monto*pla_conceptos.signo) >= 0 then sum(pla_dinero.monto*pla_conceptos.signo) else 0 end as debito,
case when sum(pla_dinero.monto*pla_conceptos.signo) < 0 then sum(pla_dinero.monto*pla_conceptos.signo) else 0 end as credito
from pla_dinero, pla_cuentas, pla_periodos, pla_conceptos
where pla_periodos.id = pla_dinero.id_periodos
and pla_dinero.id_pla_cuentas = pla_cuentas.id
and pla_dinero.concepto = pla_conceptos.concepto
group by 1, 2, 3, 4, 5, 6
union
select pla_dinero.compania, pla_periodos.dia_d_pago,
Anio(pla_periodos.dia_d_pago) as anio, Mes(pla_periodos.dia_d_pago) as mes,
pla_cuentas.nombre, pla_cuentas.cuenta,
case when sum(pla_reservas_pp.monto*pla_conceptos.signo) >= 0 then sum(pla_reservas_pp.monto*pla_conceptos.signo) else 0 end as debito,
case when sum(pla_reservas_pp.monto*pla_conceptos.signo) < 0 then sum(pla_reservas_pp.monto*pla_conceptos.signo) else 0 end as credito
from pla_dinero, pla_cuentas, pla_periodos, pla_conceptos, pla_reservas_pp
where pla_periodos.id = pla_dinero.id_periodos
and pla_reservas_pp.id_pla_dinero = pla_dinero.id
and pla_reservas_pp.id_pla_cuentas = pla_cuentas.id
and pla_reservas_pp.concepto = pla_conceptos.concepto
group by 1, 2, 3, 4, 5, 6;
