
drop view v_cgl_financiero_presupuesto cascade;
drop function f_cgl_presupuesto_acumulado(char(2), int4, char(24), int4, int4) cascade;


create function f_cgl_presupuesto_acumulado(char(2), int4, char(24), int4, int4) returns decimal as '
declare
    as_compania alias for $1;
    ai_no_informe alias for $2;
    as_cuenta alias for $3;
    ai_year alias for $4;
    ai_periodo alias for $5;
    ldc_monto decimal;
begin
    ldc_monto = 0;
    select into ldc_monto sum(cgl_presupuesto.monto)
    from cgl_presupuesto, cgl_financiero
    where cgl_presupuesto.cuenta = cgl_financiero.cuenta
    and cgl_financiero.no_informe = ai_no_informe
    and cgl_financiero.cuenta = as_cuenta
    and compania = as_compania
    and anio = ai_year
    and mes <= ai_periodo;
    if ldc_monto is null then
        ldc_monto = 0;
    end if;

    return ldc_monto;
end;
' language plpgsql;




create view v_cgl_financiero_presupuesto as
SELECT cgl_presupuesto.compania,  cgl_presupuesto.anio as year, 
cgl_presupuesto.mes as periodo, 
cgl_financiero.no_informe, cgl_financiero.d_fila, 
Sum(cgl_presupuesto.monto) as corriente
from cgl_presupuesto, cgl_financiero
where cgl_presupuesto.cuenta = cgl_financiero.cuenta
group BY 1, 2, 3, 4, 5
order BY 1, 2, 3, 4, 5
