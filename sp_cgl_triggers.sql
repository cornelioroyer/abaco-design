

drop function f_rela_cglcomprobante1_cglposteo_insert() cascade;
drop function f_rela_cglcomprobante1_cglposteo_update() cascade;
drop function f_rela_cglcomprobante1_cglposteo_delete() cascade;

drop function f_rela_cgl_comprobante1_cglposteo_insert() cascade;
drop function f_rela_cgl_comprobante1_cglposteo_update() cascade;
drop function f_rela_cgl_comprobante1_cglposteo_delete() cascade;

drop function f_cgl_comprobante1_before_delete() cascade;
drop function f_cgl_comprobante1_before_update() cascade;

drop function f_cgl_comprobante1_after_update() cascade;
drop function f_cgl_comprobante2_after_delete() cascade;
drop function f_cgl_comprobante2_after_update() cascade;
drop function f_cgl_comprobante2_before_insert() cascade;

drop function f_cglsldocuenta_after_insert() cascade;
drop function f_cglsldocuenta_after_update() cascade;
drop function f_cglsldocuenta_before_update() cascade;
drop function f_cglsldocuenta_before_delete() cascade;
drop function f_cglsldocuenta_before_insert() cascade;

drop function f_cglposteo_after_insert() cascade;
drop function f_cglposteo_after_delete() cascade;
drop function f_cglposteo_after_update() cascade;

drop function f_cglposteo_before_delete() cascade;
drop function f_cglposteo_before_insert() cascade;
drop function f_cglauxiliares_before_insert() cascade;


drop function f_cglposteoaux1_before_delete() cascade;
drop function f_cglposteoaux1_before_insert() cascade;

drop function f_cglposteoaux1_after_insert() cascade;
drop function f_cglposteoaux1_after_delete() cascade;
drop function f_cglposteoaux1_update() cascade;

drop function f_cglsldoaux1_before_insert() cascade;
drop function f_cglsldoaux2_before_insert() cascade;
drop function f_cglsldoaux1_before_update() cascade;
drop function f_cglsldoaux1_before_delete() cascade;

drop function f_cglposteoaux2_after_insert() cascade;
drop function f_cglposteoaux2_before_update() cascade;
drop function f_cglposteoaux2_after_update() cascade;
drop function f_cglposteoaux2_before_delete() cascade;

create function f_cglposteoaux2_before_delete() returns trigger as '
declare
    i integer;
    r_cglposteo record;
begin
    return old;
    select into r_cglposteo * from cglposteo
    where consecutivo = old.consecutivo;
    if found then
       i := f_cglsldoaux2(r_cglposteo.compania, r_cglposteo.cuenta, old.auxiliar, r_cglposteo.year, r_cglposteo.periodo, old.credito, old.debito);
    end if;

    return old;
end;
' language plpgsql;



create function f_cglposteoaux2_after_update() returns trigger as '
declare
    i integer;
    r_cglposteo record;
begin
    select into r_cglposteo * from cglposteo
    where consecutivo = new.consecutivo;
    if found then
       i := f_cglsldoaux2(r_cglposteo.compania, r_cglposteo.cuenta, new.auxiliar, r_cglposteo.year, r_cglposteo.periodo, new.debito, new.credito);
    end if;

    return new;
end;
' language plpgsql;


create function f_cglposteoaux2_before_update() returns trigger as '
declare
    i integer;
    r_cglposteo record;
begin
    return new;
    select into r_cglposteo * from cglposteo
    where consecutivo = old.consecutivo;
    if found then
--       i := f_cglsldoaux2(r_cglposteo.compania, r_cglposteo.cuenta, new.auxiliar, r_cglposteo.year, r_cglposteo.periodo, old.credito, old.debito);
    end if;

    return new;
end;
' language plpgsql;


create function f_cglposteoaux2_after_insert() returns trigger as '
declare
    i integer;
    r_cglposteo record;
