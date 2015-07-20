drop function f_bcocheck1_bcocircula(char(2), char(2), int4) cascade;
drop function f_bcotransac1_bcocircula(char(2), int4) cascade;
drop function f_bcotransac1_cglposteo(char(3), int4);
drop function f_bcocheck1_cglposteo(char(3), char(2), int4);
drop function f_postea_bco(char(2)) cascade;
drop function f_bcocheck2(char(2), char(2), int4, int4, char(10)) cascade;
-- drop function f_bco_conciliacion(char(2), date, date) cascade;
drop function f_bco_conciliacion_bco_gral(char(2), date, date) cascade;
drop function f_cerrar_bco(char(2),int4, int4) cascade;


create function f_cerrar_bco(char(2),int4, int4) returns integer as '
declare
    as_cia alias for $1;
    ai_anio alias for $2;
    ai_mes alias for $3;
    r_work record;
    r_gralperiodos record;
    r_bcobalance record;
    ldc_balance_inicial decimal;
    ldc_debito decimal;
    ldc_credito decimal;
begin

    select into r_gralperiodos *
    from gralperiodos
    where compania = as_cia
    and aplicacion = ''BCO''
    and year = ai_anio
    and periodo = ai_mes;
    if not found then
        Raise Exception ''No existe Anio % y Mes % en Inventario'',ai_anio, ai_mes;
    end if;
    
    if r_gralperiodos.estado <> ''A'' then
        return 0;
    end if;

	delete from bcobalance
	where compania = as_cia
	and year = ai_anio
	and periodo = ai_mes;

    for r_work in select v_bcocircula.cod_ctabco, sum(monto*bcomotivos.signo) as monto
                    from v_bcocircula, bcomotivos, bcoctas
                    where v_bcocircula.cod_ctabco = bcoctas.cod_ctabco
                    and v_bcocircula.motivo_bco = bcomotivos.motivo_bco
                    and fecha_posteo between r_gralperiodos.inicio and r_gralperiodos.final
                    and monto <> 0
                    and bcoctas.compania = as_cia
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
        
        ldc_balance_inicial = 0;
        select sum(v_bcocircula.monto*bcomotivos.signo) into ldc_balance_inicial
        from v_bcocircula, bcomotivos, bcoctas
        where v_bcocircula.cod_ctabco = bcoctas.cod_ctabco
        and v_bcocircula.motivo_bco = bcomotivos.motivo_bco
        and fecha_posteo < r_gralperiodos.inicio 
        and monto <> 0
        and bcoctas.compania = as_cia;
        if ldc_balance_inicial is null then
            ldc_balance_inicial = 0;
        end if;

        select into r_bcobalance *
        from bcobalance
        where cod_ctabco = r_work.cod_ctabco
        and compania = as_cia
        and aplicacion = ''CAJ''
        and year = ai_anio
        and periodo = ai_mes;
        if not found then
            insert into bcobalance(cod_ctabco, compania, aplicacion, year, periodo, balance_inicial,
                debe, haber, cheques)
            values(r_work.cod_ctabco, as_cia, ''BCO'', ai_anio, 
                ai_mes, ldc_balance_inicial, ldc_debito, ldc_credito, 0);                
        end if;
    end loop;


    return f_cerrar_aplicacion(as_cia, ''BCO'', ai_anio, ai_mes);
end;
' language plpgsql;    


create function f_bco_conciliacion_bco_gral(char(2), date, date) returns integer as '
declare
    ac_cod_ctabco alias for $1;
    ad_desde alias for $2;
    ad_hasta alias for $3;
    r_bco_conciliacion_tmp record;
    r_bco_conciliacion record;
    r_bcocircula record;
    r_bcoctas record;
    lvc_work varchar(100);
    lvc_numero varchar(100);
    ld_fecha date;
    ld_ultimo_cierre date;
    li_anio integer;
    li_mes integer;
    li_dia integer;
    ldc_debito decimal;
    ldc_credito decimal;
    li_no_docmto_sys int4;
    li_largo int4;
    lc_work char(1);
begin
    delete from bco_conciliacion
    where usuario = current_user;
    
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

        ld_fecha                    =   f_to_date(li_anio, li_mes, li_dia);

        if ld_fecha > ad_hasta then
            continue;
        end if;
        
        
        if r_bco_conciliacion_tmp.c4 is null then
            ldc_debito = 0;
        else
            ldc_debito  =   f_string_to_decimal(r_bco_conciliacion_tmp.c4);
        end if;

        if r_bco_conciliacion_tmp.c5 is null then
            ldc_credito = 0;
        else
            ldc_credito  =   f_string_to_decimal(r_bco_conciliacion_tmp.c5);
        end if;
    
           
        if r_bco_conciliacion_tmp.c2 is null then
            r_bco_conciliacion_tmp.c2 = ''  '';
        end if;

