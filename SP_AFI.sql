drop function f_afi_cglposteo(char(2), int4, int4) cascade;
drop function f_rela_afi_cglposteo_delete() cascade;
drop function f_rela_activos_cglposteo_delete() cascade;
drop function f_sec_activo(char(2));
drop function f_activos_cglposteo(char(2), char(15));
drop function f_activos_after_update() cascade;
drop function f_postea_afi(char(2)) cascade;
drop function f_rela_afi_trx1_cglposteo_after_delete() cascade;
drop function f_afi_trx2_after_update() cascade;
drop function f_afi_trx2_after_delete() cascade;
drop function f_afi_trx1_after_update() cascade;
drop function f_afi_trx1_cglposteo(char(2), int4) cascade;
drop function f_cerrar_afi(char(2),int4, int4) cascade;


create function f_cerrar_afi(char(2),int4, int4) returns integer as '
declare
    as_cia alias for $1;
    ai_anio alias for $2;
    ai_mes alias for $3;
    r_work record;
    r_gralperiodos record;
begin

    select into r_gralperiodos *
    from gralperiodos
    where compania = as_cia
    and aplicacion = ''AFI''
    and year = ai_anio
    and periodo = ai_mes;
    if not found then
        Raise Exception ''No existe Anio % y Mes % en Inventario'',ai_anio, ai_mes;
    end if;
    
    if r_gralperiodos.estado <> ''A'' then
        return 0;
    end if;

    return f_cerrar_aplicacion(as_cia, ''AFI'', ai_anio, ai_mes);
end;
' language plpgsql;    


create function f_postea_afi(char(2)) returns integer as '
declare
    as_cia alias for $1;
    ld_fecha date;
    i integer;
    r_bcocheck1 record;
    r_bcotransac1 record;
    r_afi_trx1 record;
    r_activos record;
    r_gralperiodos record;
begin
    select into ld_fecha Min(inicio) from gralperiodos
    where compania = as_cia
    and aplicacion = ''CGL''
    and estado = ''A'';
    if not found then
        return 0;
    end if;
    
    if Trim(f_gralparaxcia(as_cia, ''AFI'',''postea_online'')) = ''S'' then
        for r_activos in select * from activos
                            where compania = as_cia
                            and fecha_compra >= ld_fecha
                            and status <> ''V''
                            and not exists
                                (select * from rela_activos_cglposteo
                                    where rela_activos_cglposteo.compania = activos.compania
                                    and rela_activos_cglposteo.codigo = activos.codigo)
                            order by fecha_compra
        loop
            i   =   f_activos_cglposteo(r_activos.compania, r_activos.codigo);
        end loop;                            
    end if;
    
    for r_gralperiodos in select * from gralperiodos
                            where compania = as_cia
                            and inicio >= ld_fecha
                            and aplicacion = ''AFI''
                          order by inicio
    loop
        i = f_afi_cglposteo(r_gralperiodos.compania, r_gralperiodos.year, r_gralperiodos.periodo);
    end loop;                          
    
    for r_afi_trx1 in select * from afi_trx1
                    where compania = as_cia
                    and fecha >= ld_fecha
                    and not exists
                        (select * from rela_afi_trx1_cglposteo
                        where rela_afi_trx1_cglposteo.compania = afi_trx1.compania
                        and rela_afi_trx1_cglposteo.no_trx = afi_trx1.no_trx)
                    order by fecha
    loop
        i := f_afi_trx1_cglposteo(r_afi_trx1.compania, r_afi_trx1.no_trx);
    end loop;        
    
    
return 1;
    
end;
' language plpgsql;    



create function f_afi_trx1_cglposteo(char(2), int4) returns integer as '
declare
    as_cia alias for $1;
    ai_no_trx alias for $2;
    li_consecutivo int4;
    r_afi_tipo_activo record;
    r_afi_trx1 record;
    r_afi_trx2 record;
    ldc_monto1 decimal(10,2);