begin
    select into r_cglposteo * from cglposteo
    where consecutivo = new.consecutivo;
    if found then
       i := f_cglsldoaux2(r_cglposteo.compania, r_cglposteo.cuenta, new.auxiliar, r_cglposteo.year, r_cglposteo.periodo, new.debito, new.credito);
    end if;

    return new;
end;
' language plpgsql;



create function f_cglsldoaux1_before_delete() returns trigger as '
declare
    i integer;
    r_cglposteo record;
    ldc_balance_inicio decimal;
    r_gralperiodos record;
begin
    if old.balance_inicio = 0 and old.debito = 0 and old.credito = 0 then
        return old;
    end if;
    
    ldc_balance_inicio = 0;
    
    
    select into r_gralperiodos *
    from gralperiodos
    where compania = old.compania
    and aplicacion = ''CGL''
    and year = old.year
    and periodo = old.periodo;
    if not found then
        Raise Exception ''Periodo % Del Anio % de la Cia % no existe cglsldoaux1 no se puede borrar'', old.periodo, old.year, old.compania;
    end if;
    
    if r_gralperiodos.estado = ''I'' then
        Raise Exception ''Periodo % Del Anio % de la Cia % esta cerrado cglsldoaux1'', old.periodo, old.year, old.compania;
    end if;

    return old;
end;
' language plpgsql;



create function f_cglsldoaux1_before_update() returns trigger as '
declare
    i integer;
    r_cglposteo record;
    ldc_balance_inicio decimal;
    r_gralperiodos record;
begin
    ldc_balance_inicio = 0;
    
    select into r_gralperiodos *
    from gralperiodos
    where compania = new.compania
    and aplicacion = ''CGL''
    and year = new.year
    and periodo = new.periodo;
    if not found then
        Raise Exception ''Periodo % Del Anio % de la Cia % no existe cglsldoaux1'', new.periodo, new.year, new.compania;
    end if;
    
    if r_gralperiodos.estado = ''I'' then
        Raise Exception ''Periodo % Del Anio % de la Cia % esta cerrado cglsldoaux1'', new.periodo, new.year, new.compania;
    end if;

    return new;
end;
' language plpgsql;



create function f_cglsldoaux2_before_insert() returns trigger as '
declare
    i integer;
    r_cglposteo record;
    ldc_balance_inicio decimal;
    r_gralperiodos record;
begin
    ldc_balance_inicio = 0;
    
    select into r_gralperiodos *
    from gralperiodos
    where compania = new.compania
    and aplicacion = ''CGL''
    and year = new.year
    and periodo = new.periodo;
    if not found then
        Raise Exception ''Periodo % Del Anio % de la Cia % no existe cglsldoaux1'', new.periodo, new.year, new.compania;
    end if;
    
    if r_gralperiodos.estado = ''I'' then
        Raise Exception ''Periodo % Del Anio % de la Cia % esta cerrado cglsldoaux1'', new.periodo, new.year, new.compania;
    end if;

/*
    if found then
        select sum(cglposteoaux1.debito-cglposteoaux1.credito) into ldc_balance_inicio
        from cglposteoaux1, cglposteo
        where cglposteo.consecutivo = cglposteoaux1.consecutivo
        and cglposteo.aplicacion = ''CGL''
        and cglposteo.cuenta = new.cuenta
        and compania = new.compania
        and cglposteoaux1.auxiliar = new.auxiliar
        and cglposteo.fecha_comprobante < r_gralperiodos.inicio;
        if ldc_balance_inicio is null then
            ldc_balance_inicio = 0;
        end if;
    end if;

    new.balance_inicio = ldc_balance_inicio;
*/    
    
    return new;
end;
' language plpgsql;





create function f_cglsldoaux1_before_insert() returns trigger as '
declare
    i integer;
    r_cglposteo record;
    ldc_balance_inicio decimal;
    r_gralperiodos record;