--        raise exception ''%'', ldc_debito;
                        
        insert into bco_conciliacion(cod_ctabco, fecha,
            descripcion, documento, debito, credito, conciliado, usuario)
        values (ac_cod_ctabco, ld_fecha, 
            trim(r_bco_conciliacion_tmp.c3),
            trim(r_bco_conciliacion_tmp.c2),
            ldc_debito, ldc_credito, ''N'', current_user);
            
    end loop;        

    
    delete from bco_conciliacion
    where usuario = current_user
    and fecha not between ad_desde and ad_hasta;


    for r_bco_conciliacion in select * 
                    from bco_conciliacion
                    where usuario = current_user
                    and fecha >= ad_desde
                    order by id
    loop
    
        li_largo            =   Length(Trim(r_bco_conciliacion.documento));
        li_no_docmto_sys    =   0;
        if li_largo > 1 then
            li_largo            =   li_largo - 1;
            li_no_docmto_sys    =  f_string_to_integer(r_bco_conciliacion.documento);
        end if;


        select into r_bcocircula *
        from bcocircula, bcomotivos
        where bcocircula.motivo_bco = bcomotivos.motivo_bco
        and bcomotivos.aplica_cheques = ''S''
        and trim(cod_ctabco) = trim(ac_cod_ctabco)
        and bcocircula.no_docmto_sys = li_no_docmto_sys 
        and monto = r_bco_conciliacion.debito;
        if found then
            if r_bcocircula.status = ''C'' then
                update bco_conciliacion
                set conciliado = ''S''
                where id = r_bco_conciliacion.id;
                continue;
            end if;
            
            update bcocircula
            set status = ''C'', fecha_conciliacion = r_bco_conciliacion.fecha
            where cod_ctabco = r_bcocircula.cod_ctabco
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
        and monto = r_bco_conciliacion.credito
        and fecha_posteo between ad_desde and ad_hasta;
        if found then
            update bco_conciliacion
            set conciliado = ''S''
            where id = r_bco_conciliacion.id;

            update bcocircula
            set status = ''C'', fecha_conciliacion = r_bco_conciliacion.fecha
            where cod_ctabco = r_bcocircula.cod_ctabco
            and motivo_bco = r_bcocircula.motivo_bco
            and no_docmto_sys = r_bcocircula.no_docmto_sys
            and fecha_posteo = r_bcocircula.fecha_posteo;

        end if;


        if substring(trim(r_bco_conciliacion.descripcion) from 1 for 3) = ''ATM'' then        
/*
                if r_bco_conciliacion.debito = 500 then
                    raise exception ''nentre % % '', r_bco_conciliacion.descripcion, r_bco_conciliacion.fecha;
                end if;
*/
                
            select into r_bcocircula *
            from bcocircula, bcomotivos
            where bcocircula.motivo_bco = bcomotivos.motivo_bco
            and bcomotivos.signo = -1
            and cod_ctabco = ac_cod_ctabco
            and monto = r_bco_conciliacion.debito
            and fecha_posteo = r_bco_conciliacion.fecha;
            if found then
                
                update bco_conciliacion
                set conciliado = ''S''
                where id = r_bco_conciliacion.id;


                update bcocircula
                set status = ''C'', fecha_conciliacion = r_bco_conciliacion.fecha
                where cod_ctabco = r_bcocircula.cod_ctabco
                and motivo_bco = r_bcocircula.motivo_bco
                and no_docmto_sys = r_bcocircula.no_docmto_sys
                and fecha_posteo = r_bcocircula.fecha_posteo;

            end if;
        else
            select into r_bcocircula *
            from bcocircula, bcomotivos
            where bcocircula.motivo_bco = bcomotivos.motivo_bco
            and bcomotivos.signo = -1
            and cod_ctabco = ac_cod_ctabco
            and monto = r_bco_conciliacion.debito
            and fecha_posteo between ad_desde and ad_hasta;
            if found then
                update bco_conciliacion
                set conciliado = ''S''
                where id = r_bco_conciliacion.id;


                update bcocircula
                set status = ''C'', fecha_conciliacion = r_bco_conciliacion.fecha
                where cod_ctabco = r_bcocircula.cod_ctabco
                and motivo_bco = r_bcocircula.motivo_bco
                and no_docmto_sys = r_bcocircula.no_docmto_sys
                and fecha_posteo = r_bcocircula.fecha_posteo;

            end if;
        
        end if;
    end loop;

    return 1;
