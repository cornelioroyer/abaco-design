

drop function f_monto_por_concepto(char(2), char(7), char(2), char(2), int4, int4, char(30), char(3), varchar(100)) cascade;
drop function f_defuncion(char(1)) cascade;

create function f_defuncion(char(1)) returns integer as '
declare
    as_status alias for $1;
    r_rhuempl record;
begin
    update nomacrem
    set status = as_status
    where cod_acreedores = ''DEFUNCION''
    
    if as_status <> ''A'' then
        return 1;
    end if;
    
    for r_rhuempl in select * from rhuempl
                        where not exists
                            (select * nomacrem
                                where compania = rhuempl.compania
                                and codigo_empleado = rhuempl.codigo_empleado
                                and cod_acreedores = ''DEFUNCION'')
                    order by codigo_empleado
    loop
        insert into nomacrem(compania, codigo_empleado, cod_concepto_planilla, numero_documento,
            cod_acreedores, descripcion_descuento, monto_original_deuda, letras_a_pagar,
            fecha_ini_descto, fecha_final_descto, status, observacion, hacer_cheque, incluir_deduc_
    end loop;
   
    return 1; 
end;
' language plpgsql;    


create function f_monto_por_concepto(char(2), char(7), char(2), char(2), int4, int4, char(30), char(3), varchar(100)) returns decimal(10,2) as '
declare
    ac_compania alias for $1;
    ac_codigo_empleado alias for $2;
    ac_tipo_calculo alias for $3;
    ac_tipo_planilla alias for $4;
    ai_year alias for $5;
    ai_numero_planilla alias for $6;
    ac_numero_documento alias for $7;
    ac_cod_concepto_planilla alias for $8;
    avc_retornar alias for $9;
    ldc_retorno decimal(10,2);
    r_nomctrac record;
    r_nomconce record;
begin

    ldc_retorno = 0;

    select into r_nomctrac *
    from nomctrac
    where compania = ac_compania
    and codigo_empleado = ac_codigo_empleado
    and tipo_calculo = ac_tipo_calculo
    and tipo_planilla = ac_tipo_planilla
    and year = ai_year
    and numero_planilla = ai_numero_planilla
    and numero_documento = ac_numero_documento
    and cod_concepto_planilla = ac_cod_concepto_planilla;

    select into r_nomconce *
    from nomconce
    where cod_concepto_planilla = ac_cod_concepto_planilla;

  
    if trim(avc_retornar) = ''NBONIF'' then
        if trim(ac_cod_concepto_planilla) = ''112'' then
            return r_nomctrac.monto * r_nomconce.signo;
        end IF;
        
    elsif trim(avc_retornar) = ''NSALSOB'' then
        if trim(ac_cod_concepto_planilla) = ''101'' then
            return r_nomctrac.monto * r_nomconce.signo;
        end IF;


    elsif trim(avc_retornar) = ''NBONO'' then
        if trim(ac_cod_concepto_planilla) = ''81'' then
            return r_nomctrac.monto * r_nomconce.signo;
        end IF;

    elsif trim(avc_retornar) = ''NOTROING'' then
        if trim(ac_cod_concepto_planilla) = ''140'' then
            return r_nomctrac.monto * r_nomconce.signo;
        end IF;

    elsif trim(avc_retornar) = ''NOTROING2'' then
        if trim(ac_cod_concepto_planilla) = ''142'' then
            return r_nomctrac.monto * r_nomconce.signo;
        end IF;

    elsif trim(avc_retornar) = ''NOTROING3'' then
        if trim(ac_cod_concepto_planilla) = ''250'' then
            return r_nomctrac.monto * r_nomconce.signo;
        end IF;

    elsif trim(avc_retornar) = ''NVAC'' then
        if trim(ac_cod_concepto_planilla) = ''108'' 
            or trim(ac_cod_concepto_planilla) = ''121''
            or trim(ac_cod_concepto_planilla) = ''300'' then
            return r_nomctrac.monto * r_nomconce.signo;
        end IF;

    elsif trim(avc_retornar) = ''NGRVAC'' then
        if trim(ac_cod_concepto_planilla) = ''107'' then
            return r_nomctrac.monto * r_nomconce.signo;
        end IF;
        
    elsif trim(avc_retornar) = ''NXIII'' then
        if trim(ac_cod_concepto_planilla) = ''240'' or
            trim(ac_cod_concepto_planilla) = ''109'' then
            return r_nomctrac.monto * r_nomconce.signo;
        end IF;
        
    elsif trim(avc_retornar) = ''NGRXIII'' then
        if trim(ac_cod_concepto_planilla) = ''125'' then
            return r_nomctrac.monto * r_nomconce.signo;
        end IF;
        
    elsif trim(avc_retornar) = ''NPRIMA'' then
        if trim(ac_cod_concepto_planilla) = ''220'' then
            return r_nomctrac.monto * r_nomconce.signo;
        end IF;
        
    elsif trim(avc_retornar) = ''NINDEM'' then
        if trim(ac_cod_concepto_planilla) = ''130'' or
            trim(ac_cod_concepto_planilla) = ''135'' then
            return r_nomctrac.monto * r_nomconce.signo;
        end IF;
        
    elsif trim(avc_retornar) = ''NGASTOREP'' then
        if trim(ac_cod_concepto_planilla) = ''200'' then
            return r_nomctrac.monto * r_nomconce.signo;
        end IF;

    elsif trim(avc_retornar) = ''NSS'' then
        if trim(ac_cod_concepto_planilla) = ''103''
            or trim(ac_cod_concepto_planilla) = ''102'' then
            return Abs(r_nomctrac.monto * r_nomconce.signo);
        end IF;
        
    elsif trim(avc_retornar) = ''NSE'' then
        if trim(ac_cod_concepto_planilla) = ''104'' then
            return Abs(r_nomctrac.monto * r_nomconce.signo);
        end IF;
        
    elsif trim(avc_retornar) = ''NISR'' then
        if trim(ac_cod_concepto_planilla) = ''106'' then
            return Abs(r_nomctrac.monto * r_nomconce.signo);
        end IF;
        
    elsif trim(avc_retornar) = ''NISRGTORE'' then
        if trim(ac_cod_concepto_planilla) = ''310'' then
            return Abs(r_nomctrac.monto * r_nomconce.signo);
        end IF;

    elsif trim(avc_retornar) = ''NGRATIF'' then
        if trim(ac_cod_concepto_planilla) = ''260'' then
            return r_nomctrac.monto * r_nomconce.signo;
        end IF;

    elsif trim(avc_retornar) = ''NBONIF'' then
        if trim(ac_cod_concepto_planilla) = ''112'' then
            return r_nomctrac.monto * r_nomconce.signo;
        end IF;

    elsif trim(ac_cod_concepto_planilla) = ''100''
            or trim(ac_cod_concepto_planilla) = ''105''
            or trim(ac_cod_concepto_planilla) = ''110''
            or trim(ac_cod_concepto_planilla) = ''111'' 
            or trim(ac_cod_concepto_planilla) = ''115''
            or trim(ac_cod_concepto_planilla) = ''116''
            or trim(ac_cod_concepto_planilla) = ''117''
            or trim(ac_cod_concepto_planilla) = ''126''
            or trim(ac_cod_concepto_planilla) = ''145''
            or trim(ac_cod_concepto_planilla) = ''160'' 
            or trim(ac_cod_concepto_planilla) = ''190''
            or trim(ac_cod_concepto_planilla) = ''195''
            or trim(ac_cod_concepto_planilla) = ''250''
            or trim(ac_cod_concepto_planilla) = ''251''
            or trim(ac_cod_concepto_planilla) = ''270''
            or trim(ac_cod_concepto_planilla) = ''280''
            or trim(ac_cod_concepto_planilla) = ''320'' then
            return r_nomctrac.monto * r_nomconce.signo;

    end if;

     
    return ldc_retorno;
end;
' language plpgsql;    

/*
    
    





    end if;    
  
*/   