begin
    delete from rela_afi_trx1_cglposteo
    where compania = as_cia
    and no_trx = ai_no_trx;

    
    select into r_afi_trx1 * from afi_trx1
    where compania = as_cia
    and no_trx = ai_no_trx;
    if not found then
        return 0;
    end if;

    
    select into ldc_monto1 sum(monto) from afi_trx2
    where compania = as_cia
    and no_trx = ai_no_trx;
    if ldc_monto1 is null then
        ldc_monto1 := 0;
    end if;        
    

    select into r_afi_tipo_activo afi_tipo_activo.* from activos, afi_tipo_activo
    where activos.tipo_activo = afi_tipo_activo.codigo
    and activos.compania = as_cia
    and activos.codigo = r_afi_trx1.codigo;
    if not found then
        return 0;
    end if;


    if r_afi_trx1.costo <> 0 then
        li_consecutivo := f_cglposteo(as_cia, ''AFI'', 
                                r_afi_trx1.fecha,
                                r_afi_tipo_activo.cuenta_activo, null, null,
                                r_afi_tipo_activo.tipo_comp, r_afi_trx1.observacion,
                                r_afi_trx1.costo);
        if li_consecutivo > 0 then
            insert into rela_afi_trx1_cglposteo (consecutivo, compania, no_trx)
            values (li_consecutivo, r_afi_trx1.compania, r_afi_trx1.no_trx);
        end if;
    end if;
    
    if r_afi_trx1.depreciacion <> 0 then
        li_consecutivo := f_cglposteo(as_cia, ''AFI'', 
                                r_afi_trx1.fecha,
                                r_afi_tipo_activo.cuenta_depreciacion, null, null,
                                r_afi_tipo_activo.tipo_comp, r_afi_trx1.observacion,
                                r_afi_trx1.depreciacion);
        if li_consecutivo > 0 then
            insert into rela_afi_trx1_cglposteo (consecutivo, compania, no_trx)
            values (li_consecutivo, r_afi_trx1.compania, r_afi_trx1.no_trx);
        end if;
    end if;
    
    if r_afi_trx1.gasto <> 0 then
        li_consecutivo := f_cglposteo(as_cia, ''AFI'', 
                                r_afi_trx1.fecha,
                                r_afi_tipo_activo.cuenta_gasto, null, null,
                                r_afi_tipo_activo.tipo_comp, r_afi_trx1.observacion,
                                r_afi_trx1.gasto);
        if li_consecutivo > 0 then
            insert into rela_afi_trx1_cglposteo (consecutivo, compania, no_trx)
            values (li_consecutivo, r_afi_trx1.compania, r_afi_trx1.no_trx);
        end if;
    end if;
   
    for r_afi_trx2 in select * from afi_trx2
                    where compania = as_cia
                    and no_trx = ai_no_trx
                    order by linea
    loop
        li_consecutivo := f_cglposteo(as_cia, ''AFI'', 
                                r_afi_trx1.fecha,
                                r_afi_trx2.cuenta, r_afi_trx2.auxiliar, null,
                                r_afi_tipo_activo.tipo_comp, r_afi_trx1.observacion,
                                r_afi_trx2.monto);
        if li_consecutivo > 0 then
            insert into rela_afi_trx1_cglposteo (consecutivo, compania, no_trx)
            values (li_consecutivo, r_afi_trx1.compania, r_afi_trx1.no_trx);
        end if;
    end loop;
    
    return 1;
end;
' language plpgsql;



create function f_activos_cglposteo(char(2), char(15)) returns integer as '
declare
    as_compania alias for $1;
    as_codigo alias for $2;
    ls_cta_pte_activos char(24);
    r_afi_tipo_activo record;    
    r_activos record;
    li_consecutivo int4;
    ls_descripcion char(200);
