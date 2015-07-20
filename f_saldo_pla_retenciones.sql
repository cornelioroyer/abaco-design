drop function f_saldo_pla_retenciones(int4, date) cascade;


create function f_saldo_pla_retenciones(int4, date) returns decimal as '
declare
    ai_id alias for $1;
    ad_fecha alias for $2;
    r_pla_retenciones record;
    r_pla_deducciones record;
    r_pla_empleados record;
    ldc_saldo decimal;
    ldc_pagos decimal;
begin
    ldc_saldo = 0;

    select into r_pla_retenciones * 
    from pla_retenciones
    where id = ai_id;
    if not found then
        return 0;
    end if;

    select into r_pla_empleados * from pla_empleados
    where compania = r_pla_retenciones.compania
    and codigo_empleado = r_pla_retenciones.codigo_empleado;
    if not found then
        return 0;
    end if;
    
    if r_pla_retenciones.hacer_cheque = ''S'' 
        or r_pla_retenciones.monto_original_deuda <= 0 then
        return 0;
    end if;
    
    if r_pla_retenciones.status <> ''A'' then
        return 0;
    end if;

    ldc_pagos = 0;
    select into ldc_pagos sum(pla_dinero.monto) 
    from pla_dinero, pla_deducciones, pla_periodos, pla_retenciones
    where pla_dinero.id = pla_deducciones.id_pla_dinero
    and pla_dinero.id_periodos = pla_periodos.id
    and pla_deducciones.id_pla_retenciones = r_pla_retenciones.id
    and pla_retenciones.id = ai_id
    and pla_periodos.dia_d_pago <= ad_fecha;
    
    if ldc_pagos is null then
        ldc_pagos = 0;
    end if;
    
    ldc_saldo = r_pla_retenciones.monto_original_deuda - ldc_pagos;
    
    return Round(ldc_saldo,2);
end;
' language plpgsql;

