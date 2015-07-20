

drop function f_rela_nomctrac_cglposteo_delete() cascade;
drop function f_rela_pla_reservas_cglposteo_delete() cascade;
drop function f_nomctrac_update() cascade;
drop function f_pla_reservas_update() cascade;
drop function f_pla_vacacion_after_delete() cascade;
drop function f_pla_vacacion_after_update() cascade;
drop function f_nomhrtrab_before_update() cascade;
drop function f_nomhrtrab_before_delete() cascade;
drop function f_nomhrtrab_before_insert() cascade;
drop function f_nomctrac_before_insert() cascade;
drop function f_nomctrac_before_delete() cascade;
drop function f_rhuacre_after_insert() cascade;
drop function f_rhuacre_before_insert() cascade;
drop function f_rhuacre_before_update() cascade;

drop function f_rhuempl_before_insert() cascade;
drop function f_rhuempl_before_update() cascade;
drop function f_rhuempl_after_update() cascade;
drop function f_rhuempl_after_insert() cascade;

drop function f_nomctrac_after_insert_update() cascade;
drop function f_nomhoras_before_insert() cascade;
drop function f_rela_nomctrac_cglposteo_before_delete() cascade;


create function f_rela_nomctrac_cglposteo_before_delete() returns trigger as '
begin
    delete from cglposteo
    where consecutivo = old.consecutivo;
    return old;
end;
' language plpgsql;


create function f_nomhoras_before_insert() returns trigger as '
declare
    r_nomtpla2 record;
    r_rhuempl record;
    ldc_porcentaje decimal;
    ldc_reserva decimal;
    i integer;
begin
    
    select into r_rhuempl *
    from rhuempl
    where compania = new.compania
    and codigo_empleado = new.codigo_empleado;
    if not found then
        Raise Exception ''Codigo de Empleado % no Existe'',new.codigo_empleado;
    end if;

    if r_rhuempl.tipo_planilla = ''1'' and new.fecha_laborable = ''2013-07-04'' then
        new.tasaporhora = r_rhuempl.tasaporhora + .10;
    end if;

    if r_rhuempl.tipo_planilla = ''1'' and (new.fecha_laborable = ''2014-01-01''
            or new.fecha_laborable = ''2014-01-02'') then
        if new.tasaporhora = 2.14 then
            new.tasaporhora = 2.47;
        end if;
    end if;


    return new;
end;
' language plpgsql;



create function f_nomctrac_after_insert_update() returns trigger as '
declare
    r_nomtpla2 record;
    r_nom_conceptos_para_calculo record;
    ldc_porcentaje decimal;
    ldc_reserva decimal;
    lt_new_dato text;
    lt_old_dato text;
    lt_sentencia_sql text;
    i int4;
begin