begin
    ls_cta_pte_activos  =   Trim(f_gralparaxcia(as_compania, ''AFI'', ''cta_pte_activos''));

    delete from rela_activos_cglposteo
    where compania = as_compania
    and codigo = as_codigo;
    
    select into r_activos * from activos
    where compania = as_compania
    and codigo = as_codigo;
    
    select into r_afi_tipo_activo * from afi_tipo_activo
    where codigo = r_activos.tipo_activo;
    
    ls_descripcion = trim(r_activos.descripcion) || ''  '' || trim(r_activos.codigo);

    li_consecutivo := f_cglposteo(as_compania, ''AFI'', r_activos.fecha_compra,
                        trim(ls_cta_pte_activos), null, null,
                        r_afi_tipo_activo.tipo_comp, trim(ls_descripcion) , -r_activos.costo_inicial);
                        
    if li_consecutivo > 0 then
       insert into rela_activos_cglposteo (consecutivo, codigo, compania)
       values (li_consecutivo, as_codigo, as_compania);
    end if;
    
    li_consecutivo := f_cglposteo(as_compania, ''AFI'', r_activos.fecha_compra,
                        trim(r_afi_tipo_activo.cuenta_activo), null, null,
                        r_afi_tipo_activo.tipo_comp, trim(ls_descripcion) , r_activos.costo_inicial);
                        
    if li_consecutivo > 0 then
       insert into rela_activos_cglposteo (consecutivo, codigo, compania)
       values (li_consecutivo, as_codigo, as_compania);
    end if;
    
    
    return 1;    
end;
' language plpgsql;

create function f_sec_activo(char(2)) returns char(4) as '
declare
    as_compania alias for $1;
    ls_retornar char(4);
    r_work record;
    secuencia int4;
begin
    secuencia := to_number(f_gralparaxapli(''AFI'',''sec_activo''),''9999999999'');
    
    loop
        secuencia := secuencia + 1;
        ls_retornar := trim(to_char(secuencia,''0009''));
        
        select into r_work * from activos
        where compania = as_compania
        and codigo = ls_retornar;
        if not found then
            exit;
        end if;
    end loop;
    
    update gralparaxapli
    set valor = trim(to_char(secuencia,''999999999''))
    where parametro = ''sec_activo''
    and aplicacion = ''AFI'';
    
    return Trim(ls_retornar);
end;
' language plpgsql;




create function f_afi_cglposteo(char(2), int4, int4) returns integer as '
declare
    as_compania alias for $1;
    ai_year alias for $2;
    ai_periodo alias for $3;
    li_consecutivo int4;
    r_work record;
begin
    delete from rela_afi_cglposteo
    where compania = as_compania
    and year = ai_year
    and periodo = ai_periodo;
    
    for r_work in select afi_tipo_activo.cuenta_gasto, afi_tipo_activo.cuenta_depreciacion, 
                         afi_tipo_activo.descripcion, afi_tipo_activo.tipo_comp, 
                         gralperiodos.final, Round(sum(afi_depreciacion.depreciacion),2) as monto
                    from activos, afi_tipo_activo, afi_depreciacion, gralperiodos
                    where activos.tipo_activo = afi_tipo_activo.codigo
                    and activos.compania = afi_depreciacion.compania
                    and activos.codigo = afi_depreciacion.codigo
                    and afi_depreciacion.compania = gralperiodos.compania
                    and afi_depreciacion.aplicacion = gralperiodos.aplicacion
                    and afi_depreciacion.year = gralperiodos.year
                    and afi_depreciacion.periodo = gralperiodos.periodo
                    and afi_depreciacion.compania = as_compania
                    and afi_depreciacion.year = ai_year
                    and afi_depreciacion.periodo = ai_periodo
                    group by 1, 2, 3, 4, 5
                    order by 1, 2, 3, 4
    loop

        li_consecutivo = f_cglposteo(as_compania, ''AFI'', r_work.final,
                            r_work.cuenta_gasto, null, null,
                            r_work.tipo_comp, trim(r_work.descripcion), Round(r_work.monto,2));
                                    
        if li_consecutivo > 0 then
           insert into rela_afi_cglposteo (codigo, compania, aplicacion, year, periodo, consecutivo)
            (select afi_depreciacion.codigo, afi_depreciacion.compania, afi_depreciacion.aplicacion,
                    afi_depreciacion.year, afi_depreciacion.periodo, li_consecutivo
             from   afi_depreciacion, afi_tipo_activo, activos
             where  activos.tipo_activo = afi_tipo_activo.codigo
             and    activos.compania = afi_depreciacion.compania
             and    activos.codigo = afi_depreciacion.codigo
             and    afi_depreciacion.compania = as_compania
             and    afi_depreciacion.aplicacion = ''AFI''
             and    afi_depreciacion.year = ai_year
             and    afi_depreciacion.periodo = ai_periodo
             and    afi_tipo_activo.cuenta_gasto = r_work.cuenta_gasto
             and    afi_tipo_activo.tipo_comp = r_work.tipo_comp);
        end if;
        
        li_consecutivo = f_cglposteo(as_compania, ''AFI'', r_work.final,
                            r_work.cuenta_depreciacion, null, null,
                            r_work.tipo_comp, r_work.descripcion, -r_work.monto);
        if li_consecutivo > 0 then
           insert into rela_afi_cglposteo (codigo, compania, aplicacion, year, periodo, consecutivo)
            (select afi_depreciacion.codigo, afi_depreciacion.compania, afi_depreciacion.aplicacion,
                    afi_depreciacion.year, afi_depreciacion.periodo, li_consecutivo
             from   afi_depreciacion, afi_tipo_activo, activos
             where  activos.tipo_activo = afi_tipo_activo.codigo
             and    activos.compania = afi_depreciacion.compania
             and    activos.codigo = afi_depreciacion.codigo
             and    afi_depreciacion.compania = as_compania
             and    afi_depreciacion.aplicacion = ''AFI''
             and    afi_depreciacion.year = ai_year
             and    afi_depreciacion.periodo = ai_periodo
             and    afi_tipo_activo.cuenta_gasto = r_work.cuenta_depreciacion
             and    afi_tipo_activo.tipo_comp = r_work.tipo_comp);
        end if;
        
    end loop;
    

    return 1;
