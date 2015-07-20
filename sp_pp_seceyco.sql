

set search_path to planilla;

drop function f_pla_dinero_seceyco() cascade;

create function f_pla_dinero_seceyco() returns integer as '
declare
    r_pla_dinero record;
    r_v_pla_horas_valorizadas_old record;
    r_v_pla_horas_valorizadas record;
    r_pla_periodos record;
    r_pla_tipos_de_horas record;
    r_pla_horas record;
    r_pla_conceptos record;
    lvc_proyecto varchar(100);
    ldc_monto decimal;
    ldc_monto_acum decimal;
    ldc_horas decimal;
    ldc_tasa_por_hora decimal;
    ldc_recargo decimal;
    li_signo integer;
    ld_fecha date;
begin

/*
                            and pla_dinero.codigo_empleado = ''37''
                            and pla_dinero.id_periodos = 320912
*/
    
    delete from pla_dinero_seceyco;
    
    for r_pla_dinero in select pla_dinero.* from pla_dinero, pla_periodos
                            where pla_periodos.id = pla_dinero.id_periodos
                            and pla_dinero.compania = 1046
                            and pla_periodos.dia_d_pago >= ''2014-04-01''
                            and pla_dinero.tipo_de_calculo = ''1''
                            order by pla_dinero.codigo_empleado
    loop
        lvc_proyecto    =   ''PANAMA'';
        ldc_recargo     =   0;
        
        select into r_pla_conceptos *
        from pla_conceptos
        where concepto = r_pla_dinero.concepto;
        li_signo    =   r_pla_conceptos.signo;
        
        select into r_pla_periodos *
        from pla_periodos
        where id = r_pla_dinero.id_periodos;
        ld_fecha    =   r_pla_periodos.dia_d_pago;
        
        ldc_monto = 0;
        select sum(monto) into ldc_monto
        from v_pla_horas_valorizadas_old
        where compania = r_pla_dinero.compania
        and codigo_empleado = r_pla_dinero.codigo_empleado
        and tipo_de_calculo = ''1''
        and id_periodos = r_pla_dinero.id_periodos
        and id_pla_proyectos = r_pla_dinero.id_pla_proyectos
        and concepto = r_pla_dinero.concepto;
        if ldc_monto is null then
            ldc_monto = 0;
        end if;


        
        if ldc_monto = r_pla_dinero.monto then


            for r_v_pla_horas_valorizadas_old in select * from v_pla_horas_valorizadas_old
                                                    where compania = r_pla_dinero.compania
                                                    and codigo_empleado = r_pla_dinero.codigo_empleado
                                                    and tipo_de_calculo = ''1''
                                                    and id_pla_proyectos = r_pla_dinero.id_pla_proyectos
                                                    and id_periodos = r_pla_dinero.id_periodos
                                                    and concepto = r_pla_dinero.concepto
            loop
                select into r_pla_tipos_de_horas *
                from pla_tipos_de_horas
                where tipo_de_hora = r_v_pla_horas_valorizadas_old.tipo_de_hora;
                        
                ldc_recargo = r_pla_tipos_de_horas.recargo;

                
                ldc_monto           =   r_v_pla_horas_valorizadas_old.monto;
                ldc_horas           =   r_v_pla_horas_valorizadas_old.minutos / 60.00000;
                
                ldc_tasa_por_hora   =   0;
                
                if ldc_horas > 0 then
                    ldc_tasa_por_hora = (ldc_monto / ldc_horas) / r_pla_tipos_de_horas.recargo;
                end if;                    
                
                if r_v_pla_horas_valorizadas_old.id_pla_proyectos = 1838 then
                    lvc_proyecto = ''GUPCP'';
                elsif r_v_pla_horas_valorizadas_old.id_pla_proyectos =  2012 then
                        lvc_proyecto = ''GUPCA'';
                else
                        lvc_proyecto = ''PANAMA'';
                end if;

                
                if (trim(lvc_proyecto) = ''GUPCP'' or trim(lvc_proyecto) = ''GUPCA'') and
                    r_v_pla_horas_valorizadas_old.tipo_de_hora = ''00'' then

                    ldc_monto_acum = 0;
                    for r_pla_horas in select pla_horas.* 
                                        from pla_horas, pla_marcaciones, pla_tarjeta_tiempo
                                        where pla_tarjeta_tiempo.id = pla_marcaciones.id_tarjeta_de_tiempo
                                        and pla_marcaciones.id = pla_horas.id_marcaciones
                                        and pla_tarjeta_tiempo.compania = r_pla_dinero.compania
                                        and pla_tarjeta_tiempo.codigo_empleado = r_pla_dinero.codigo_empleado
                                        and pla_tarjeta_tiempo.id_periodos = r_v_pla_horas_valorizadas_old.id_periodos
                                        and date(pla_marcaciones.entrada) = r_v_pla_horas_valorizadas_old.fecha
                                        and pla_horas.tipo_de_hora = ''00''
                                        order by pla_horas.tasa_por_minuto
                    loop                                        
                        ldc_horas           =   r_pla_horas.minutos / 60.0000000;
                        if r_v_pla_horas_valorizadas_old.minutos <> 0 then
                            ldc_tasa_por_hora   =   (r_v_pla_horas_valorizadas_old.monto / r_v_pla_horas_valorizadas_old.minutos) * 60;
                        else
                            ldc_tasa_por_hora   =   0;
                        end if;                            
                        ldc_monto           =   ldc_tasa_por_hora * ldc_horas;
                        
                        if ldc_monto = 0 then
                            continue;
                        end if;


                        if ldc_horas <= 1.5 then
                            insert into pla_dinero_seceyco(id_pla_dinero, proyecto, concepto,
                                tipo_de_hora, tasa_por_hora, monto, horas, fecha, recargo)
                            values(r_pla_dinero.id, ''PANAMA'', r_pla_dinero.concepto,
                                r_v_pla_horas_valorizadas_old.tipo_de_hora, ldc_tasa_por_hora, ldc_monto*li_signo, 
                                ldc_horas*li_signo, r_v_pla_horas_valorizadas_old.fecha, ldc_recargo);
                            ldc_monto_acum = ldc_monto_acum + ldc_monto;                                
                        else
                            ldc_monto           =   r_v_pla_horas_valorizadas_old.monto - ldc_monto_acum;
                            ldc_tasa_por_hora   =   ldc_monto / ldc_horas;
                            insert into pla_dinero_seceyco(id_pla_dinero, proyecto, concepto,
                                tipo_de_hora, tasa_por_hora, monto, horas, fecha, recargo)
                            values(r_pla_dinero.id, lvc_proyecto, r_pla_dinero.concepto,
                                r_v_pla_horas_valorizadas_old.tipo_de_hora, ldc_tasa_por_hora, 
                                ldc_monto*li_signo, ldc_horas*li_signo, r_v_pla_horas_valorizadas_old.fecha, ldc_recargo);
                        end if;
                    end loop;
                
                    continue;    
                end if;

                if ldc_monto <> 0 then
                    insert into pla_dinero_seceyco(id_pla_dinero, proyecto, concepto,
                        tipo_de_hora, tasa_por_hora, monto, horas, fecha, recargo)
                    values(r_pla_dinero.id, lvc_proyecto, r_pla_dinero.concepto,
                        r_v_pla_horas_valorizadas_old.tipo_de_hora, ldc_tasa_por_hora, ldc_monto*li_signo, 
                        ldc_horas*li_signo, r_v_pla_horas_valorizadas_old.fecha, ldc_recargo);
                end if;                        
            end loop;        

            continue;                    

        end if;
        
            insert into planilla.pla_dinero_seceyco(id_pla_dinero, proyecto, concepto,
                tipo_de_hora, tasa_por_hora, monto, horas, fecha, recargo)
            values(r_pla_dinero.id, lvc_proyecto, r_pla_dinero.concepto,
                null, 0, r_pla_dinero.monto*li_signo, 0, ld_fecha, ldc_recargo);
                
    end loop;
    
    return 1;
end;
' language plpgsql;


/*
                    ldc_tasa_por_hora = 0;
                    select avg(pla_horas.tasa_por_minuto)*60 into ldc_tasa_por_hora
                    from pla_horas, pla_marcaciones, pla_tarjeta_tiempo
                    where pla_tarjeta_tiempo.id = pla_marcaciones.id_tarjeta_de_tiempo
                    and pla_marcaciones.id = pla_horas.id_marcaciones
                    and pla_tarjeta_tiempo.compania = r_pla_dinero.compania
                    and pla_tarjeta_tiempo.codigo_empleado = r_pla_dinero.codigo_empleado
                    and pla_tarjeta_tiempo.id_periodos = r_v_pla_horas_valorizadas_old.id_periodos
                    and date(pla_marcaciones.entrada) = r_v_pla_horas_valorizadas_old.fecha
                    and pla_horas.tipo_de_hora = ''00'';
                    
                    if ldc_tasa_por_hora is null then
                        ldc_tasa_por_hora = 0;
                    end if;
*/                    

