drop function f_balance_nomacrem(char(2), char(7), char(3), char(30)) cascade;
drop function f_deduccion_mensual(char(2), char(7), char(3), char(30)) cascade;

create function f_balance_nomacrem(char(2), char(7), char(3), char(30)) returns decimal(10,2) as '
declare
    ac_compania alias for $1;
    ac_codigo_empleado alias for $2;
    ac_cod_concepto_planilla alias for $3;
    ac_numero_documento alias for $4;
    ldc_retorno decimal(10,2);
    r_nomacrem record;
    r_pla_afectacion_contable record;
begin

    ldc_retorno = 0;

    select into r_nomacrem *
    from nomacrem
    where compania = ac_compania
    and codigo_empleado = ac_codigo_empleado
    and cod_concepto_planilla = ac_cod_concepto_planilla
    and numero_documento = ac_numero_documento;
    if not found then
        return 0;
    end if;

        
    if r_nomacrem.hacer_cheque = ''S'' then
        select into ldc_retorno sum(nomctrac.monto)
        from nomctrac, nomdescuentos, nomtpla2
        where nomctrac.codigo_empleado = nomdescuentos.codigo_empleado
        and nomctrac.compania = nomdescuentos.compania
        and nomctrac.tipo_calculo = nomdescuentos.tipo_calculo
        and nomctrac.cod_concepto_planilla = nomdescuentos.cod_concepto_planilla
        and nomctrac.tipo_planilla = nomdescuentos.tipo_planilla
        and nomctrac.numero_planilla = nomdescuentos.numero_planilla
        and nomctrac.year = nomdescuentos.year
        and nomctrac.numero_documento = nomdescuentos.numero_documento
        and nomctrac.tipo_planilla = nomtpla2.tipo_planilla
        and nomctrac.numero_planilla = nomtpla2.numero_planilla
        and nomctrac.year = nomtpla2.year
        and nomdescuentos.numero_documento = r_nomacrem.numero_documento
        and nomdescuentos.codigo_empleado = r_nomacrem.codigo_empleado
        and nomdescuentos.cod_concepto_planilla = r_nomacrem.cod_concepto_planilla
        and nomdescuentos.compania = r_nomacrem.compania;
        if ldc_retorno is null then
            ldc_retorno = 0;
        end if;
        
        if r_nomacrem.monto_original_deuda <= 0 then
            return 0;
        else
            return r_nomacrem.monto_original_deuda - ldc_retorno;
        end if;
    
    else
        select into r_pla_afectacion_contable *
        from pla_afectacion_contable
        where cod_concepto_planilla = r_nomacrem.cod_concepto_planilla;

        select into ldc_retorno sum(saldo) 
        from cgl_saldo_aux1
        where compania = ac_compania
        and cuenta = r_pla_afectacion_contable.cuenta
        and auxiliar = ac_codigo_empleado;
        
        if ldc_retorno is null then
            ldc_retorno = 0;
        end if;
        
        return ldc_retorno;
        

        
    end if;
    
    return ldc_retorno;
end;
' language plpgsql;    


create function f_deduccion_mensual(char(2), char(7), char(3), char(30)) returns decimal(10,2) as '
declare
    ac_compania alias for $1;
    ac_codigo_empleado alias for $2;
    ac_cod_concepto_planilla alias for $3;
    ac_numero_documento alias for $4;
    ldc_retorno decimal(10,2);
    r_nomacrem record;
    r_pla_afectacion_contable record;
    r_nomdedu record;
begin

    ldc_retorno = 0;

    select into r_nomacrem *
    from nomacrem
    where compania = ac_compania
    and codigo_empleado = ac_codigo_empleado
    and cod_concepto_planilla = ac_cod_concepto_planilla
    and numero_documento = ac_numero_documento;
    if not found then
        return 0;
    end if;

    if r_nomacrem.tipo_descuento = ''P'' then
        select into r_nomdedu *
        from nomdedu
        where compania = ac_compania
        and codigo_empleado = ac_codigo_empleado
        and cod_concepto_planilla = ac_cod_concepto_planilla
        and numero_documento = ac_numero_documento;
        if not found then
            return 0;
        else
            return r_nomdedu.monto;
        end if;
    else
        select into ldc_retorno sum(monto)
        from nomdedu
        where compania = ac_compania
        and codigo_empleado = ac_codigo_empleado
        and cod_concepto_planilla = ac_cod_concepto_planilla
        and numero_documento = ac_numero_documento;
        if ldc_retorno is null then
            ldc_retorno = 0;
        end if;
    end if;    
    return ldc_retorno;
end;
' language plpgsql;    