/*
    lt_new_dato =   Row(New.*);
    lt_old_dato =   null;
    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), trim(lt_old_dato), trim(lt_new_dato), null);
*/

    i   =   f_nomctrac_pla_reservas(new.compania, new.codigo_empleado, new.tipo_calculo,
                new.tipo_planilla, new.year, new.numero_planilla, new.numero_documento, new.cod_concepto_planilla);

    return new;

    delete from pla_reservas
    where compania = new.compania
    and codigo_empleado = new.codigo_empleado
    and tipo_calculo = new.tipo_calculo
    and tipo_planilla = new.tipo_planilla
    and year = new.year
    and numero_planilla = new.numero_planilla
    and numero_documento = new.numero_documento
    and cod_concepto_planilla = new.cod_concepto_planilla;
    
    select into r_nomtpla2 * from nomtpla2
    where tipo_planilla = new.tipo_planilla
    and year = new.year
    and numero_planilla = new.numero_planilla;

    for r_nom_conceptos_para_calculo in select nom_conceptos_para_calculo.* 
                                            from nom_conceptos_para_calculo, nomconce
                                            where nom_conceptos_para_calculo.cod_concepto_planilla = nomconce.cod_concepto_planilla
                                            and nomconce.solo_patrono = ''S''
                                            and concepto_aplica = new.cod_concepto_planilla
                                            order by cod_concepto_planilla
    loop
        ldc_reserva = 0;
        if r_nom_conceptos_para_calculo.cod_concepto_planilla = ''402'' then
            ldc_reserva = new.monto * .12;
        elseif r_nom_conceptos_para_calculo.cod_concepto_planilla = ''403'' then
            ldc_reserva = new.monto * .1075;
        elseif r_nom_conceptos_para_calculo.cod_concepto_planilla = ''404'' then
            ldc_reserva = new.monto * 1.5/100;
        elseif r_nom_conceptos_para_calculo.cod_concepto_planilla = ''408'' then
            ldc_reserva = new.monto / 11;
        elseif r_nom_conceptos_para_calculo.cod_concepto_planilla = ''409'' then
            ldc_reserva = (new.monto / 12) + (new.monto/11/12);
        elseif r_nom_conceptos_para_calculo.cod_concepto_planilla = ''410'' then
            ldc_porcentaje := f_gralparaxcia(new.compania, ''PLA'', ''porcentaje_rp'');        
            ldc_reserva = new.monto * (ldc_porcentaje/100);
        elseif r_nom_conceptos_para_calculo.cod_concepto_planilla = ''420'' then
            ldc_reserva = new.monto/52 + (new.monto/11/52);
        elseif r_nom_conceptos_para_calculo.cod_concepto_planilla = ''430'' then
            ldc_reserva = (new.monto/52*3.4 + (new.monto/11/52*3.4))*.05;
        end if;
        insert into pla_reservas(compania, codigo_empleado, tipo_calculo, cod_concepto_planilla,
            tipo_planilla, numero_planilla, year, numero_documento, concepto_reserva, monto)
        values(new.compania, new.codigo_empleado, new.tipo_calculo, new.cod_concepto_planilla,
            new.tipo_planilla, new.numero_planilla, new.year, new.numero_documento, 
            r_nom_conceptos_para_calculo.cod_concepto_planilla, ldc_reserva);
    end loop; 
    return new;
end;
' language plpgsql;


create function f_rhuempl_before_update() returns trigger as '
declare
    r_cglauxilares record;
    r_rhuacre record;
    r_rhuempl record;
begin
    select into r_rhuacre * from rhuacre
    where trim(cod_acreedores) = trim(new.codigo_empleado);
    if found then
        raise exception ''Codigo de Empleado % Ya existe como Acreedor...Verifique'',new.codigo_empleado;
    end if;

    
    if trim(old.codigo_empleado) <> trim(new.codigo_empleado) then
        select into r_rhuempl * from rhuempl
        where trim(codigo_empleado) = trim(new.codigo_empleado);
        if found then
            raise exception ''Codigo de empleado % ya existe en la cia %'',new.codigo_empleado, r_rhuempl.compania;
        end if;

        select into r_cglauxilares * from cglauxiliares
        where trim(auxiliar) = trim(new.codigo_empleado);
        if not found then        
            update cglauxiliares
            set auxiliar = trim(new.codigo_empleado)
            where Trim(auxiliar) = trim(old.codigo_empleado);
        end if;
        return new;
    end if;

    new.auxiliar = new.codigo_empleado;


    select into r_cglauxilares * from cglauxiliares
    where trim(auxiliar) = trim(new.codigo_empleado);
    if not found then
        insert into cglauxiliares (auxiliar, nombre, tipo_persona, status)
        values (trim(new.codigo_empleado), substring(new.nombre_del_empleado from 1 for 30), ''1'', ''A'');
    else
        update cglauxiliares
        set nombre = substring(trim(new.nombre_del_empleado) from 1 for 30)
        where trim(auxiliar) = trim(new.codigo_empleado);
    end if;

    return new;
