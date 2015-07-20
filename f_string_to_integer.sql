
drop function f_string_to_integer(varchar(100)) cascade;

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


