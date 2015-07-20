drop function f_caja_trx1_cglposteo(char(3), int4);
drop function f_postea_caja_menuda(char(2)) cascade;
drop function f_caja_trx2(char(3), int4, int4, char(10)) cascade;
drop function f_cerrar_caj(char(2),int4, int4) cascade;


create function f_cerrar_caj(char(2),int4, int4) returns integer as '
declare
    as_cia alias for $1;
    ai_anio alias for $2;
    ai_mes alias for $3;
    r_work record;
    r_gralperiodos record;
    r_cajas_balance record;
    ldc_balance_inicio decimal;
    ldc_debito decimal;
    ldc_credito decimal;
begin

    select into r_gralperiodos *
    from gralperiodos
    where compania = as_cia
    and aplicacion = ''CAJ''
    and year = ai_anio
    and periodo = ai_mes;
    if not found then
        Raise Exception ''No existe Anio % y Mes % en Inventario'',ai_anio, ai_mes;
    end if;
    
    if r_gralperiodos.estado <> ''A'' then
        return 0;
    end if;

	delete from cajas_balance
	where compania = as_cia
	and year = ai_anio
	and periodo = ai_mes;


    for r_work in select caja_trx1.caja, sum(caja_trx1.monto*caja_tipo_trx.signo) as monto
                    from caja_trx1, caja_tipo_trx, cajas
                    where cajas.caja = caja_trx1.caja
                    and caja_trx1.tipo_trx = caja_tipo_trx.tipo_trx
                    and fecha_posteo between r_gralperiodos.inicio and r_gralperiodos.final
                    and caja_trx1.monto <> 0
                    and cajas.compania = as_cia
                    group by 1
                    order by 1
    loop
  
        if r_work.monto > 0 then
            ldc_debito  =   r_work.monto;
            ldc_credito = 0;
        else
            ldc_debito  =   0;
            ldc_credito =   -r_work.monto;
        end if;
        
        ldc_balance_inicio = 0;
        select sum(caja_trx1.monto*caja_tipo_trx.signo) into ldc_balance_inicio
        from caja_trx1, caja_tipo_trx, cajas
        where cajas.caja = caja_trx1.caja
        and caja_trx1.tipo_trx = caja_tipo_trx.tipo_trx
        and fecha_posteo < r_gralperiodos.inicio 
        and cajas.caja = r_work.caja
        and caja_trx1.monto <> 0
        and cajas.compania = as_cia;
        if ldc_balance_inicio is null then
            ldc_balance_inicio = 0;
        end if;

        select into r_cajas_balance *
        from cajas_balance
        where caja = r_work.caja
        and compania = as_cia
        and aplicacion = ''CAJ''
        and year = ai_anio
        and periodo = ai_mes;
        if not found then
            insert into cajas_balance(caja, compania, aplicacion, year, periodo, balance_inicial,
                debe, haber)
            values(r_work.caja, as_cia, ''CAJ'', ai_anio, ai_mes, ldc_balance_inicio, ldc_debito, ldc_credito);                
        end if;
        
    end loop;


    return f_cerrar_aplicacion(as_cia, ''CAJ'', ai_anio, ai_mes);
end;
' language plpgsql;    



create function f_caja_trx2(char(3), int4, int4, char(10)) returns decimal(12,2) as '
declare
    ac_caja alias for $1;
    ai_numero_trx alias for $2;
    ai_linea alias for $3;
    ac_recuperar alias for $4;
    ldc_retorno decimal;
    ldc_itbms decimal;
    ldc_compra decimal;
    ldc_monto decimal;
    li_lineas int4;
    r_caja_trx2 record;
