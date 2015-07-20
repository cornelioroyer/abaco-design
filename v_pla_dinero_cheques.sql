drop view v_pla_dinero_cheques;

create view v_pla_dinero_cheques as
    select pla_conceptos.tipo_de_concepto, 
    (pla_dinero.monto*pla_conceptos.signo) as monto,
    pla_dinero.compania, pla_dinero.tipo_de_calculo,
    pla_dinero.id_periodos,
    pla_dinero.codigo_empleado,
    pla_dinero.concepto
    from pla_dinero, pla_conceptos
    where pla_dinero.concepto = pla_conceptos.concepto
    and pla_dinero.id_pla_cheques_1 is null
    
    