end;
' language plpgsql;

create function f_bcocheck2(char(2), char(2), int4, int4, char(10)) returns decimal(12,2) as '
declare
    ac_cod_ctabco alias for $1;
    ac_motivo_bco alias for $2;
    ai_no_cheque alias for $3;
    ai_linea alias for $4;
    ac_recuperar alias for $5;
    ldc_retorno decimal;
    ldc_itbms decimal;
    ldc_compra decimal;
    li_lineas int4;
    r_caja_trx2 record;
    r_bcocheck2 record;
begin
    ldc_retorno = 0;
    ldc_itbms = 0;
    ldc_compra = 0;
    li_lineas = 0;
    
    select into r_bcocheck2 *
    from bcocheck2
    where cod_ctabco = ac_cod_ctabco
    and motivo_bco = ac_motivo_bco
    and no_cheque = ai_no_cheque
    and linea = ai_linea;
    if not found then 
        return 0;
    end if;
    
      
    select count(*) into li_lineas 
    from bcocheck2
    where cod_ctabco = ac_cod_ctabco
    and motivo_bco = ac_motivo_bco
    and no_cheque = ai_no_cheque;
    if li_lineas is null then
        li_lineas = 0;
    end if;
    

    if li_lineas = 0 then
        return 0;
    end if;
    
    select sum(bcocheck2.monto) into ldc_itbms
    from bcocheck2, gral_impuestos, bcocheck1
    where bcocheck1.cod_ctabco = bcocheck2.cod_ctabco
    and bcocheck1.motivo_bco = bcocheck2.motivo_bco
    and bcocheck1.no_cheque = bcocheck2.no_cheque
    and bcocheck2.cuenta = gral_impuestos.cuenta
    and bcocheck1.cod_ctabco = ac_cod_ctabco
    and bcocheck1.motivo_bco = ac_motivo_bco
    and bcocheck1.no_cheque = ai_no_cheque;
    
    
    select sum(bcocheck2.monto) into ldc_compra
    from bcocheck2, bcocheck1, cglauxiliares
    where bcocheck1.cod_ctabco = bcocheck2.cod_ctabco
    and bcocheck1.motivo_bco = bcocheck2.motivo_bco
    and bcocheck1.no_cheque = bcocheck2.no_cheque
    and bcocheck2.auxiliar1 = cglauxiliares.auxiliar
    and bcocheck1.cod_ctabco = ac_cod_ctabco
    and bcocheck1.motivo_bco = ac_motivo_bco
    and bcocheck1.no_cheque = ai_no_cheque ;
    if ldc_compra is null then
        ldc_compra = 0;
    end if;
    
    
    if li_lineas <= 2 then
        if trim(ac_recuperar) = ''ITBMS'' then
            return ldc_itbms;
        else
            return ldc_compra;
        end if;
    end if;
    

    if trim(ac_recuperar) = ''ITBMS'' then
        return ldc_itbms * (r_bcocheck2.monto/ldc_compra);
    else
        return r_bcocheck2.monto;
    end if;
    
    if ldc_retorno is null then
       ldc_retorno = 0;
    end if;
    
    return ldc_retorno;
end;
' language plpgsql;



create function f_postea_bco(char(2))returns integer as '
declare
    as_cia alias for $1;
    ld_fecha date;
    i integer;
    r_bcocheck1 record;
    r_bcotransac1 record;
begin
    select into ld_fecha Min(inicio) from gralperiodos
    where compania = as_cia
    and aplicacion = ''BCO''
    and estado = ''A'';
    if not found then
        return 0;
    end if;
    
    
    for r_bcocheck1 in select bcocheck1.* from bcocheck1, bcoctas, bcomotivos
                    where bcocheck1.cod_ctabco = bcoctas.cod_ctabco
                    and bcocheck1.motivo_bco = bcomotivos.motivo_bco
                    and bcocheck1.fecha_posteo >= ld_fecha
                    and bcomotivos.aplica_cheques = ''S''
                    and bcocheck1.status <> ''A''
                    and bcoctas.compania = as_cia
                    and not exists
                        (select * from rela_bcocheck1_cglposteo
                        where rela_bcocheck1_cglposteo.cod_ctabco = bcocheck1.cod_ctabco
                        and rela_bcocheck1_cglposteo.motivo_bco = bcocheck1.motivo_bco
                        and rela_bcocheck1_cglposteo.no_cheque = bcocheck1.no_cheque)
                    order by bcocheck1.fecha_posteo
    loop
        i := f_bcocheck1_cglposteo(r_bcocheck1.cod_ctabco, r_bcocheck1.motivo_bco, r_bcocheck1.no_cheque);
    end loop;        
    
    for r_bcotransac1 in select bcotransac1.* from bcoctas, bcotransac1
                    where bcoctas.cod_ctabco = bcotransac1.cod_ctabco
                    and bcotransac1.fecha_posteo >= ld_fecha
                    and bcoctas.compania = as_cia
                    and not exists
                        (select * from rela_bcotransac1_cglposteo
                        where rela_bcotransac1_cglposteo.cod_ctabco = bcotransac1.cod_ctabco
                        and rela_bcotransac1_cglposteo.sec_transacc = bcotransac1.sec_transacc)
                    order by bcotransac1.fecha_posteo                        
    loop
        i := f_bcotransac1_cglposteo(r_bcotransac1.cod_ctabco, r_bcotransac1.sec_transacc);
    end loop;        
    
