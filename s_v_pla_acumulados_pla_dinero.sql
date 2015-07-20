select v_pla_acumulados_pla_dinero.* from v_pla_acumulados_pla_dinero, pla_dinero
where v_pla_acumulados_pla_dinero.id = pla_dinero.id
and pla_dinero.codigo_empleado = '0001'