end;
' language plpgsql;


create function f_rhuempl_after_update() returns trigger as '
declare
    r_cglauxilares record;
    i integer;
    lt_new_dato text;
    lt_old_dato text;
begin

/*
    lt_new_dato =   Row(New.*);
    lt_old_dato =   Row(Old.*);
    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), trim(lt_old_dato), trim(lt_new_dato), null);
*/

    if trim(old.codigo_empleado) <> trim(new.codigo_empleado) then
        select into r_cglauxilares * from cglauxiliares
        where trim(auxiliar) = trim(new.codigo_empleado);
        if not found then        
            update cglauxiliares
            set auxiliar = trim(new.codigo_empleado),
            nombre = substring(trim(new.nombre_del_empleado) from 1 for 30)
            where trim(auxiliar) = trim(old.codigo_empleado);
        end if;
    else
        select into r_cglauxilares * from cglauxiliares
        where trim(auxiliar) = trim(new.codigo_empleado);
        if not found then
            insert into cglauxiliares (auxiliar, nombre, tipo_persona, status)
            values (trim(new.codigo_empleado), substring(new.nombre_del_empleado from 1 for 30), ''1'', ''A'');
        else
            update cglauxiliares
            set nombre = substring(trim(new.nombre_del_empleado) from 1 for 30)
            where trim(auxiliar) = trim(new.codigo_empleado);
        end if;
    
    end if;
    
    if f_gralparaxcia(new.compania,''PLA'',''metodo_calculo'') = ''harinas'' then
        i = f_update_cxc_empleados(new.compania, new.codigo_empleado);
    end if;
    return new;
end;
' language plpgsql;


create function f_rhuacre_before_update() returns trigger as '
declare
    r_rhuempl record;
    r_rhuacre record;
begin
    select into r_rhuempl * from rhuempl
    where trim(codigo_empleado) = trim(new.cod_acreedores);
    if found then
        raise exception ''Codigo de Acreedor % Ya existe como empleado...Verifique'',new.cod_acreedores;
    end if;
    
    return new;
end;
' language plpgsql;



create function f_rhuacre_before_insert() returns trigger as '
declare
    r_rhuempl record;
    r_rhuacre record;
begin
    select into r_rhuempl * from rhuempl
    where trim(codigo_empleado) = trim(new.cod_acreedores);
    if found then
        raise exception ''Codigo de Acreedor % Ya existe como empleado...Verifique'',new.cod_acreedores;
    end if;
    
    select into r_rhuacre * from rhuacre
    where cod_acreedores = new.cod_acreedores;
    if found then
        raise exception ''Codigo de Acreedor % Ya Existe...Verifique'',new.cod_acreedores;
    end if;
   
    return new;
end;
' language plpgsql;



create function f_rhuacre_after_insert() returns trigger as '
declare
    r_cglauxilares record;
    lt_new_dato text;
    lt_old_dato text;
    i int4;
begin
/*
    lt_new_dato =   Row(New.*);
    lt_old_dato =   null;
    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), trim(lt_old_dato), trim(lt_new_dato), null);
*/
    select into r_cglauxilares * from cglauxiliares
    where trim(auxiliar) = trim(new.cod_acreedores);
    if not found then
        insert into cglauxiliares (auxiliar, nombre, tipo_persona, status)
        values (trim(new.cod_acreedores), substring(new.nombre_acreedores from 1 for 30), ''1'', ''A'');
    else
        update cglauxiliares
        set nombre = substring(trim(new.nombre_acreedores) from 1 for 30)
        where trim(auxiliar) = trim(new.cod_acreedores);
    end if;
    return new;
end;
' language plpgsql;



create function f_nomctrac_before_delete() returns trigger as '
declare
    r_nomtpla2 record;