return 1;
    
end;
' language plpgsql;    


create function f_bcocheck1_cglposteo(char(3), char(2), int4) returns integer as '
declare
    as_cod_ctabco alias for $1;
    as_motivo_bco alias for $2;
    ai_no_cheque alias for $3;
    li_consecutivo int4;
    li_linea int4;
    r_bcoctas record;
    r_bcocheck1 record;
    r_bcocheck2 record;
    r_cglcuentas record;
    r_work record;
    r_bcomotivos record;
    r_proveedores record;
    r_cglauxiliares record;
    r_bco_cuentas_cheque record;
    ls_auxiliar_1 char(10);
    ldc_sum_bcocheck1 decimal(10,2);
    ldc_sum_bcocheck2 decimal(10,2);
    ldc_sum_bcocheck3 decimal(10,2);
    ldc_work decimal(10,2);
begin
    select into r_bcoctas * from bcoctas
    where trim(cod_ctabco) = trim(as_cod_ctabco);
    
    select into r_bcocheck1 * from bcocheck1
    where cod_ctabco = as_cod_ctabco
    and motivo_bco = as_motivo_bco
    and no_cheque = ai_no_cheque;
    if not found then
       return 0;
    end if;

    if r_bcocheck1.status = ''A'' then
       return 0;
    end if;

    select into r_bcomotivos * from bcomotivos
    where motivo_bco = r_bcocheck1.motivo_bco;
    if r_bcomotivos.solicitud_cheque = ''S'' then
       return 0;
    end if;

    select into ldc_sum_bcocheck1 monto from bcocheck1
    where cod_ctabco = as_cod_ctabco
    and motivo_bco = as_motivo_bco
    and no_cheque = ai_no_cheque;
    
    select into ldc_sum_bcocheck2 sum(monto) from bcocheck2
    where cod_ctabco = as_cod_ctabco
    and motivo_bco = as_motivo_bco
    and no_cheque = ai_no_cheque;
    if ldc_sum_bcocheck2 is null then
       ldc_sum_bcocheck2 := 0;
    end if;
    
    select into ldc_sum_bcocheck3 sum(monto) from bcocheck3
    where cod_ctabco = as_cod_ctabco
    and motivo_bco = as_motivo_bco
    and no_cheque = ai_no_cheque;
    if ldc_sum_bcocheck3 is null then
       ldc_sum_bcocheck3 := 0;
    end if;
    
    if ldc_sum_bcocheck1 <> ldc_sum_bcocheck2 + ldc_sum_bcocheck3 then
       raise exception ''Cheque % esta desbalanceada...Verifique'',r_bcocheck1.no_cheque;
    end if;


    if r_bcocheck1.proveedor is not null then
        
        ldc_work = 0;
     
        select sum(monto) into ldc_work
        from v_cxpdocm
        where trim(compania) = trim(r_bcoctas.compania)
        and trim(proveedor) = trim(r_bcocheck1.proveedor)
        and trim(documento) = trim(to_char(r_bcocheck1.no_cheque, ''9999999999''))
        and trim(motivo_cxp) = trim(r_bcomotivos.motivo_cxp);
        if ldc_work is null then
            ldc_work = 0;
        end if;
        
        if ldc_work <> ldc_sum_bcocheck3 then
            Raise Exception ''Cheque % de Cuenta % tiene inconsistencia con cxpdocm'', ai_no_cheque, as_cod_ctabco;
        end if;
    end if;

        
    delete from rela_bcocheck1_cglposteo
    where cod_ctabco = as_cod_ctabco
    and motivo_bco = as_motivo_bco
    and no_cheque = ai_no_cheque;
    
    delete from bco_cuentas_cheque
    where cod_ctabco = as_cod_ctabco
    and motivo_bco = as_motivo_bco
    and no_cheque = ai_no_cheque;
    
    

    if r_bcocheck1.en_concepto_de is null then
       r_bcocheck1.en_concepto_de := ''CHEQUE # '' || r_bcocheck1.no_cheque || ''  '' || trim(r_bcocheck1.paguese_a);
    else
       r_bcocheck1.en_concepto_de := ''CHEQUE # '' || r_bcocheck1.no_cheque || ''  '' || trim(r_bcocheck1.paguese_a) || ''   '' || trim(r_bcocheck1.en_concepto_de);
    end if;
    
    
    li_consecutivo := f_cglposteo(r_bcoctas.compania, r_bcocheck1.aplicacion, 
                            r_bcocheck1.fecha_posteo, 
                            r_bcoctas.cuenta, null, null,
                            r_bcomotivos.tipo_comp, r_bcocheck1.en_concepto_de, 
                            (r_bcocheck1.monto*r_bcomotivos.signo));
            
    if li_consecutivo > 0 then
        insert into rela_bcocheck1_cglposteo (consecutivo, no_cheque, cod_ctabco, motivo_bco)
        values (li_consecutivo, r_bcocheck1.no_cheque, r_bcocheck1.cod_ctabco, r_bcocheck1.motivo_bco);
    end if;

   
    for r_work in select bcocheck2.cuenta, bcocheck2.auxiliar1, bcocheck2.auxiliar2, bcocheck2.monto
                    from bcocheck2
                    where bcocheck2.cod_ctabco = as_cod_ctabco
                    and bcocheck2.no_cheque = ai_no_cheque
                    and bcocheck2.motivo_bco = as_motivo_bco
                    order by 1
    loop
        li_consecutivo := f_cglposteo(r_bcoctas.compania, r_bcocheck1.aplicacion, r_bcocheck1.fecha_posteo, 
                            r_work.cuenta, r_work.auxiliar1, r_work.auxiliar2,
                            r_bcomotivos.tipo_comp, r_bcocheck1.en_concepto_de,
                            -(r_work.monto*r_bcomotivos.signo));
        if li_consecutivo > 0 then
           insert into rela_bcocheck1_cglposteo (consecutivo, no_cheque, cod_ctabco, motivo_bco)
           values (li_consecutivo, r_bcocheck1.no_cheque, r_bcocheck1.cod_ctabco, r_bcocheck1.motivo_bco);
        end if;
    end loop;
    
    for r_work in select proveedores.cuenta, bcocheck1.proveedor, sum(bcocheck3.monto) as monto
                    from bcocheck1, bcocheck3, proveedores
                    where bcocheck1.cod_ctabco = bcocheck3.cod_ctabco
                    and bcocheck1.no_cheque = bcocheck3.no_cheque
                    and bcocheck1.motivo_bco = bcocheck3.motivo_bco
                    and bcocheck1.proveedor = proveedores.proveedor
                    and bcocheck1.cod_ctabco = as_cod_ctabco
                    and bcocheck1.no_cheque = ai_no_cheque
                    and bcocheck1.motivo_bco = as_motivo_bco
                    group by 1, 2
                    order by 1, 2
    loop
        select into r_cglcuentas * from cglcuentas
        where cuenta = r_work.cuenta
        and auxiliar_1 = ''S'';
        if not found then
            ls_auxiliar_1 := null;
        else
            ls_auxiliar_1 := r_work.proveedor;
            
            select into r_proveedores * from proveedores
            where proveedor = r_work.proveedor;
            
            select into r_cglauxiliares * from cglauxiliares
            where trim(auxiliar) = trim(ls_auxiliar_1);
            if not found then
                insert into cglauxiliares (auxiliar, nombre, tipo_persona, status)
                values (ls_auxiliar_1, trim(r_proveedores.nomb_proveedor), ''1'', ''A'');
            end if;
            
        end if;
    
        li_consecutivo := f_cglposteo(r_bcoctas.compania, r_bcocheck1.aplicacion, r_bcocheck1.fecha_posteo, 
                            r_work.cuenta, ls_auxiliar_1, null,
                            r_bcomotivos.tipo_comp, r_bcocheck1.en_concepto_de,
                            -(r_work.monto*r_bcomotivos.signo));
        if li_consecutivo > 0 then
           insert into rela_bcocheck1_cglposteo (consecutivo, no_cheque, cod_ctabco, motivo_bco)
           values (li_consecutivo, r_bcocheck1.no_cheque, r_bcocheck1.cod_ctabco, r_bcocheck1.motivo_bco);
        end if;
    end loop;
    

    if f_gralparaxcia(r_bcoctas.compania, ''PLA'', ''metodo_calculo'') = ''panamaauto'' then
        for r_work in select cglposteo.cuenta, sum(cglposteo.debito-cglposteo.credito) as monto
                        from rela_bcocheck1_cglposteo, cglposteo
                        where rela_bcocheck1_cglposteo.consecutivo = cglposteo.consecutivo
                        and rela_bcocheck1_cglposteo.cod_ctabco = as_cod_ctabco
                        and rela_bcocheck1_cglposteo.motivo_bco = as_motivo_bco
                        and rela_bcocheck1_cglposteo.no_cheque = ai_no_cheque
                        group by 1
                        order by 2 desc, cuenta
        loop
            li_linea    =   0;
            loop
                li_linea = li_linea + 1;
                select into r_bco_cuentas_cheque * 
                from bco_cuentas_cheque
                where cod_ctabco = as_cod_ctabco
                and motivo_bco = as_motivo_bco
                and no_cheque = ai_no_cheque
                and linea = li_linea;
                if found then
                    if r_bco_cuentas_cheque.cuenta_debito is not null 
                        and r_bco_cuentas_cheque.cuenta_credito is not null then
                        continue;
                    else
                        if r_work.monto >= 0 and 
                            r_bco_cuentas_cheque.cuenta_debito is not null then
                            continue;
                        end if;
                    
                        if r_work.monto < 0 and
                            r_bco_cuentas_cheque.cuenta_credito is not null then
                            continue;
                        end if;
                    end if;
                
                    if r_work.monto >= 0 then
                        update bco_cuentas_cheque
                        set cuenta_debito = r_work.cuenta, monto_debito = r_work.monto
                        where cod_ctabco = as_cod_ctabco
                        and motivo_bco = as_motivo_bco
                        and no_cheque = ai_no_cheque
                        and linea = li_linea;
                    else
                        update bco_cuentas_cheque
                        set cuenta_credito = r_work.cuenta, monto_credito = -r_work.monto
                        where cod_ctabco = as_cod_ctabco
                        and motivo_bco = as_motivo_bco
                        and no_cheque = ai_no_cheque
                        and linea = li_linea;
                    end if;
                else
                    if r_work.monto >= 0 then
                        insert into bco_cuentas_cheque(cod_ctabco, no_cheque, motivo_bco,
                            linea, cuenta_debito, monto_debito, monto_credito)
                        values (as_cod_ctabco, ai_no_cheque, as_motivo_bco, li_linea,
                            r_work.cuenta, r_work.monto, 0);
                    else
                        insert into bco_cuentas_cheque(cod_ctabco, no_cheque, motivo_bco,
                            linea, cuenta_credito, monto_credito, monto_debito)
                        values (as_cod_ctabco, ai_no_cheque, as_motivo_bco, li_linea,
                            r_work.cuenta, -r_work.monto, 0);
                    end if;
                end if;
                exit;
            end loop;
        end loop;
    end if;
    return 1;
