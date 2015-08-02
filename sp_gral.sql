

set search_path to dba;

drop function f_gralparaxcia(char(2), char(3), char(20));
drop function f_gralparaxapli(char(3), char(20));
drop function f_abrir_periodos(char(2), int4, int4);
drop function mes(date) cascade;
drop function anio(date) cascade;
drop function today() cascade;
drop function f_valida_fecha(char(2), char(3), date) cascade;
drop function f_supervisor(char(30)) cascade;
drop function f_mes(integer) cascade;
drop function f_timestamp(date, time) cascade;
drop function f_to_date(integer, integer, integer) cascade;
drop function f_intervalo(timestamp, timestamp) cascade;
drop function f_text_to_char_20(text) cascade;
drop function f_bitacora(text, text, text, text,  text) cascade;
drop function f_string_to_decimal(varchar(100)) cascade;
drop function f_string_to_integer(varchar(100)) cascade;
drop function f_caja_default(char(2)) cascade;
drop function f_abaco_control_de_cierre(char(2), char(30), date) cascade;

create function f_abaco_control_de_cierre(char(2), char(30), date) returns integer as '
declare
    ac_compania alias for $1;
    ac_usuario alias for $2;
    ad_fecha alias for $3;
    r_abaco_control_de_cierre record;
begin

    select into r_abaco_control_de_cierre *
    from abaco_control_de_cierre
    where ad_fecha <= fecha;
    if found then
        select into r_abaco_control_de_cierre *
        from abaco_control_de_cierre
        where ad_fecha <= fecha
        and trim(ac_usuario) = trim(usuario);
        if not found then
            Raise Exception ''Fecha % corresponde a un periodo cerrado usuario %'',ad_fecha, ac_usuario;
        end if;
    end if;

    return 1;
end;
' language plpgsql;




create function f_caja_default(char(2)) returns char(3) as '
declare
    as_almacen alias for $1;
    r_fac_cajas record;
