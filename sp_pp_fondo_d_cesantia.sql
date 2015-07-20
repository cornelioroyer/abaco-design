drop function f_pla_fondo_d_cesantia(int4,  date, date) cascade;


create function f_pla_fondo_d_cesantia(int4, date, date) returns integer as '
declare
    ai_cia alias for $1;
    ad_desde alias for $2;
    ad_hasta alias for $3;
    r_pla_empleados record;
    ldc_acumulados decimal;
    ldc_meses decimal;
    li_meses integer;
begin
    delete from pla_fondo_d_cesantia where compania = ai_cia;
    
    for r_pla_empleados in
        select * from pla_empleados
        where compania = ai_cia
        and status in (''A'',''V'',''I'')
        and tipo_contrato = ''P''
        and fecha_terminacion_real is null
        order by codigo_empleado
    loop
        select sum(monto) into ldc_acumulados from v_pla_acumulados
        where compania = r_pla_empleados.compania
        and codigo_empleado = r_pla_empleados.codigo_empleado
        and fecha between ad_desde and ad_hasta
        and concepto_calcula = ''220'';
        if ldc_acumulados is null then
            ldc_acumulados = 0;
        end if;
        

        if ldc_acumulados > 0 then
            ldc_meses   =   (((ad_hasta - ad_desde)+1) / 30);
            
/*            
            if r_pla_empleados.codigo_empleado = ''160019'' then
                raise exception ''% dias %'', li_meses, ldc_meses;
            end if;

if r_pla_empleados.codigo_empleado = ''160026'' then
    raise exception ''%'', ldc_meses;
end if;
*/

            if ldc_meses > 0 then
                insert into pla_fondo_d_cesantia (compania, codigo_empleado, desde, hasta,
                    salarios_acumulados, indemnizacion, prima)
                values(r_pla_empleados.compania, r_pla_empleados.codigo_empleado,
                    ad_desde, ad_hasta, ldc_acumulados/ldc_meses, (ldc_acumulados/52*3.4*0.05),
                    (ldc_acumulados/52));
            end if;
        end if;
    end loop;
    return 1;
end;
' language plpgsql;