begin
    ldc_balance_inicio = 0;
    
    if new.debito = 0 and new.credito = 0 then
        return new;
    end if;
    
    select into r_gralperiodos *
    from gralperiodos
    where compania = new.compania
    and aplicacion = ''CGL''
    and year = new.year
    and periodo = new.periodo;
    if not found then
        Raise Exception ''Periodo % Del Anio % de la Cia % no existe cglsldoaux1...No se puede insertar'', new.periodo, new.year, new.compania;
    end if;
    
    if r_gralperiodos.estado = ''I'' then
        Raise Exception ''Periodo % Del Anio % de la Cia % esta cerrado cglsldoaux1'', new.periodo, new.year, new.compania;
    end if;

/*
    if found then
        select sum(cglposteoaux1.debito-cglposteoaux1.credito) into ldc_balance_inicio
        from cglposteoaux1, cglposteo
        where cglposteo.consecutivo = cglposteoaux1.consecutivo
        and cglposteo.aplicacion = ''CGL''
        and cglposteo.cuenta = new.cuenta
        and compania = new.compania
        and cglposteoaux1.auxiliar = new.auxiliar
        and cglposteo.fecha_comprobante < r_gralperiodos.inicio;
        if ldc_balance_inicio is null then
            ldc_balance_inicio = 0;
        end if;
    end if;

    new.balance_inicio = ldc_balance_inicio;
*/    
    
    return new;
end;
' language plpgsql;



create function f_cglposteo_before_insert() returns trigger as '
declare
    r_cglcuentas record;
    r_cglposteo record;
    r_cglniveles record;
    r_abaco_control_de_cierre record;
    i integer;
begin

    if new.descripcion is null then
        new.descripcion = ''NO EXISTE DESCRIPCION'';
    end if;
    
    select into r_cglcuentas * from cglcuentas
    where cuenta = new.cuenta;
    if not found then
        raise exception ''Cuenta % No Existe...Verifique'',new.cuenta;
    end if;

    i   =   f_abaco_control_de_cierre(new.compania, new.usuario_captura, new.fecha_comprobante);
    i   =   f_valida_fecha(new.compania, ''CGL'', new.fecha_comprobante);

    select into r_cglniveles cglniveles.* from cglcuentas, cglniveles
    where cglcuentas.nivel = cglniveles.nivel
    and cglcuentas.cuenta = new.cuenta
    and cglniveles.recibe = ''N'';
    if found then
       raise exception ''Cuenta % no recibe movimientos...Verifique'', new.cuenta;
    end if;

    
    while 1=1 loop
        select into r_cglposteo *
        from cglposteo
        where consecutivo = new.consecutivo;
        if not found then
            return new;
        else
            new.consecutivo = new.consecutivo + 1;
        end if;
    end loop;
    

    return new;
end;
' language plpgsql;


create function f_cglposteo_before_delete() returns trigger as '
declare
    r_gralperiodos record;
    r_cglniveles record;
    r_cglposteoaux1 record;
    r_cglposteoaux2 record;
    r_abaco_control_de_cierre record;
    i integer;
begin

    old.usuario_captura =   current_user;
    i   =   f_abaco_control_de_cierre(old.compania, old.usuario_captura, old.fecha_comprobante);
    i   =   f_valida_fecha(old.compania, ''CGL'', old.fecha_comprobante);

    select into r_cglniveles cglniveles.* from cglcuentas, cglniveles
    where cglcuentas.nivel = cglniveles.nivel
    and cglcuentas.cuenta = old.cuenta
    and cglniveles.recibe = ''N'';
    if found then
       raise exception ''Cuenta % no recibe movimientos...Verifique'', old.cuenta;
    end if;

    i = f_cglsldocuenta(old.compania, old.cuenta, old.year, old.periodo, -old.debito, -old.credito);

    select into r_cglposteoaux1 * from cglposteoaux1
    where consecutivo = old.consecutivo;
    if found then
        i := f_cglsldoaux1(old.compania, old.cuenta, r_cglposteoaux1.auxiliar, old.year, old.periodo, -r_cglposteoaux1.debito, -r_cglposteoaux1.credito);
    end if;    

    
    select into r_cglposteoaux2 * from cglposteoaux2
    where consecutivo = old.consecutivo;
    if found then
        i := f_cglsldoaux2(old.compania, old.cuenta, r_cglposteoaux2.auxiliar, old.year, old.periodo, -r_cglposteoaux2.debito, -r_cglposteoaux2.credito);
    end if;    

    
    
    return old;