begin
    select into r_nomtpla2 * from nomtpla2
    where tipo_planilla = old.tipo_planilla
    and year = old.year
    and numero_planilla = old.numero_planilla;
    if not found then
        raise exception ''Tipo de planilla % no existe '',old.tipo_planilla;
    end if;
    
    if r_nomtpla2.status = ''C'' then
        raise exception ''Tipo de Planilla %, Anio %, Numero Planilla % esta cerrado...No puede ser eliminado'',old.tipo_planilla, old.year, old.numero_planilla;
    end if;
    
    if old.no_cheque is not null then
        raise exception ''No se pueden borrar registros con cheque % asignado'',old.no_cheque;
    end if;
    
    return old;
end;
' language plpgsql;

create function f_nomctrac_before_insert() returns trigger as '
declare
    r_nomtpla2 record;
begin
    select into r_nomtpla2 * from nomtpla2
    where tipo_planilla = new.tipo_planilla
    and year = new.year
    and numero_planilla = new.numero_planilla;
    if not found then
        raise exception ''Tipo de planilla % no existe '',new.tipo_planilla;
    end if;
    
    if r_nomtpla2.status = ''C'' then
        raise exception ''Tipo de Planilla %, Anio %, Numero Planilla % esta cerrado'',new.tipo_planilla, new.year, new.numero_planilla;
    end if;
    
    return new;
end;
' language plpgsql;






create function f_nomctrac_update() returns trigger as '
declare
    i integer;
begin
/*
    i := f_nomctrac_pla_reservas(new.compania, new.codigo_empleado, new.tipo_calculo,
            new.tipo_planilla, new.numero_planilla, new.year, new.numero_documento,
            new.cod_concepto_planilla);
*/            
    return new;
end;
' language plpgsql;


create function f_rela_pla_reservas_cglposteo_delete() returns trigger as '
begin
    delete from cglposteo
    where consecutivo = old.consecutivo;
    return old;
end;
' language plpgsql;



create function f_pla_reservas_update() returns trigger as '
declare
    i   integer;
begin
/*
    i := f_pla_reservas_cglposteo(new.codigo_empleado, new.compania, new.tipo_calculo, 
            new.cod_concepto_planilla, new.tipo_planilla, new.numero_planilla,
            new.year, new.numero_documento, new.concepto_reserva);
*/    
    return new;
end;
' language plpgsql;




create function f_rela_nomctrac_cglposteo_delete() returns trigger as '
begin
    delete from cglposteo
    where consecutivo = old.consecutivo;
    return old;
end;
' language plpgsql;





create function f_rhuempl_after_insert() returns trigger as '
declare
    r_cglauxilares record;
    lt_new_dato text;
    lt_old_dato text;
    i int4;
begin
/*
    lt_new_dato =   Row(New.*);
    lt_old_dato =   null;
    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), trim(lt_old_dato), trim(lt_new_dato), null);
*/

    select into r_cglauxilares * from cglauxiliares
    where trim(auxiliar) = trim(new.codigo_empleado);
    if not found then
        insert into cglauxiliares (auxiliar, nombre, tipo_persona, status)
        values (trim(new.codigo_empleado), substring(new.nombre_del_empleado from 1 for 30), ''1'', ''A'');
    else
        update cglauxiliares
        set nombre = substring(trim(new.nombre_del_empleado) from 1 for 30)
        where trim(auxiliar) = trim(new.codigo_empleado);
    end if;
    
    if f_gralparaxcia(new.compania,''PLA'',''metodo_calculo'') = ''harinas'' then
        i = f_update_cxc_empleados(new.compania, new.codigo_empleado);
    end if;
    return new;
end;
' language plpgsql;



create function f_rhuempl_before_insert() returns trigger as '
declare
    r_cglauxilares record;
    r_rhuacre record;
    r_rhuempl record;
