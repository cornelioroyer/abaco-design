    select pla_dinero.id, pla_periodos.dia_d_pago, 
    pla_conceptos_acumulan.concepto as concepto_acumula,
    pla_dinero.concepto as concepto,
    pla_dinero.compania,
    pla_dinero.codigo_empleado,
    (pla_dinero.monto*pla_conceptos.signo) as monto
    from pla_dinero, pla_conceptos, pla_conceptos_acumulan, pla_periodos
    where pla_periodos.id = pla_dinero.id_periodos
    and pla_dinero.concepto = pla_conceptos.concepto
    and pla_dinero.concepto = pla_conceptos_acumulan.concepto_aplica
    and pla_conceptos_acumulan.concepto_aplica = '108'
    
/*    
    and pla_dinero.codigo_empleado = as_codigo_empleado
    and pla_periodos.dia_d_pago between ad_desde and ad_hasta
    and pla_dinero.compania = ai_cia
    and pla_conceptos_acumulan.concepto = as_concepto;

    
    select into ldc_acumulado_2 sum(pla_preelaboradas.monto*pla_conceptos.signo)
    from pla_preelaboradas, pla_conceptos, pla_conceptos_acumulan
    where pla_preelaboradas.concepto = pla_conceptos.concepto
    and pla_preelaboradas.concepto = pla_conceptos_acumulan.concepto_aplica
    and pla_preelaboradas.codigo_empleado = as_codigo_empleado
    and pla_preelaboradas.fecha between ad_desde and ad_hasta 
    and pla_preelaboradas.compania = ai_cia
    and pla_conceptos_acumulan.concepto = as_concepto;
*/