end;
' language plpgsql;



create function f_cglauxiliares_before_insert() returns trigger as '
begin
    if new.concepto is null then
        new.concepto = ''1'';
    end if;
    
    if new.tipo_de_compra is null then
        new.tipo_de_compra = ''1'';
    end if;
    
    if new.tipo_persona is null then
        new.tipo_persona = ''1'';
    end if;

    return new;
end;
' language plpgsql;



create function f_cglposteoaux1_before_insert() returns trigger as '
declare
    r_cglauxiliares record;
begin
    select into r_cglauxiliares * from cglauxiliares
    where auxiliar = new.auxiliar;
    if not found then
        raise exception ''Auxiliar % No Existe...Verifique'',new.auxiliar;
    end if;

    return new;
end;
' language plpgsql;



create function f_cglposteoaux1_after_insert() returns trigger as '
declare
    i integer;
    r_cglposteo record;
begin
    select into r_cglposteo * from cglposteo
    where consecutivo = new.consecutivo;
    if found then
       i := f_cglsldoaux1(r_cglposteo.compania, r_cglposteo.cuenta, new.auxiliar, r_cglposteo.year, r_cglposteo.periodo, new.debito, new.credito);
    end if;
    
    return new;
end;
' language plpgsql;


create function f_cglposteoaux1_before_delete() returns trigger as '
declare
    i integer;
    r_cglposteo record;
begin
    select into r_cglposteo * from cglposteo
    where consecutivo = old.consecutivo;
    if found then
--        i := f_cglsldoaux1(r_cglposteo.compania, r_cglposteo.cuenta, old.auxiliar, r_cglposteo.year, r_cglposteo.periodo, -old.debito, -old.credito);
    end if;
    
    return old;
end;
' language plpgsql;


create function f_cglposteoaux1_after_delete() returns trigger as '
declare
    i integer;
    r_cglposteo record;
begin
    select into r_cglposteo * from cglposteo
    where consecutivo = old.consecutivo;
    if found then
--        i := f_cglsldoaux1(r_cglposteo.compania, r_cglposteo.cuenta, old.auxiliar, r_cglposteo.year, r_cglposteo.periodo, -old.debito, -old.credito);
    end if;
    
    return old;
end;
' language plpgsql;


create function f_cglposteoaux1_update() returns trigger as '
declare
    i integer;
    r_cglposteo record;
begin
    return new;
    select into r_cglposteo * from cglposteo
    where consecutivo = old.consecutivo;
    if found then
--       i := f_cglsldoaux1(r_cglposteo.compania, r_cglposteo.cuenta, old.auxiliar, r_cglposteo.year, r_cglposteo.periodo, -old.debito, -old.credito);
    end if;
    
    select into r_cglposteo * from cglposteo
    where consecutivo = new.consecutivo;
    
--    i := f_cglsldoaux1(r_cglposteo.compania, r_cglposteo.cuenta, new.auxiliar, r_cglposteo.year, r_cglposteo.periodo, new.debito, new.credito);

--    i := f_cglposteaux1_cxpdocm(new.consecutivo, new.auxiliar, new.secuencia);
--    i := f_cglposteaux1_cxcdocm(new.consecutivo, new.auxiliar, new.secuencia);
    
    return new;
end;
' language plpgsql;