end;
' language plpgsql;


create function f_rela_afi_cglposteo_delete() returns trigger as '
begin
    delete from cglposteo
    where consecutivo = old.consecutivo;
    
    return old;
end;
' language plpgsql;

create function f_rela_activos_cglposteo_delete() returns trigger as '
begin
    delete from cglposteo
    where consecutivo = old.consecutivo;
    return old;
end;
' language plpgsql;

create function f_activos_after_update() returns trigger as '
begin
    if old.codigo <> new.codigo
        or old.tipo_activo <> new.tipo_activo
        or old.fecha_compra <> new.fecha_compra
        or old.costo_inicial <> new.costo_inicial then
        delete from rela_activos_cglposteo
        where compania = old.compania
        and codigo = old.codigo;
    end if;
    return new;
end;
' language plpgsql;


create function f_afi_trx1_after_update() returns trigger as '
begin
    delete from rela_afi_trx1_cglposteo
    where compania = old.compania
    and no_trx = old.no_trx;
    return new;
end;
' language plpgsql;


create function f_afi_trx2_after_update() returns trigger as '
begin
    delete from rela_afi_trx1_cglposteo
    where compania = old.compania
    and no_trx = old.no_trx;
    return new;
end;
' language plpgsql;

create function f_afi_trx2_after_delete() returns trigger as '
begin
    delete from rela_afi_trx1_cglposteo
    where compania = old.compania
    and no_trx = old.no_trx;
    return old;
end;
' language plpgsql;

create function f_rela_afi_trx1_cglposteo_after_delete() returns trigger as '
begin
    delete from cglposteo
    where consecutivo = old.consecutivo;
    return old;
end;
' language plpgsql;


create trigger t_rela_afi_cglposteo_delete after delete on rela_afi_cglposteo
for each row execute procedure f_rela_afi_cglposteo_delete();

create trigger t_rela_activos_cglposteo_delete after delete on rela_activos_cglposteo
for each row execute procedure f_rela_activos_cglposteo_delete();

create trigger t_activos_after_update after update on activos
for each row execute procedure f_activos_after_update();

create trigger t_afi_trx1_after_update after update on afi_trx1
for each row execute procedure f_afi_trx1_after_update();

create trigger t_afi_trx2_after_update after update on afi_trx2
for each row execute procedure f_afi_trx2_after_update();

create trigger t_afi_trx2_after_delete after delete on afi_trx2
for each row execute procedure f_afi_trx2_after_delete();

create trigger t_rela_afi_trx1_cglposteo_after_delete after delete on rela_afi_trx1_cglposteo
for each row execute procedure f_rela_afi_trx1_cglposteo_after_delete();