begin
    for r_fac_cajas in select * from fac_cajas where almacen = as_almacen
                        order by caja
    loop
        return r_fac_cajas.caja;
    end loop;
    
    return '''';
end;
' language plpgsql;




create function f_string_to_integer(varchar(100)) returns integer as '
declare
    avc_numero alias for $1;
    li_largo integer;
    i integer;
    ldc_retorno decimal;
    ldc_decimales decimal;
    ldc_entero decimal;
    lc_work char(1);
    lvc_numero varchar(100);
    lvc_entero varchar(100);
    lvc_decimal varchar(100);
    ldc_work decimal;
    li_entero integer;
begin
    ldc_retorno =   0;
    li_largo    =   Length(trim(avc_numero));
    i           =   0;
    lvc_numero  =   null;
    li_entero   =   1;
    
    for i in 1..li_largo loop
        lc_work =   Substring(trim(avc_numero) from i for 1);
        
        if lc_work = ''0'' or lc_work = ''1'' or lc_work = ''2'' or lc_work = ''3''
            or lc_work = ''4'' or lc_work = ''5'' or lc_work = ''6'' or lc_work = ''7''
            or lc_work = ''8'' or lc_work = ''9'' then
            
            if lvc_entero is null then
                lvc_entero  =   lc_work;
            else
                lvc_entero  =   trim(lvc_entero) || lc_work;
            end if;
        end if;
    end loop;

    li_entero        =   to_number(lvc_entero, ''9999999999999'');

    return li_entero;
end;
' language plpgsql;



create function f_string_to_decimal(varchar(100)) returns decimal as '
declare
    avc_numero alias for $1;
    li_largo integer;
    i integer;
    ldc_retorno decimal;
    ldc_decimales decimal;
    ldc_entero decimal;
    lc_work char(1);
    lvc_numero varchar(100);
    lvc_entero varchar(100);
    lvc_decimal varchar(100);
    ldc_work decimal;
    li_entero integer;
begin
    ldc_retorno =   0;
    li_largo    =   Length(trim(avc_numero));
    i           =   0;
    lvc_numero  =   null;
    li_entero   =   1;
    
    for i in 1..li_largo loop
        lc_work =   Substring(trim(avc_numero) from i for 1);
        
        if lc_work = ''.'' then
            li_entero = 0;
            continue;
        end if;
        
        if lc_work = ''0'' or lc_work = ''1'' or lc_work = ''2'' or lc_work = ''3''
            or lc_work = ''4'' or lc_work = ''5'' or lc_work = ''6'' or lc_work = ''7''
            or lc_work = ''8'' or lc_work = ''9'' then
            
            if li_entero = 1 then
                if lvc_entero is null then
                    lvc_entero  =   lc_work;
                else
                    lvc_entero  =   trim(lvc_entero) || lc_work;
                end if;
            else
                if lvc_decimal is null then
                    lvc_decimal  =   lc_work;
                else
                    lvc_decimal  =   trim(lvc_decimal) || lc_work;
                end if;
            end if;
        end if;
    end loop;

    ldc_work        =   to_number(lvc_decimal, ''9999999999999'');
    ldc_decimales   =   ldc_work/100;
    
    ldc_entero      =   to_number(lvc_entero, ''9999999999999'');
    
    ldc_retorno     =   ldc_entero + ldc_decimales;
           
--    ldc_retorno  =   Cast(lvc_numero as decimal(15,2));
    
--    raise exception ''%'',ldc_retorno;
    return Round(ldc_retorno,2);
end;
' language plpgsql;




create function f_bitacora(text, text, text, text, text) returns int4 as '
declare
    ac_operacion alias for $1;
    at_tabla alias for $2;
    at_old_dato alias for $3;
    at_new_dato alias for $4;
    at_sentencia_sql alias for $5;
begin
    
    insert into bitacora(operacion, tabla, fecha_hora,
        usuario, old_dato, new_dato, sentencia_sql) 
    values (trim(ac_operacion), trim(at_tabla), current_timestamp,
        current_user, at_old_dato, at_new_dato, at_sentencia_sql);
        
    return 1;
end;
' language plpgsql;




create function f_text_to_char_20(text) returns char(20) as '
declare
    as_text alias for $1;
    lc_retorno char(20);
begin
    lc_retorno  =   trim(as_text);
    return lc_retorno;
end;
' language plpgsql;



create function f_intervalo(timestamp, timestamp) returns int4 as '
declare
    adt_desde alias for $1;
    adt_hasta alias for $2;
    lt_diferencia interval;
    li_minutos int4;
    li_work int4;
begin
    if adt_desde > adt_hasta then
        return 0;
    end if;
    
    if adt_desde is null or adt_hasta is null then
        return 0;
    end if;
    
    li_minutos = 0;
    lt_diferencia = adt_hasta - adt_desde;
    li_minutos = (extract(days from lt_diferencia)*24*60) + extract(minutes from lt_diferencia) + (extract(hour from lt_diferencia)*60);
    return li_minutos;
end;
' language plpgsql;



create function f_to_date(integer, integer, integer) returns date as '
declare
    ai_y alias for $1;
    ai_m alias for $2;
    ai_d alias for $3;
    ls_fecha char(10);
begin
    ls_fecha = trim(to_char(ai_y,''9999'')) || ''/'' || trim(to_char(ai_m,''09'')) || ''/'' || trim(to_char(ai_d,''09''));
    return to_date(ls_fecha, ''YYYY/MM/DD'');
end;
' language plpgsql;


create function f_timestamp(date, time) returns timestamp as '
declare
    ad_fecha alias for $1;
    at_hora alias for $2;
    ls_fecha char(10);
    ls_hora char(11);
    ls_fecha_hora char(23);
    ldt_fechahora timestamp;
begin
--    raise exception ''entre'';
    
    ls_fecha = ad_fecha;
    ls_hora = at_hora;
    ls_fecha_hora = trim(ls_fecha) || ''  '' || trim(ls_hora);

--    raise exception ''%'', ls_fecha_hora;
        
    ldt_fechahora = to_timestamp(ls_fecha_hora,''YYYY-MM-DD HH24:MI:SS'');

    return ldt_fechahora;
end;
' language plpgsql;


create function f_mes(integer) returns char(30) as '
declare
    ai_mes alias for $1;
    ls_mes char(30);
begin
    if ai_mes = 1 then
        ls_mes = ''Enero'';
    elsif ai_mes = 2 then
            ls_mes = ''Febrero'';
    elsif ai_mes = 3 then
            ls_mes = ''Marzo'';
    elsif ai_mes = 4 then
            ls_mes = ''Abril'';
    elsif ai_mes = 5 then
            ls_mes = ''Mayo'';
    elsif ai_mes = 6 then
            ls_mes = ''Junio'';
    elsif ai_mes = 7 then
            ls_mes = ''Julio'';
    elsif ai_mes = 8 then
            ls_mes = ''Agosto'';
    elsif ai_mes = 9 then
            ls_mes = ''Septiembre'';
    elsif ai_mes = 10 then
            ls_mes = ''Octubre'';
    elsif ai_mes = 11 then
            ls_mes = ''Noviembre'';
    else
        ls_mes = ''Diciembre'';
    end if;

    return Trim(ls_mes);
end;
' language plpgsql;



create function anio(date) returns float
as 'select extract("year" from $1) as anio' language 'sql';

create function mes(date) returns float
as 'select extract("month" from $1) as mes' language 'sql';

create function today() returns date
as 'select current_date as fecha' language 'sql';



create function f_valida_fecha(char(2), char(3), date) returns integer as '
declare
    as_cia alias for $1;
    as_aplicacion alias for $2;
    ad_fecha alias for $3;
    r_gralperiodos record;
begin
    select into r_gralperiodos * from gralperiodos
    where compania = as_cia
    and aplicacion = as_aplicacion
    and ad_fecha between inicio and final
    and estado = ''A'';
    if found then
        return 1;
    end if;

    select into r_gralperiodos * from gralperiodos
    where compania = as_cia
    and aplicacion = as_aplicacion
    and ad_fecha between inicio and final;
    if not found then
        Raise Exception ''No Existe Periodo en la fecha % en la aplicacion % de la cia %'',ad_fecha, as_aplicacion, as_cia;
    end if;
    
    select into r_gralperiodos * from gralperiodos
    where compania = as_cia
    and aplicacion = as_aplicacion
    and ad_fecha between inicio and final
    and estado = ''I'';
    if found then
        Raise Exception ''Fecha % en la aplicacion % de la cia % corresponde a un periodo cerrado...Verifique'',ad_fecha, as_aplicacion, as_cia;
    end if;
    
    select into r_gralperiodos * from gralperiodos
    where compania = as_cia
    and aplicacion = ''CGL''
    and ad_fecha between inicio and final
    and estado = ''I'';
    if found then
        Raise Exception ''Fecha % en la aplicacion CGL de la cia % corresponde a un periodo cerrado...Verifique'',ad_fecha, as_cia;
    end if;
    
    return 1;
end;
' language plpgsql;


create function f_supervisor(char(30)) returns boolean as '
declare
    as_usuario alias for $1;
    r_gral_usuarios record;
begin
    select into r_gral_usuarios * from gral_usuarios
    where trim(usuario) = trim(as_usuario)
    and supervisor = ''S'';
    if found then
        return true;
    else
        return false;
    end if;
end;
' language plpgsql;



create function f_abrir_periodos(char(2), int4, int4) returns integer as '
declare
    as_cia alias for $1;
    ai_year alias for $2;
    ai_periodo alias for $3;
begin
    update gralperiodos
    set estado = ''I''
    where compania = as_cia;
    
    update gralperiodos 
    set estado = ''A''
    where compania = as_cia
    and year = ai_year
    and periodo >= ai_periodo;
    
    update gralperiodos 
    set estado = ''A''
    where compania = as_cia
    and year > ai_year;
    
    update gralparaxcia
    set valor = ai_year
    where compania = as_cia
    and parametro = ''anio_actual'';

    update gralparaxcia
    set valor = ai_periodo
    where compania = as_cia
    and parametro = ''periodo_actual'';

    update gralparaxcia
    set valor = ''0''
    where parametro = ''sec_comprobante'';
    
    update invparal
    set valor = ''S''
    where parametro = ''valida_existencias'';
    
    update invparal
    set valor = ''0''
    where parametro = ''sec_eys'';

    return 1;
end;
' language plpgsql;



create function f_gralparaxapli(char(3), char(20)) returns char(20) as '
declare
    as_aplicacion alias for $1;
    as_parametro alias for $2;
    r_gralparaxapli record;
begin
    select into r_gralparaxapli * from gralparaxapli
    where aplicacion = as_aplicacion
    and parametro = as_parametro;
    if not found then
        Raise Exception ''Parametro % No Existe en la aplicacion % gralparaxapli'',as_parametro, as_aplicacion;
    end if;

    return Trim(r_gralparaxapli.valor);
end;
' language plpgsql;


create function f_gralparaxcia(char(2), char(3), char(20)) returns char(60) as '
declare
    as_compania alias for $1;
    as_aplicacion alias for $2;
    as_parametro alias for $3;
    ls_retorno char(60);
begin
    select into ls_retorno valor from gralparaxcia
    where compania = as_compania
    and aplicacion = as_aplicacion
    and parametro = as_parametro;
    if not found then
       Raise Exception ''Parametro % no Existen en la Aplicacion % de la Cia %'',as_parametro,as_aplicacion,as_compania;
    end if;
    
    return trim(ls_retorno);
end;
' language plpgsql;
