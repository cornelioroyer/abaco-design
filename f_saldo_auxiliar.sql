
drop function f_saldo_auxiliar(char(2), char(24), char(10), date, int4) cascade;

create function f_saldo_auxiliar(char(2), char(24), char(10), date, int4) returns decimal(10,2) as '
declare
    as_compania alias for $1;
    as_cuenta alias for $2;
    as_auxiliar alias for $3;
    ad_fecha alias for $4;
    ai_auxiliar alias for $5;
    ldc_saldo decimal;
begin
    ldc_saldo = 0;
    if ai_auxiliar = 1 then
        select sum(cglposteoaux1.debito-cglposteoaux1.credito) into ldc_saldo
        from cglposteo, cglposteoaux1
        where cglposteo.consecutivo = cglposteoaux1.consecutivo
        and cglposteo.fecha_comprobante <= ad_fecha
        and cglposteo.compania = as_compania
        and cglposteo.cuenta = as_cuenta
        and cglposteoaux1.auxiliar = as_auxiliar;
    else
        select sum(cglposteoaux2.debito-cglposteoaux2.credito) into ldc_saldo
        from cglposteo, cglposteoaux2
        where cglposteo.consecutivo = cglposteoaux2.consecutivo
        and cglposteo.fecha_comprobante <= ad_fecha
        and cglposteo.compania = as_compania
        and cglposteo.cuenta = as_cuenta
        and cglposteoaux2.auxiliar = as_auxiliar;
    end if;    
    
    if ldc_saldo is null then
        ldc_saldo = 0;
    end if;

   return ldc_saldo;
end;
' language plpgsql;