begin
    ldc_retorno = 0;
    ldc_itbms = 0;
    ldc_compra = 0;
    li_lineas = 0;
    ldc_monto = 0;
    
    select into r_caja_trx2 caja_trx2.*
    from caja_trx2, cglauxiliares
    where caja_trx2.auxiliar_1 = cglauxiliares.auxiliar
    and caja_trx2.caja = ac_caja
    and caja_trx2.numero_trx = ai_numero_trx
    and caja_trx2.linea = ai_linea;
    if not found then
        return 0;
    end if;
    
    select count(*) into li_lineas from caja_trx2
    where caja = ac_caja
    and numero_trx = ai_numero_trx;
    if li_lineas is null then
        li_lineas = 0;
    end if;
    

    if li_lineas = 0 then
        return 0;
    end if;
    
    select sum(caja_trx2.monto) into ldc_itbms
    from caja_trx2, gral_impuestos, caja_trx1, caja_tipo_trx
    where caja_tipo_trx.tipo_trx = caja_trx1.tipo_trx
    and caja_trx1.caja = caja_trx2.caja
    and caja_trx1.numero_trx = caja_trx2.numero_trx
    and gral_impuestos.cuenta = caja_trx2.cuenta
    and caja_trx1.caja = ac_caja
    and caja_trx1.numero_trx = ai_numero_trx
    and caja_tipo_trx.signo < 0;
    if ldc_itbms is null then
        ldc_itbms = 0;
    end if;
    

    select sum(caja_trx2.monto) into ldc_monto
    from caja_trx2, caja_trx1, caja_tipo_trx
    where caja_tipo_trx.tipo_trx = caja_trx1.tipo_trx
    and caja_trx1.caja = caja_trx2.caja
    and caja_trx1.numero_trx = caja_trx2.numero_trx
    and caja_trx1.caja = ac_caja
    and caja_trx1.numero_trx = ai_numero_trx
    and caja_tipo_trx.signo < 0
    and caja_trx2.cuenta not in (select cuenta from gral_impuestos);
    if ldc_monto is null then
        ldc_monto = 0;
    end if;

    
    if li_lineas <= 2 then
        if trim(ac_recuperar) = ''ITBMS'' then
            return ldc_itbms;
        else
            return ldc_monto;
        end if;
    end if;
    

    select into r_caja_trx2 *
    from caja_trx2
    where caja = ac_caja
    and numero_trx = ai_numero_trx;
    if not found then
        return 0;
    end if;
    
    if trim(ac_recuperar) = ''ITBMS'' then
        return ldc_itbms * (r_caja_trx2.monto/ldc_monto);
    else
        return r_caja_trx2.monto;
    end if;
    
    if ldc_retorno is null then
       ldc_retorno = 0;
    end if;
    
    return ldc_retorno;
end;
' language plpgsql;


create function f_postea_caja_menuda(char(2)) returns integer as '
declare
    as_cia alias for $1;
    r_caja_trx1 record;
    i integer;
    ld_fecha date;
begin
    select into ld_fecha Min(inicio) from gralperiodos
    where compania = as_cia
    and aplicacion = ''CAJ''
    and estado = ''A'';
    if not found then
        return 0;
    end if;

    
    for r_caja_trx1 in select * from caja_trx1
                    where caja in (select caja from cajas where compania = as_cia)
                    and fecha_posteo >= ld_fecha
                    and not exists
                        (select * from rela_caja_trx1_cglposteo
                        where rela_caja_trx1_cglposteo.caja = caja_trx1.caja
                        and rela_caja_trx1_cglposteo.numero_trx = caja_trx1.numero_trx)
                    order by fecha_posteo
    loop
        i = f_caja_trx1_cglposteo(r_caja_trx1.caja, r_caja_trx1.numero_trx);
    end loop;
    
    return 1;
end;
' language plpgsql;



create function f_caja_trx1_cglposteo(char(3), int4) returns integer as '
declare
    as_caja alias for $1;
    ai_numero_trx alias for $2;
    li_consecutivo int4;
    r_cajas record;
    r_caja_trx1 record;
    r_caja_trx2 record;
    r_work record;
    r_cglcuentas record;
    r_caja_tipo_trx record;
    ldc_sum_caja_trx1 decimal(10,2);
    ldc_sum_caja_trx2 decimal(10,2);