begin
    select into r_cglauxilares * from cglauxiliares
    where trim(auxiliar) = trim(new.codigo_empleado);
    if not found then
        insert into cglauxiliares (auxiliar, nombre, tipo_persona, status)
        values (trim(new.codigo_empleado), substring(new.nombre_del_empleado from 1 for 30), ''1'', ''A'');
    else
        update cglauxiliares
        set nombre = substring(trim(new.nombre_del_empleado) from 1 for 30)
        where trim(auxiliar) = trim(new.codigo_empleado);
    end if;
    
    select into r_rhuacre * from rhuacre
    where trim(cod_acreedores) = trim(new.codigo_empleado);
    if found then
        raise exception ''Codigo de Empleado % Ya existe como Acreedor...Verifique'',new.codigo_empleado;
    end if;
    
    select into r_rhuempl * from rhuempl
    where trim(codigo_empleado) = trim(new.codigo_empleado);
    if found then
        raise exception ''Codigo de Empleado % Ya Existe...Verifique'',new.codigo_empleado;
    end if;
    return new;
end;
' language plpgsql;



create function f_pla_vacacion_after_update() returns trigger as '
begin
    if new.status = ''A'' then
        update rhuempl
        set status = ''V''
        where compania = new.compania
        and codigo_empleado = new.codigo_empleado
        and status = ''A'';
    else
        update rhuempl
        set status = ''A''
        where compania = new.compania
        and codigo_empleado = new.codigo_empleado
        and status = ''V'';
    end if;
    return new;
end;
' language plpgsql;

create function f_pla_vacacion_after_delete() returns trigger as '
begin
    update rhuempl
    set status = ''A''
    where compania = old.compania
    and codigo_empleado = old.codigo_empleado
    and status = ''V'';
    return old;
end;
' language plpgsql;



create function f_nomhrtrab_before_delete() returns trigger as '
declare
    i integer;
    r_nomtpla2 record;
begin
    select into r_nomtpla2 * from nomtpla2
    where tipo_planilla = old.tipo_planilla
    and year = old.year
    and numero_planilla = old.numero_planilla;
    if found then
        i := f_valida_fecha(old.compania, ''CGL'', r_nomtpla2.dia_d_pago);
    end if;
    return old;
end;
' language plpgsql;

create function f_nomhrtrab_before_update() returns trigger as '
declare
    i integer;
    r_nomtpla2 record;
    lts_entrada timestamp;
    lts_salida timestamp;
begin
    select into r_nomtpla2 * from nomtpla2
    where tipo_planilla = old.tipo_planilla
    and year = old.year
    and numero_planilla = old.numero_planilla;
    if found then
        i := f_valida_fecha(old.compania, ''CGL'', r_nomtpla2.dia_d_pago);
    end if;
    
    lts_entrada =   f_timestamp(new.fecha_laborable, new.hora_de_inicio_trabajo);
    lts_salida  =   f_timestamp(new.fecha_salida, new.hora_de_salida_trabajo);
    if lts_entrada > lts_salida then
        raise exception ''Hora de Salida % debe ser mayor a la hora de entrada %'',lts_salida, lts_entrada;
    end if;
    
    return new;
end;
' language plpgsql;


create function f_nomhrtrab_before_insert() returns trigger as '
declare
    i integer;
    r_nomtpla2 record;
    lts_entrada timestamp;
    lts_salida timestamp;
begin
    select into r_nomtpla2 * from nomtpla2
    where tipo_planilla = new.tipo_planilla
    and year = new.year
    and numero_planilla = new.numero_planilla;
    if found then
        i := f_valida_fecha(new.compania, ''CGL'', r_nomtpla2.dia_d_pago);
    end if;
    
    lts_entrada =   f_timestamp(new.fecha_laborable, new.hora_de_inicio_trabajo);
    lts_salida  =   f_timestamp(new.fecha_salida, new.hora_de_salida_trabajo);
    if lts_entrada > lts_salida then
        raise exception ''Hora de Salida % debe ser mayor a la hora de entrada %'',lts_salida, lts_entrada;
    end if;
    
    return new;