end;
' language plpgsql;



create function f_bcotransac1_cglposteo(char(3), int4) returns integer as '
declare
    as_cod_ctabco alias for $1;
    ai_sec_transacc alias for $2;
    li_consecutivo int4;
    r_bcoctas record;
    r_bcotransac1 record;
    r_bcotransac2 record;
    r_work record;
    r_proveedores record;
    r_bcomotivos record;
    ldc_sum_bcotransac1 decimal(10,2);
    ldc_sum_bcotransac2 decimal(10,2);
    ldc_sum_bcotransac3 decimal(10,2);
begin

    select into r_bcotransac1 * from bcotransac1
    where cod_ctabco = as_cod_ctabco
    and sec_transacc = ai_sec_transacc;
    if not found then
       return 0;
    end if;
    
    select into ldc_sum_bcotransac1 monto from bcotransac1
    where cod_ctabco = as_cod_ctabco
    and sec_transacc = ai_sec_transacc;
    
    select into ldc_sum_bcotransac2 sum(monto) from bcotransac2
    where cod_ctabco = as_cod_ctabco
    and sec_transacc = ai_sec_transacc;
    if ldc_sum_bcotransac2 is null then
       ldc_sum_bcotransac2 := 0;
    end if;
    
    select into ldc_sum_bcotransac3 sum(monto) from bcotransac3
    where cod_ctabco = as_cod_ctabco
    and sec_transacc = ai_sec_transacc;
    if ldc_sum_bcotransac3 is null then
       ldc_sum_bcotransac3 := 0;
    end if;
    
    if ldc_sum_bcotransac1 <> ldc_sum_bcotransac2 + ldc_sum_bcotransac3 then
       raise exception ''Transaccion % esta desbalanceada...Verifique'',r_bcotransac1.sec_transacc;
    end if;
    
    
    
    delete from rela_bcotransac1_cglposteo
    where cod_ctabco = r_bcotransac1.cod_ctabco
    and sec_transacc = r_bcotransac1.sec_transacc;
    
    select into r_bcomotivos * from bcomotivos
    where motivo_bco = r_bcotransac1.motivo_bco;
    
    select into r_bcoctas * from bcoctas
    where cod_ctabco = r_bcotransac1.cod_ctabco;
    

    if r_bcotransac1.obs_transac_bco is null then
       r_bcotransac1.obs_transac_bco := ''TRANSACCION #  '' || r_bcotransac1.sec_transacc;
    else
       r_bcotransac1.obs_transac_bco := ''TRANSACCION #  '' || r_bcotransac1.sec_transacc || ''   '' || trim(r_bcotransac1.obs_transac_bco);
    end if;
    
    
    li_consecutivo := f_cglposteo(r_bcoctas.compania, ''BCO'', r_bcotransac1.fecha_posteo, 
                            r_bcoctas.cuenta, r_bcoctas.auxiliar1, r_bcoctas.auxiliar2,
                            r_bcomotivos.tipo_comp, r_bcotransac1.obs_transac_bco, 
                            (r_bcotransac1.monto*r_bcomotivos.signo));
    if li_consecutivo > 0 then
        insert into rela_bcotransac1_cglposteo (consecutivo, sec_transacc, cod_ctabco)
        values (li_consecutivo, r_bcotransac1.sec_transacc, r_bcotransac1.cod_ctabco);
    end if;
    
    for r_work in select bcotransac2.cuenta, bcotransac2.auxiliar1, bcotransac2.auxiliar2, bcotransac2.monto
                    from bcotransac2
                    where bcotransac2.cod_ctabco = r_bcotransac1.cod_ctabco
                    and bcotransac2.sec_transacc = r_bcotransac1.sec_transacc
                    order by 1, 2
    loop
        li_consecutivo := f_cglposteo(r_bcoctas.compania, ''BCO'', r_bcotransac1.fecha_posteo, 
                            r_work.cuenta, r_work.auxiliar1, r_work.auxiliar2,
                            r_bcomotivos.tipo_comp, r_bcotransac1.obs_transac_bco,
                            -(r_work.monto*r_bcomotivos.signo));
        if li_consecutivo > 0 then
           insert into rela_bcotransac1_cglposteo (consecutivo, sec_transacc, cod_ctabco)
           values (li_consecutivo, r_bcotransac1.sec_transacc, r_bcotransac1.cod_ctabco);
        end if;
    end loop;
    
    
    if ldc_sum_bcotransac3 <> 0 then
        select into r_proveedores * from proveedores
        where proveedor = r_bcotransac1.proveedor;
        if not found then
            return 0;
        end if;
        
        li_consecutivo := f_cglposteo(r_bcoctas.compania, ''BCO'', r_bcotransac1.fecha_posteo, 
                            r_proveedores.cuenta, null, null,
                            r_bcomotivos.tipo_comp, r_bcotransac1.obs_transac_bco,
                            -(ldc_sum_bcotransac3*r_bcomotivos.signo));
        if li_consecutivo > 0 then
           insert into rela_bcotransac1_cglposteo (consecutivo, sec_transacc, cod_ctabco)
           values (li_consecutivo, r_bcotransac1.sec_transacc, r_bcotransac1.cod_ctabco);
        end if;
    end if;        

    
    return 1;
