drop function f_cerrar_aplicacion(char(2),char(3), int4, int4) cascade;

create function f_cerrar_aplicacion(char(2),char(3), int4, int4) returns integer as '
declare
    as_cia alias for $1;
    as_aplicacion alias for $2;
    ai_anio alias for $3;
    ai_mes alias for $4;
    r_work record;
    r_gralperiodos record;
    ii_next_year integer;
    ii_next_periodo integer;
    ls_sql varchar(300);
    ls_parametro varchar(20);
    lc_estado char(1);
begin

    select into r_gralperiodos *
    from gralperiodos
    where compania = as_cia
    and aplicacion = trim(as_aplicacion)
    and year = ai_anio
    and periodo = ai_mes;
    if not found then
        Raise Exception ''No existe Anio % y Mes % en %'',ai_anio, ai_mes, as_aplicacion;
    end if;

    if r_gralperiodos.estado <> ''A'' then
        return 0;
    end if;

    ii_next_year    = ai_anio;
    ii_next_periodo = ai_mes+1;

    if trim(as_aplicacion) = ''CGL'' then
        if ii_next_periodo > 13 then
            ii_next_periodo =   1;
            ii_next_year    =   ii_next_year + 1;
        end if;
    else
        if ii_next_periodo > 12 then
            ii_next_periodo =   1;
            ii_next_year    =   ii_next_year + 1;
        end if;
    end if;

    ls_parametro  =   ''anio_actual'';
    ls_sql	=	''update gralparaxcia set valor = '' 
                || trim(to_char(ii_next_year,''99999''))
                || '' where compania = '' || quote_literal(trim(as_cia)) 
                || '' and parametro = '' || quote_literal(trim(ls_parametro))
                || '' and aplicacion = '' || quote_literal(as_aplicacion);
    execute ls_sql;		
    
    ls_parametro  =   ''periodo_actual'';
    ls_sql	=	''update gralparaxcia set valor = '' 
                || trim(to_char(ii_next_periodo,''99999''))
                || '' where compania = '' || quote_literal(trim(as_cia)) 
                || '' and parametro = '' || quote_literal(trim(ls_parametro))
                || '' and aplicacion = '' || quote_literal(as_aplicacion);
    execute ls_sql;		
    
    
    lc_estado   =   ''I'';
    ls_sql	=	''update gralperiodos set ''
                || ''estado = '' || quote_literal(lc_estado)
                || ''where compania = '' || quote_literal(trim(as_cia)) 
                || '' and aplicacion = '' || quote_literal(trim(as_aplicacion))
                || '' and year = '' || trim(to_char(ai_anio, ''99999''))
                || '' and periodo = '' || trim(to_char(ai_mes,''99999''));
    execute ls_sql;		
   
    
  return 1;
end;
' language plpgsql;



/*
ls_sql			=	"update gralparaxcia set valor = " + string(ii_next_periodo) + &
						" where compania = '" + trim(gs_cia) + "' " + &
						"and parametro = 'periodo_actual' " + &
						"and aplicacion = '" + trim(gs_aplicacion) + "' "
sqlca.of_begin()
	execute immediate :ls_sql using sqlca;							
sqlca.of_commit()

ls_sql			=	"update gralperiodos set estado = 'I' " + &
						"where compania = '" + trim(gs_cia) + "' " + &
						"and aplicacion = '" + trim(gs_aplicacion) + "' " + &
						"and year = " + string(ii_year) + &
						" and periodo = " + string(ii_periodo)
sqlca.of_begin()
	execute immediate :ls_sql using sqlca;							
sqlca.of_commit()
*/