/*
create function f_cglposteo_before_delete_old() returns trigger as '
declare
    r_cglposteoaux1 record;
    i integer;
    ls_sql text;
    ls_tabla text;
    r_pg_class1 record;
    r_pg_class2 record;
    r_pg_constraint record;
    r_pg_attribute record;
    r_gralperiodos record;
begin
    i := f_valida_fecha(old.compania, ''CGL'', old.fecha_comprobante);
    
    
    for r_cglposteoaux1 in select * from cglposteoaux1
                                where consecutivo = old.consecutivo
    loop
        i := f_cglsldoaux1(old.compania, old.cuenta, r_cglposteoaux1.auxiliar, old.year, old.periodo, -r_cglposteoaux1.debito, -r_cglposteoaux1.credito);
    end loop;


    for r_pg_constraint in select pg_constraint.* from pg_class, pg_constraint
                        where pg_class.relname = ''cglposteo''
                        and pg_constraint.confrelid = pg_class.oid
    loop
        select into r_pg_class2 * from pg_class
        where oid = r_pg_constraint.conrelid and relkind = ''r'';
        if found then
            select into r_pg_attribute * from pg_attribute
            where pg_attribute.attrelid = r_pg_constraint.conrelid
            and pg_attribute.attnum = r_pg_constraint.conkey[1];
        
            ls_sql := ''delete from '' || trim(r_pg_class2.relname) || '' where '' || trim(r_pg_attribute.attname) || '' = '' || old.consecutivo;
            execute ls_sql;
        end if;
        
    end loop;                   
    return old;
end;
' language plpgsql;
*/




create function f_cgl_comprobante1_before_delete() returns trigger as '
begin
/*
    delete from rela_cgl_comprobante1_cglposteo
    where compania = old.compania
    and secuencia = old.secuencia;
*/    
    return old;
end;
' language plpgsql;


create function f_cgl_comprobante1_before_update() returns trigger as '
begin
/*
    delete from rela_cgl_comprobante1_cglposteo
    where compania = old.compania
    and secuencia = old.secuencia;
*/    
    return new;
end;
' language plpgsql;



create function f_cgl_comprobante2_before_insert() returns trigger as '
declare
    r_cglauxiliares record;
    r_cglcuentas record;
begin
    select into r_cglcuentas * from cglcuentas
    where cuenta = new.cuenta;
    if not found then
        raise exception ''Codigo de Cuenta % No Existe...Verifique'',new.cuenta;
    else
        if r_cglcuentas.auxiliar_1 = ''S'' then
            select into r_cglauxiliares * from cglauxiliares
            where auxiliar = new.auxiliar;
            if not found then
                raise exception ''Codigo de Auxiliar % No Existe...Verifique'',new.auxiliar;
            end if;
        end if;            
    end if;        
    
    return new;
end;
' language plpgsql;

create function f_rela_cglcomprobante1_cglposteo_insert() returns trigger as '
begin
    update cglposteo
    set secuencia = new.secuencia
    where consecutivo = new.consecutivo;
    return new;
end;
' language plpgsql;


create function f_rela_cglcomprobante1_cglposteo_update() returns trigger as '
begin
    delete from cglposteo
    where consecutivo = old.consecutivo;
    return new;
end;
' language plpgsql;

create function f_rela_cglcomprobante1_cglposteo_delete() returns trigger as '
begin
    delete from cglposteo
    where consecutivo = old.consecutivo;
    return old;
end;
' language plpgsql;


create function f_rela_cgl_comprobante1_cglposteo_insert() returns trigger as '
begin
    update cglposteo
    set secuencia = new.secuencia
    where cglposteo.consecutivo = new.consecutivo;
    return new;
end;
' language plpgsql;

create function f_rela_cgl_comprobante1_cglposteo_update() returns trigger as '
begin
    delete from cglposteo
    where consecutivo = old.consecutivo;
    return new;
end;
' language plpgsql;


create function f_rela_cgl_comprobante1_cglposteo_delete() returns trigger as '
begin
    delete from cglposteo
    where consecutivo = old.consecutivo;
    return old;
end;
' language plpgsql;


create function f_cgl_comprobante1_after_update() returns trigger as '
begin
    delete from rela_cgl_comprobante1_cglposteo
    where compania = old.compania
    and secuencia = old.secuencia;
    return new;
end;
' language plpgsql;