end;
' language plpgsql;


create function f_bcocheck1_bcocircula(char(2), char(2), int4) returns integer as '
declare
    as_cod_ctabco alias for $1;
    as_motivo_bco alias for $2;
    ai_no_cheque alias for $3;
    r_bcomotivos record;
    r_bcocircula record;
    r_bcocheck1 record;
begin
    select into r_bcocheck1 * from bcocheck1
    where cod_ctabco = as_cod_ctabco
    and motivo_bco = as_motivo_bco
    and no_cheque = ai_no_cheque;
    if not found then
       return 0;
    end if;
    
    if r_bcocheck1.monto = 0 then
        return 0;
    end if;
    
    if r_bcocheck1.status = ''A'' then
--        return 0;
        r_bcocheck1.monto = 0;
    end if;
    
    select into r_bcomotivos * from bcomotivos
    where motivo_bco = r_bcocheck1.motivo_bco;
    if not found then
       return 0;
    end if;
    
    if r_bcomotivos.aplica_cheques = ''S'' then
        select into r_bcocircula * from bcocircula
        where cod_ctabco = r_bcocheck1.cod_ctabco
        and motivo_bco = r_bcocheck1.motivo_bco
        and no_docmto_sys = r_bcocheck1.no_cheque
        and fecha_posteo = r_bcocheck1.fecha_posteo;
        if not found then
           insert into bcocircula (sec_docmto_circula, cod_ctabco, motivo_bco, proveedor,
            no_docmto_sys, no_docmto_fuente, fecha_transacc, fecha_posteo, status, usuario,
            fecha_captura, a_nombre, desc_documento, monto, aplicacion)
           VALUES (0, r_bcocheck1.cod_ctabco, r_bcocheck1.motivo_bco, r_bcocheck1.proveedor, 
            r_bcocheck1.no_cheque, r_bcocheck1.docmto_fuente, r_bcocheck1.fecha_posteo, 
            r_bcocheck1.fecha_posteo, ''R'', current_user, current_timestamp, 
            r_bcocheck1.paguese_a, r_bcocheck1.en_concepto_de, r_bcocheck1.monto, r_bcocheck1.aplicacion);
        else
           update bcocircula
           set    proveedor             = r_bcocheck1.proveedor,
                  no_docmto_fuente      = r_bcocheck1.docmto_fuente,
                  fecha_transacc        = r_bcocheck1.fecha_posteo,
                  fecha_posteo          = r_bcocheck1.fecha_posteo,
                  usuario               = current_user,
                  fecha_captura         = current_timestamp,
                  a_nombre              = substring(r_bcocheck1.paguese_a from 1 for 60),
                  desc_documento        = r_bcocheck1.en_concepto_de,
                  monto                 = r_bcocheck1.monto
           where  cod_ctabco            = r_bcocheck1.cod_ctabco
           and    motivo_bco            = r_bcocheck1.motivo_bco
           and    no_docmto_sys         = r_bcocheck1.no_cheque
           and    fecha_posteo          = r_bcocheck1.fecha_posteo
           and    status                <> ''C'';
        end if;
    end if;
    return 1;