end;
' language plpgsql;



/*create function f_nomtpla2_update() returns trigger as '
declare
    i integer;
begin
    delete from rela_nomctrac_cglposteo
    where tipo_planilla = new.tipo_planilla 
    and numero_planilla = new.numero_planilla
    and year = new.year;
    
    if trim(new.status) = ''C'' then
        select into i f_nomctrac_cglposteo(compania, codigo_empleado, tipo_calculo,
            tipo_planilla, numero_planilla, year)
        from nomctrac
        where tipo_planilla = new.tipo_planilla
        and numero_planilla = new.numero_planilla
        and year = new.year
        and no_cheque is null
        group by compania, codigo_empleado, tipo_calculo, tipo_planilla, numero_planilla, year;
    end if;

    return new;
end;
' language plpgsql;


create trigger t_nomtpla2_update after update on nomtpla2
for each row execute procedure f_nomtpla2_update();
*/


create trigger t_nomhoras_before_insert before insert or update on nomhoras
for each row execute procedure f_nomhoras_before_insert();

create trigger t_nomctrac_after_insert_update after insert or update on nomctrac
for each row execute procedure f_nomctrac_after_insert_update();

create trigger t_rhuempl_before_insert before insert on rhuempl
for each row execute procedure f_rhuempl_before_insert();

create trigger t_rhuempl_before_update before update on rhuempl
for each row execute procedure f_rhuempl_before_update();

create trigger t_rhuempl_after_update after update on rhuempl
for each row execute procedure f_rhuempl_after_update();

create trigger t_rhuempl_after_insert after insert on rhuempl
for each row execute procedure f_rhuempl_after_insert();

create trigger t_nomctrac_before_insert before insert on nomctrac
for each row execute procedure f_nomctrac_before_insert();

create trigger t_nomctrac_before_delete before delete on nomctrac
for each row execute procedure f_nomctrac_before_delete();

create trigger t_nomhrtrab_before_delete before delete on nomhrtrab
for each row execute procedure f_nomhrtrab_before_delete();

create trigger t_nomhrtrab_before_before before update on nomhrtrab
for each row execute procedure f_nomhrtrab_before_update();

create trigger t_nomhrtrab_before_insert before insert on nomhrtrab
for each row execute procedure f_nomhrtrab_before_insert();

create trigger t_rela_nomctrac_cglposteo_delete before delete on rela_nomctrac_cglposteo
for each row execute procedure f_rela_nomctrac_cglposteo_before_delete();

create trigger t_rela_nomctrac_cglposteo_before_delete after delete on rela_nomctrac_cglposteo
for each row execute procedure f_rela_nomctrac_cglposteo_delete();


create trigger t_nomctrac_update after insert or update on nomctrac
for each row execute procedure f_nomctrac_update();

create trigger t_rela_pla_reservas_cglposteo_delete after delete on rela_pla_reservas_cglposteo
for each row execute procedure f_rela_pla_reservas_cglposteo_delete();

create trigger t_pla_reservas_update after insert or update on pla_reservas
for each row execute procedure f_pla_reservas_update();

create trigger t_pla_vacacion_after_update after insert or update on pla_vacacion
for each row execute procedure f_pla_vacacion_after_update();

create trigger t_pla_vacacion_after_delete after delete on pla_vacacion
for each row execute procedure f_pla_vacacion_after_delete();

create trigger t_rhuacre_after_update after update on rhuacre
for each row execute procedure f_rhuacre_after_insert();

create trigger t_rhuacre_after_insert after insert on rhuacre
for each row execute procedure f_rhuacre_after_insert();

create trigger t_rhuacre_before_insert before insert on rhuacre
for each row execute procedure f_rhuacre_before_insert();

create trigger t_rhuacre_before_update before update on rhuacre
for each row execute procedure f_rhuacre_before_update();