create function f_cgl_comprobante2_after_update() returns trigger as '
begin
    delete from rela_cgl_comprobante1_cglposteo
    where compania = old.compania
    and secuencia = old.secuencia;
    return new;
end;
' language plpgsql;

create function f_cgl_comprobante2_after_delete() returns trigger as '
begin
    delete from rela_cgl_comprobante1_cglposteo
    where compania = old.compania
    and secuencia = old.secuencia;
    return old;
end;
' language plpgsql;


create function f_cglsldocuenta_before_insert() returns trigger as '
declare
    r_gralperiodos record;
begin
    select into r_gralperiodos *
    from gralperiodos
    where compania = new.compania
    and aplicacion = ''CGL''
    and year = new.year
    and periodo = new.periodo;
    if not found then
        Raise Exception ''Periodo % del Anio % Cia % no existe cglsldocuenta'',new.periodo, new.year, new.compania;
    end if;
    
    if r_gralperiodos.estado = ''I'' then
        Raise Exception ''Periodo % del Anio % Cia % esta cerrado cglsldocuenta'',new.periodo, new.year, new.compania;
    end if;    
 
    new.balance_inicio = f_balance_inicio_cuenta(new.compania, new.cuenta, new.year, new.periodo);
    return new;
end;
' language plpgsql;


create function f_cglsldocuenta_after_insert() returns trigger as '
declare
    r_cglsldocuenta record;
    r_gralperiodos record;
    ldc_balance_inicio decimal(10,2);
    ld_work date;
begin

    ldc_balance_inicio = new.balance_inicio + new.debito - new.credito;
    
    for r_cglsldocuenta in select cglsldocuenta.* from cglsldocuenta
                            where compania = new.compania
                            and cuenta = new.cuenta
                            and (year > new.year or (year = new.year and periodo > new.periodo))
                            order by year, periodo
    loop
        update cglsldocuenta
        set balance_inicio = ldc_balance_inicio
        where compania = r_cglsldocuenta.compania
        and cuenta = r_cglsldocuenta.cuenta
        and year = r_cglsldocuenta.year
        and periodo = r_cglsldocuenta.periodo;
        
        ldc_balance_inicio = ldc_balance_inicio + r_cglsldocuenta.debito - r_cglsldocuenta.credito;
    end loop;
    
    return new;
end;
' language plpgsql;


create function f_cglsldocuenta_after_update() returns trigger as '
declare
    r_cglsldocuenta record;
    ldc_balance_inicio decimal(10,2);
begin
    ldc_balance_inicio = new.balance_inicio + new.debito - new.credito;
    
    for r_cglsldocuenta in select * from cglsldocuenta
                            where compania = new.compania
                            and cuenta = new.cuenta
                            and ((year > new.year
                            or (year = new.year and periodo > new.periodo)))
                            order by year, periodo
    loop
        update cglsldocuenta
        set balance_inicio = ldc_balance_inicio
        where compania = r_cglsldocuenta.compania
        and cuenta = r_cglsldocuenta.cuenta
        and year = r_cglsldocuenta.year
        and periodo = r_cglsldocuenta.periodo;
        ldc_balance_inicio = ldc_balance_inicio + r_cglsldocuenta.debito - r_cglsldocuenta.credito;
    end loop;
    return new;
end;
' language plpgsql;


create function f_cglsldocuenta_before_update() returns trigger as '
declare
    r_cglsldocuenta record;
    ldc_balance_inicio decimal(10,2);
begin
    ldc_balance_inicio = -(old.balance_inicio + old.debito - old.credito);


    for r_cglsldocuenta in select * from cglsldocuenta
                            where compania = old.compania
                            and cuenta = old.cuenta
                            and ((year > old.year
                            or (year = old.year and periodo > old.periodo)))
                            order by year, periodo
    loop
