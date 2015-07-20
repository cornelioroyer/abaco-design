drop function f_bco_conciliacion(char(2), date, date) cascade;

create function f_bco_conciliacion(char(2), date, date) returns integer as '
declare
    ac_cod_ctabco alias for $1;
    ad_desde alias for $2;
    ad_hasta alias for $3;
    r_bco_conciliacion_tmp record;
    r_bco_conciliacion record;
    r_bcocircula record;
    r_bcoctas record;
    lvc_work varchar(100);
    ld_fecha date;
    ld_ultimo_cierre date;
    li_anio integer;
    li_mes integer;
    li_dia integer;
    ldc_debito decimal;
    ldc_credito decimal;
begin
    delete from bco_conciliacion;
    
    select into r_bcoctas *
    from bcoctas
    where trim(cod_ctabco) = trim(ac_cod_ctabco);
    
    select Max(final) into ld_ultimo_cierre
    from gralperiodos
    where compania = r_bcoctas.compania
    and aplicacion = ''BCO''
    and estado = ''I'';
    
 
    for r_bco_conciliacion_tmp in select * 
                    from bco_conciliacion_tmp
                    order by id
    loop
        lvc_work    =   Trim(r_bco_conciliacion_tmp.c1);
        li_dia      =   substring(lvc_work from 1 for 2);
        li_mes      =   substring(lvc_work from 4 for 2);
        li_anio     =   substring(lvc_work from 7 for 4);
/*
        if trim(ac_cod_ctabco) = ''6'' then
            li_anio     =   substring(lvc_work from 7 for 2);
            li_anio     =   li_anio + 2000;
        end if;
*/        
        ld_fecha                    =   f_to_date(li_anio, li_mes, li_dia);
        
        
        ldc_debito  =   to_number(trim(r_bco_conciliacion_tmp.c5), ''9999999.99'');
        ldc_credito =   to_number(trim(r_bco_conciliacion_tmp.c6), ''9999999.99'');
        
        if ld_fecha < ad_desde then
            continue;
        end if;
        
        if ldc_debito is null then
            ldc_debito = 0;
        end if;
        
        if ldc_credito is null then
            ldc_credito = 0;
        end if; 
       
        if r_bco_conciliacion_tmp.c2 is null then
            r_bco_conciliacion_tmp.c2 = ''  '';
        end if;
                
        insert into bco_conciliacion(cod_ctabco, fecha,
            descripcion, documento, debito, credito, conciliado)
        values (ac_cod_ctabco, ld_fecha, 
            trim(r_bco_conciliacion_tmp.c2),
            trim(r_bco_conciliacion_tmp.c3),
            ldc_debito, ldc_credito, ''N'');
            
    end loop;        
    

    for r_bco_conciliacion in select * 
                    from bco_conciliacion
                    order by id
    loop
        select into r_bcocircula *
        from bcocircula
        where cod_ctabco = ac_cod_ctabco
        and Trim(to_char(bcocircula.no_docmto_sys, ''99999'')) = trim(r_bco_conciliacion.documento)
        and monto = r_bco_conciliacion.debito
        and status <> ''C''
        and fecha_posteo = r_bco_conciliacion.fecha;
        if found then
            update bco_conciliacion
            set conciliado = ''S''
            where id = r_bco_conciliacion.id;
            
            update bcocircula
            set status = ''C'', fecha_conciliacion = r_bco_conciliacion.fecha
            where cod_ctabco = ac_cod_ctabco
            and motivo_bco = r_bcocircula.motivo_bco
            and no_docmto_sys = r_bcocircula.no_docmto_sys
            and fecha_posteo = r_bcocircula.fecha_posteo;
            
            continue;
        end if;

                
        select into r_bcocircula *
        from bcocircula, bcomotivos
        where bcocircula.motivo_bco = bcomotivos.motivo_bco
        and bcomotivos.signo = 1
        and cod_ctabco = ac_cod_ctabco
        and status <> ''C''
        and monto = r_bco_conciliacion.credito
        and fecha_posteo = r_bco_conciliacion.fecha;
        if found then
            update bcocircula
            set status = ''C'', fecha_conciliacion = r_bco_conciliacion.fecha
            where cod_ctabco = r_bcocircula.cod_ctabco
            and motivo_bco = r_bcocircula.motivo_bco
            and no_docmto_sys = r_bcocircula.no_docmto_sys
            and fecha_posteo = r_bcocircula.fecha_posteo;

            update bco_conciliacion
            set conciliado = ''S''
            where id = r_bco_conciliacion.id;
        end if;
        
        select into r_bcocircula *
        from bcocircula, bcomotivos
        where bcocircula.motivo_bco = bcomotivos.motivo_bco
        and bcomotivos.signo = -1
        and cod_ctabco = ac_cod_ctabco
        and monto = r_bco_conciliacion.debito
        and status <> ''C''
        and fecha_posteo = r_bco_conciliacion.fecha;
        if found then
            update bcocircula
            set status = ''C'', fecha_conciliacion = r_bco_conciliacion.fecha
            where cod_ctabco = r_bcocircula.cod_ctabco
            and motivo_bco = r_bcocircula.motivo_bco
            and no_docmto_sys = r_bcocircula.no_docmto_sys
            and fecha_posteo = r_bcocircula.fecha_posteo;

            update bco_conciliacion
            set conciliado = ''S''
            where id = r_bco_conciliacion.id;
        end if;
        

    end loop;

    
    return 1;
end;
' language plpgsql;
