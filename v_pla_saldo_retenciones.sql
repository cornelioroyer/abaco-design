drop view v_pla_retenciones;

drop function f_pla_retenciones(int4, varchar(20)) cascade;

begin work;
create function f_pla_retenciones(int4, varchar(20)) returns decimal as '
declare
    ai_id alias for $1;
    avc_retorno alias for $2;
    r_pla_retenciones record;
    ldc_pagos decimal;
begin

    select into r_pla_retenciones *
    from pla_retenciones
    where id = ai_id;
    if not found then
        return 0;
    end if;
    
    ldc_pagos = 0;
    select -sum(pla_dinero.monto*pla_conceptos.signo) into ldc_pagos
    from pla_deducciones, pla_dinero, pla_conceptos
    where pla_deducciones.id_pla_dinero = pla_dinero.id
    and pla_dinero.concepto = pla_conceptos.concepto
    and pla_deducciones.id_pla_retenciones = r_pla_retenciones.id;
    
    if ldc_pagos is null then
        ldc_pagos = 0;
    end if;
    
    if trim(avc_retorno) = ''SALDO'' then
        if r_pla_retenciones.hacer_cheque = ''S'' or r_pla_retenciones.monto_original_deuda = 0 then
            return 0;
        else
            return r_pla_retenciones.monto_original_deuda - ldc_pagos;
        end if;
    else
        return ldc_pagos;
    end if;
    
    return 0;
end;
' language plpgsql;
commit work;



create view v_pla_retenciones as
select pla_retenciones.compania, trim(pla_empleados.nombre) as nombre, 
trim(pla_empleados.apellido) as apellido,
trim(pla_retenciones.codigo_empleado) as codigo_de_empleado, 
trim(pla_acreedores.nombre) as nombre_acreedor, 
trim(pla_retenciones.acreedor) as acreedor, 
trim(pla_retenciones.descripcion_descuento) as descripcion_descuento,
trim(pla_retenciones.numero_documento) as numero_documento,
monto_original_deuda, 
f_pla_retenciones(id, 'PAGOS') as pagos,
f_pla_retenciones(id, 'SALDO') as saldo
from pla_retenciones, pla_empleados, pla_acreedores
where pla_retenciones.compania = pla_empleados.compania
and pla_retenciones.codigo_empleado = pla_empleados.codigo_empleado
and pla_acreedores.compania = pla_retenciones.compania
and pla_retenciones.status <> 'I'
and pla_acreedores.acreedor = pla_retenciones.acreedor;