/*    
        update cglsldocuenta
        set balance_inicio = ldc_balance_inicio
        where compania = r_cglsldocuenta.compania
        and cuenta = r_cglsldocuenta.cuenta
        and year = r_cglsldocuenta.year
        and periodo = r_cglsldocuenta.periodo;
        ldc_balance_inicio = ldc_balance_inicio + r_cglsldocuenta.debito - r_cglsldocuenta.credito;
*/        
    end loop;
    return new;
end;
' language plpgsql;


create function f_cglsldocuenta_before_delete() returns trigger as '
declare
    r_cglsldocuenta record;
    ldc_balance_inicio decimal(10,2);
begin
    ldc_balance_inicio = -(old.balance_inicio + old.debito - old.credito);


    for r_cglsldocuenta in select * from cglsldocuenta
                            where compania = old.compania
                            and cuenta = old.cuenta
                            and ((year > old.year
                            or (year = old.year and periodo > old.periodo)))
                            order by year, periodo
    loop
/*    
        update cglsldocuenta
        set balance_inicio = ldc_balance_inicio
        where compania = r_cglsldocuenta.compania
        and cuenta = r_cglsldocuenta.cuenta
        and year = r_cglsldocuenta.year
        and periodo = r_cglsldocuenta.periodo;
        ldc_balance_inicio = ldc_balance_inicio + r_cglsldocuenta.debito - r_cglsldocuenta.credito;
*/        
    end loop;
    return old;
end;
' language plpgsql;



create function f_cglposteo_after_delete() returns trigger as '
declare
    r_cglniveles record;
    r_cglcuentas record;
    r_cglsldocuenta record;
    r_cglposteoaux1 record;
    ls_cuenta char(24);
    ldc_debito decimal(12,2);
    ldc_credito decimal(12,2);
    ls_documento char(25);
    r_gralperiodos record;
    lt_new_dato text;
    lt_old_dato text;
    i int4;
begin

--    lt_new_dato =   null;
--    lt_old_dato =   Row(Old.*);
--     i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), trim(lt_old_dato), trim(lt_new_dato), null);

    return old;
end;
' language plpgsql;


create function f_cglposteo_after_insert() returns trigger as '
declare
    r_cglniveles record;
    r_cglcuentas record;
    r_cglsldocuenta record;
    ls_cuenta char(24);
    lt_new_dato text;
    lt_old_dato text;
    i int4;
begin

--    lt_new_dato =   Row(New.*);
--    lt_old_dato =   null;
--    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), trim(lt_old_dato), trim(lt_new_dato), null);
    
    i           =   f_cglsldocuenta(new.compania, new.cuenta, new.year, new.periodo, new.debito, new.credito);
    
    return new;
end;
' language plpgsql;


create function f_cglposteo_after_update() returns trigger as '
declare
    lt_new_dato text;
    lt_old_dato text;
    i int4;
begin

/*
    lt_new_dato =   Row(New.*);
    lt_old_dato =   Row(Old.*);
    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), trim(lt_old_dato), trim(lt_new_dato), null);
*/
    return new;
end;
' language plpgsql;



create trigger t_cglposteo_before_delete before delete on cglposteo
for each row execute procedure f_cglposteo_before_delete();

create trigger t_cglposteo_before_insert before insert on cglposteo
for each row execute procedure f_cglposteo_before_insert();

create trigger t_cglposteo_after_insert after insert on cglposteo
for each row execute procedure f_cglposteo_after_insert();

create trigger t_cglposteo_after_delete after delete on cglposteo
for each row execute procedure f_cglposteo_after_delete();

create trigger t_cglposteo_after_update after update on cglposteo
for each row execute procedure f_cglposteo_after_update();




create trigger t_cglsldoaux1_before_insert before insert on cglsldoaux1
for each row execute procedure f_cglsldoaux1_before_insert();

create trigger t_cglsldoaux1_before_update before update on cglsldoaux1
for each row execute procedure f_cglsldoaux1_before_update();

create trigger t_cglsldoaux1_before_delete before delete on cglsldoaux1
for each row execute procedure f_cglsldoaux1_before_delete();



create trigger t_cglposteoaux1_before_insert before insert on cglposteoaux1
for each row execute procedure f_cglposteoaux1_before_insert();

