drop function f_adc_manejo(char(2), int4, int4, int4, int4) cascade;

create function f_adc_manejo(char(2), int4, int4, int4, int4) returns decimal as '
declare
    as_compania alias for $1;
    ai_consecutivo alias for $2;
    ai_linea_master alias for $3;
    ai_linea_house alias for $4;
    ai_linea_manejo alias for $5;
    ldc_retorno decimal;
    r_work record;
begin
    ldc_retorno = 0;
    
    select into ldc_retorno cargo from adc_manejo
    where compania = as_compania
    and consecutivo = ai_consecutivo
    and linea_master = ai_linea_master
    and linea_house = ai_linea_house
    and linea_manejo = ai_linea_manejo;
    
    if ldc_retorno is null then
        ldc_retorno = 0;
    end if;
    
  
    
    return ldc_retorno;
end;
' language plpgsql;