begin
    select into r_caja_trx1 * from caja_trx1
    where caja = as_caja
    and numero_trx = ai_numero_trx;
    if not found then
       return 0;
    end if;
    
    select into ldc_sum_caja_trx1 monto from caja_trx1
    where caja = as_caja
    and numero_trx = ai_numero_trx;
    
    select into ldc_sum_caja_trx2 sum(monto) from caja_trx2
    where caja = as_caja
    and numero_trx = ai_numero_trx;
    if ldc_sum_caja_trx2 is null then
       ldc_sum_caja_trx2 := 0;
    end if;
    
    if ldc_sum_caja_trx1 <> ldc_sum_caja_trx2 then
       raise exception ''Transaccion % esta desbalanceada...Verifique'',ai_numero_trx;
    end if;
    
    delete from rela_caja_trx1_cglposteo
    where caja = r_caja_trx1.caja
    and numero_trx = r_caja_trx1.numero_trx;

    
    select into r_caja_tipo_trx * from caja_tipo_trx
    where tipo_trx = r_caja_trx1.tipo_trx;
    
    select into r_cajas * from cajas
    where caja = r_caja_trx1.caja;
    

    if r_caja_trx1.concepto is null then
       r_caja_trx1.concepto := ''CAJA  '' || trim(r_caja_trx1.caja) || '' NUMERO DE TRANSACCION '' || r_caja_trx1.numero_trx;
    else
       r_caja_trx1.concepto := trim(r_caja_trx1.concepto) || ''CAJA  '' || trim(r_caja_trx1.caja) || ''  NUMERO DE TRANSACCION  '' || r_caja_trx1.numero_trx;
    end if;
    
    
    li_consecutivo := f_cglposteo(r_cajas.compania, ''CAJ'', r_caja_trx1.fecha_posteo, 
                            r_cajas.cuenta, r_cajas.auxiliar_1, null,
                            r_caja_tipo_trx.tipo_comp, r_caja_trx1.concepto, 
                            (r_caja_trx1.monto*r_caja_tipo_trx.signo));
    if li_consecutivo > 0 then
        insert into rela_caja_trx1_cglposteo (consecutivo, numero_trx, caja)
        values (li_consecutivo, r_caja_trx1.numero_trx, r_caja_trx1.caja);
    end if;
    
    for r_work in select caja_trx2.cuenta, caja_trx2.auxiliar_1, caja_trx2.auxiliar_2, caja_trx2.monto
                    from caja_trx2
                    where caja_trx2.caja = r_caja_trx1.caja
                    and caja_trx2.numero_trx = r_caja_trx1.numero_trx
                    order by 1
    loop
        select into r_cglcuentas cglcuentas.* from cglcuentas
        where trim(cuenta) = trim(r_work.cuenta)
        and auxiliar_1 = ''S'';
        if found then
            if r_work.auxiliar_1 is null then
                Raise Exception ''Codigo de Auxiliar en Obligatorio en la cuenta % de la transaccion %'', r_work.cuenta, r_caja_trx1.numero_trx;
            end if;
        end if;
        
        li_consecutivo := f_cglposteo(r_cajas.compania, ''CAJ'', r_caja_trx1.fecha_posteo, 
                            r_work.cuenta, r_work.auxiliar_1, r_work.auxiliar_2,
                            r_caja_tipo_trx.tipo_comp, r_caja_trx1.concepto, 
                            -(r_work.monto*r_caja_tipo_trx.signo));
        if li_consecutivo > 0 then
           insert into rela_caja_trx1_cglposteo (consecutivo, numero_trx, caja)
           values (li_consecutivo, r_caja_trx1.numero_trx, r_caja_trx1.caja);
        end if;
    end loop;

    return 1;
end;
' language plpgsql;