end;
' language plpgsql;


create function f_bcotransac1_bcocircula(char(2), int4) returns integer as '
declare
    as_cod_ctabco alias for $1;
    ai_sec_transacc alias for $2;
    r_bcotransac1 record;
    r_bcocircula record;
begin
    select into r_bcotransac1 * from bcotransac1
    where cod_ctabco = as_cod_ctabco
    and sec_transacc = ai_sec_transacc;
    if not found then
       return 0;
    end if;
    
    if r_bcotransac1.monto = 0 then
        return 0;
    end if;
    
    select into r_bcocircula * from bcocircula
    where cod_ctabco = r_bcotransac1.cod_ctabco
    and motivo_bco = r_bcotransac1.motivo_bco
    and no_docmto_sys = r_bcotransac1.sec_transacc
    and fecha_posteo = r_bcotransac1.fecha_posteo;
    if not found then
        insert into bcocircula (sec_docmto_circula, cod_ctabco, motivo_bco, proveedor,
        no_docmto_sys, no_docmto_fuente, fecha_transacc, fecha_posteo, status, usuario,
        fecha_captura, a_nombre, desc_documento, monto, aplicacion)
        VALUES (0, r_bcotransac1.cod_ctabco, r_bcotransac1.motivo_bco, r_bcotransac1.proveedor, 
        r_bcotransac1.sec_transacc, r_bcotransac1.no_docmto, r_bcotransac1.fecha_posteo, 
        r_bcotransac1.fecha_posteo, ''R'', current_user, current_timestamp, 
        substring(r_bcotransac1.obs_transac_bco from 1 for 60), 
        r_bcotransac1.obs_transac_bco, r_bcotransac1.monto, ''BCO'');
    else
       update bcocircula
       set    proveedor             = r_bcotransac1.proveedor,
              no_docmto_fuente      = r_bcotransac1.no_docmto,
              fecha_transacc        = r_bcotransac1.fecha_posteo,
              fecha_posteo          = r_bcotransac1.fecha_posteo,
              usuario               = current_user,
              fecha_captura         = current_timestamp,
              a_nombre              = substring(r_bcotransac1.obs_transac_bco from 1 for 60),
              desc_documento        = r_bcotransac1.obs_transac_bco,
              monto                 = r_bcotransac1.monto
       where  cod_ctabco            = r_bcotransac1.cod_ctabco
       and    motivo_bco            = r_bcotransac1.motivo_bco
       and    no_docmto_sys         = r_bcotransac1.sec_transacc
       and    fecha_posteo          = r_bcotransac1.fecha_posteo
       and    status                <> ''C'';
    end if;
    return 1;
end;
' language plpgsql;