create trigger t_cglposteoaux1_after_delete before delete on cglposteoaux1
for each row execute procedure f_cglposteoaux1_after_delete();

create trigger t_cglposteoaux1_after_insert after insert on cglposteoaux1
for each row execute procedure f_cglposteoaux1_after_insert();

create trigger t_cglposteoaux1_before_delete before delete on cglposteoaux1
for each row execute procedure f_cglposteoaux1_before_delete();


create trigger t_cglposteoaux2_after_insert after insert on cglposteoaux2
for each row execute procedure f_cglposteoaux2_after_insert();

create trigger t_cglposteoaux2_before_update before update on cglposteoaux2
for each row execute procedure f_cglposteoaux2_before_update();

create trigger t_cglposteoaux2_after_update after update on cglposteoaux2
for each row execute procedure f_cglposteoaux2_after_update();

create trigger t_cglposteoaux2_before_delete before delete on cglposteoaux2
for each row execute procedure f_cglposteoaux2_before_delete();


create trigger t_cgl_comprobante1_before_delete before delete on cgl_comprobante1
for each row execute procedure f_cgl_comprobante1_before_delete();

create trigger t_cgl_comprobante1_before_update before update on cgl_comprobante1
for each row execute procedure f_cgl_comprobante1_before_update();

create trigger t_cglauxliares_before_insert before insert or update on cglauxiliares
for each row execute procedure f_cglauxiliares_before_insert();



create trigger t_cgl_comprobante2_before_insert before insert on cgl_comprobante2
for each row execute procedure f_cgl_comprobante2_before_insert();

create trigger t_cgl_comprobante1_after_udpate after update on cgl_comprobante1
for each row execute procedure f_cgl_comprobante1_after_update();

create trigger t_cgl_comprobante2_after_delete after delete on cgl_comprobante2
for each row execute procedure f_cgl_comprobante2_after_delete();

create trigger t_cgl_comprobante2_after_update after update on cgl_comprobante2
for each row execute procedure f_cgl_comprobante2_after_update();


create trigger t_rela_cgl_comprobante1_cglposteo_insert after insert on rela_cgl_comprobante1_cglposteo
for each row execute procedure f_rela_cgl_comprobante1_cglposteo_insert();

create trigger t_rela_cgl_comprobante1_cglposteo_update after update on rela_cgl_comprobante1_cglposteo
for each row execute procedure f_rela_cgl_comprobante1_cglposteo_update();

create trigger t_rela_cgl_comprobante1_cglposteo_delete after delete on rela_cgl_comprobante1_cglposteo
for each row execute procedure f_rela_cgl_comprobante1_cglposteo_delete();


create trigger t_rela_cglcomprobante1_cglposteo_insert after insert on rela_cglcomprobante1_cglposteo
for each row execute procedure f_rela_cglcomprobante1_cglposteo_insert();

create trigger t_rela_cglcomprobante1_cglposteo_update after update on rela_cglcomprobante1_cglposteo
for each row execute procedure f_rela_cglcomprobante1_cglposteo_update();

create trigger t_rela_cglcomprobante1_cglposteo_delete after delete on rela_cglcomprobante1_cglposteo
for each row execute procedure f_rela_cglcomprobante1_cglposteo_delete();


/*
create trigger t_cglsldocuenta_before_insert before insert on cglsldocuenta
for each row execute procedure f_cglsldocuenta_before_insert();

create trigger t_cglsldocuenta_after_insert after insert on cglsldocuenta
for each row execute procedure f_cglsldocuenta_after_insert();

create trigger t_cglsldocuenta_before_update before update on cglsldocuenta
for each row execute procedure f_cglsldocuenta_before_update();

create trigger t_cglsldocuenta_after_update after update on cglsldocuenta
for each row execute procedure f_cglsldocuenta_after_update();

create trigger t_cglsldocuenta_before_delete before delete on cglsldocuenta
for each row execute procedure f_cglsldocuenta_before_delete();
*/
