

drop function f_cglcomprobante1_cglposteo(char(2), char(3), int4, int4, int4) cascade;
drop function f_cgl_comprobante1_cglposteo(char(2), int4) cascade;
drop function f_cglsldocuenta(char(2), char(24), int4, int4, decimal(10,2), decimal(10,2));
drop function f_cglsldoaux1(char(2), char(24), char(10), int4, int4, decimal(10,2), decimal(10,2));
drop function f_balance_inicio_cglsldocuenta(char(2), char(24), int4, int4);
drop function f_balance_inicio_cglsldoaux1(char(2), char(24), char(10), int4, int4);
drop function f_cglsldocuenta_update_niveles(char(2), char(24), int4, int4, decimal(10,2), decimal(10,2), decimal(10,2));
drop function f_update_balances_y_niveles(char(2));
drop function f_cglsldocuenta_update_balance_inicio(char(2), char(24), int4, int4) cascade;
drop function f_update_cglsldocuenta(char(2)) cascade;
drop function f_postea_comprobantes(char(2)) cascade;
drop function f_balance_inicio_cuenta(char(2), char(24), int4, int4) cascade;
drop function f_update_balance_inicio_cgl(char(2)) cascade;
drop function f_update_cglsldocuenta(char(2), int4, int4) cascade;
drop function f_cglposteo_itbms(int4, char(20)) cascade;
drop function f_cglposteo(int4, char(20)) cascade;
drop function f_verificar_balance(char(2), int4, int4) cascade;
drop function f_cglsldoaux2(char(2), char(24), char(10), int4, int4, decimal(10,2), decimal(10,2)) cascade;
drop function f_balance_inicio_cglsldoaux2(char(2), char(24), char(10), int4, int4) cascade;
drop function f_validar_balance(char(2)) cascade;
drop function f_cerrar_aplicacion(char(2),char(3), int4, int4) cascade;
drop function f_cerrar_cgl(char(2),int4, int4) cascade;
drop function f_update_balance_inicio_cglsldocuenta(char(2), int4, int4) cascade;


create function f_update_balance_inicio_cglsldocuenta(char(2), int4, int4) returns integer as '
declare
    as_compania alias for $1;
    ai_anio alias for $2;
    ai_mes alias for $3;
    r_gralperiodos record;
    r_cglsldocuenta record;
    r_cglsldocuenta_work record;
    r_cglsldoaux1 record;
    r_cglsldoaux1_work record;
    ld_ultimo_cierre date;
    li_anio integer;
    li_mes integer;
    ldc_balance_inicio decimal;
begin

    update cglsldocuenta
    set balance_inicio = 0
    where compania = as_compania 
    and year = ai_anio
    and periodo = ai_mes;
    
    li_anio =   ai_anio;
    li_mes  =   ai_mes;
    
    li_mes  =   li_mes - 1;
    if li_mes = 0 then
        li_mes  =   13;
        li_anio =   li_anio - 1;
    end if;
    
    
    for r_cglsldocuenta in select * from cglsldocuenta
                                where compania = as_compania
                                and year = li_anio
                                and periodo = li_mes
                                order by cuenta
    loop
        ldc_balance_inicio  =   r_cglsldocuenta.balance_inicio + r_cglsldocuenta.debito - r_cglsldocuenta.credito;
        select into r_cglsldocuenta_work *
        from cglsldocuenta
        where compania  = as_compania
        and year = ai_anio
        and periodo = ai_mes
        and cuenta = r_cglsldocuenta.cuenta;
        if found then
            update cglsldocuenta
            set balance_inicio = ldc_balance_inicio
            where cglsldocuenta.compania = as_compania
            and cglsldocuenta.year = ai_anio
            and cglsldocuenta.periodo = ai_mes
            and cglsldocuenta.cuenta = r_cglsldocuenta.cuenta;
        else        
            insert into cglsldocuenta(compania, year, periodo, cuenta, balance_inicio, debito, credito)
            values(as_compania, ai_anio, ai_mes, r_cglsldocuenta.cuenta, ldc_balance_inicio, 0, 0);
        end if;
        

        for r_cglsldoaux1 in select * from cglsldoaux1
                                    where compania = as_compania
                                    and year = li_anio
                                    and periodo = li_mes
                                    and cuenta = r_cglsldocuenta.cuenta
                                    order by auxiliar
        loop
            ldc_balance_inicio  =   r_cglsldoaux1.balance_inicio + r_cglsldoaux1.debito - r_cglsldoaux1.credito;
            select into r_cglsldoaux1_work *
            from cglsldoaux1
            where compania  = as_compania
            and year = ai_anio
            and periodo = ai_mes
            and auxiliar = r_cglsldoaux1.auxiliar
            and cuenta = r_cglsldocuenta.cuenta;
            if found then
                update cglsldoaux1
                set balance_inicio = ldc_balance_inicio
                where compania = as_compania
                and year = ai_anio
                and periodo = ai_mes
                and auxiliar = r_cglsldoaux1.auxiliar
                and cuenta = r_cglsldocuenta.cuenta;
            else        
                insert into cglsldoaux1(compania, cuenta, auxiliar, year, periodo, balance_inicio, debito, credito)
                values(as_compania, r_cglsldocuenta.cuenta, r_cglsldoaux1.auxiliar, ai_anio, ai_mes,  ldc_balance_inicio, 0, 0);
            end if;
        end loop;
    end loop;    
        
    return 1;
end;
' language plpgsql;


create function f_cerrar_cgl(char(2),int4, int4) returns integer as '
declare
    as_cia alias for $1;
    ai_anio alias for $2;
    ai_mes alias for $3;
    r_work record;
    r_gralperiodos record;
    r_bcobalance record;
    r_cglsldocuenta record;
    r_cglsldoaux1 record;
    r_cglsldoaux2 record;
    ldc_balance_inicial decimal;
    ldc_debito decimal;
    ldc_credito decimal;
    ldc_balance_inicio decimal;
    li_next_anio integer;
    li_next_mes integer;
begin
    li_next_anio    = ai_anio;
    li_next_mes     = ai_mes + 1;
    
    if li_next_mes > 13 then
        li_next_anio    =   li_next_anio + 1;
        li_next_mes     =   1;
    end if;

	delete from cglsldocuenta
	where cglsldocuenta.compania = as_cia
	and cglsldocuenta.cuenta in
		(select cuenta from cglcuentas, cglniveles
		where cglcuentas.nivel = cglniveles.nivel
		and cglniveles.recibe = ''N'')
	and exists
		(select * from gralperiodos
		where gralperiodos.compania = cglsldocuenta.compania
		and gralperiodos.year = cglsldocuenta.year
		and gralperiodos.periodo = cglsldocuenta.periodo
		and gralperiodos.compania = cglsldocuenta.compania
		and gralperiodos.aplicacion = ''CGL''
		and gralperiodos.estado = ''A'');


    select into r_gralperiodos *
    from gralperiodos
    where compania = as_cia
    and aplicacion = ''CGL''
    and year = ai_anio
    and periodo = ai_mes;
    if not found then
        Raise Exception ''No existe Anio % y Mes % en Mayor General'',ai_anio, ai_mes;
    end if;
    
    if r_gralperiodos.estado <> ''A'' then
        return 0;
    end if;
    
    if li_next_mes = 13 then
        delete from cglsldocuenta
        where compania = as_cia
        and year = li_next_anio
        and periodo = li_next_mes;

        delete from cglposteo
        where compania = as_cia
        and year = li_next_anio
        and periodo = li_next_mes;

    else        
        update cglsldocuenta
        set balance_inicio = 0
        where compania = as_cia
        and year = li_next_anio
        and periodo = li_next_mes;
    
        update cglsldoaux1
        set balance_inicio = 0
        where compania = as_cia
        and year = li_next_anio
        and periodo = li_next_mes;

        update cglsldoaux2
        set balance_inicio = 0
        where compania = as_cia
        and year = li_next_anio
        and periodo = li_next_mes;
    end if;    

    for r_cglsldocuenta in select * from cglsldocuenta
                            where compania = as_cia
                            and year = ai_anio
                            and periodo = ai_mes
                            order by cuenta
    loop
        ldc_balance_inicio  =   r_cglsldocuenta.balance_inicio + r_cglsldocuenta.debito - r_cglsldocuenta.credito;

        select into r_work *
        from cglsldocuenta
        where compania = as_cia
        and year = li_next_anio
        and periodo = li_next_mes
        and trim(cuenta) = trim(r_cglsldocuenta.cuenta);
        if found then
            update cglsldocuenta
            set balance_inicio = ldc_balance_inicio
            where compania = as_cia
            and year = li_next_anio
            and periodo = li_next_mes
            and trim(cuenta) = trim(r_cglsldocuenta.cuenta);
        else
            insert into cglsldocuenta(compania, year, periodo, cuenta, balance_inicio, debito, credito)
            values(as_cia, li_next_anio, li_next_mes, r_cglsldocuenta.cuenta, ldc_balance_inicio, 0, 0);
        end if;

        for r_cglsldoaux1 in select * from cglsldoaux1
                                where compania = as_cia
                                and year = ai_anio
                                and periodo = ai_mes
                                and cuenta = r_cglsldocuenta.cuenta
                                order by auxiliar
        loop
            ldc_balance_inicio  =   r_cglsldoaux1.balance_inicio + r_cglsldoaux1.debito - r_cglsldoaux1.credito;
    
            select into r_work *
            from cglsldoaux1
            where compania = as_cia
            and year = li_next_anio
            and periodo = li_next_mes
            and trim(cuenta) = trim(r_cglsldocuenta.cuenta)
            and trim(auxiliar) = trim(r_cglsldoaux1.auxiliar);
            if found then
                update cglsldoaux1
                set balance_inicio = ldc_balance_inicio
                where compania = as_cia
                and year = li_next_anio
                and periodo = li_next_mes
                and trim(cuenta) = trim(r_cglsldocuenta.cuenta)
                and trim(auxiliar) = trim(r_cglsldoaux1.auxiliar);
            else
                insert into cglsldoaux1(compania, year, periodo, cuenta, auxiliar, balance_inicio, debito, credito)
                values(as_cia, li_next_anio, li_next_mes, r_cglsldocuenta.cuenta, r_cglsldoaux1.auxiliar, 
                    ldc_balance_inicio, 0, 0);
            end if;
        end loop;

        for r_cglsldoaux2 in select * from cglsldoaux2
                                where compania = as_cia
                                and year = ai_anio
                                and periodo = ai_mes
                                and cuenta = r_cglsldocuenta.cuenta
                                order by auxiliar
        loop
            ldc_balance_inicio  =   r_cglsldoaux2.balance_inicio + r_cglsldoaux2.debito - r_cglsldoaux2.credito;
    
            select into r_work *
            from cglsldoaux2
            where compania = as_cia
            and year = li_next_anio
            and periodo = li_next_mes
            and trim(cuenta) = trim(r_cglsldocuenta.cuenta)
            and trim(auxiliar) = trim(r_cglsldoaux2.auxiliar);
            if found then
                update cglsldoaux2
                set balance_inicio = ldc_balance_inicio
                where compania = as_cia
                and year = li_next_anio
                and periodo = li_next_mes
                and trim(cuenta) = trim(r_cglsldocuenta.cuenta)
                and trim(auxiliar) = trim(r_cglsldoaux2.auxiliar);
            else
                insert into cglsldoaux2(compania, year, periodo, cuenta, auxiliar, balance_inicio, debito, credito)
                values(as_cia, li_next_anio, li_next_mes, r_cglsldocuenta.cuenta, r_cglsldoaux2.auxiliar, 
                    ldc_balance_inicio, 0, 0);
            end if;
        end loop;
        
    end loop;

    return f_cerrar_aplicacion(as_cia, ''CGL'', ai_anio, ai_mes);
end;
' language plpgsql;    





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


create function f_validar_balance(char(2)) returns integer as '
declare
    as_compania alias for $1;
    ld_desde date;
    ldc_work decimal(14,2);
    r_work_1 record;
    r_cglposteo record;
    r_rela_cgl_comprobante1_cglposteo record;
    r_adc_master record;
    r_rela_activos_cglposteo record;
    r_rela_bcocheck1_cglposteo record;
    r_factura1 record;
    r_factura2 record;
    r_cxc_recibo1 record;
    r_cxc_recibo2 record;
    r_cxcdocm record;
    li_retorno integer;
begin
    select Min(inicio) into ld_desde
    from gralperiodos
    where compania = as_compania
    and aplicacion = ''CGL''
    and estado = ''A'';
    if not found then
        Raise Exception ''No existen periodos abiertos'';
    end if;

    delete from rela_cxc_recibo1_cglposteo
    using cxc_recibo1, cglposteo, almacen
    where rela_cxc_recibo1_cglposteo.consecutivo = cglposteo.consecutivo
    and rela_cxc_recibo1_cglposteo.almacen = cxc_recibo1.almacen
    and rela_cxc_recibo1_cglposteo.caja = cxc_recibo1.caja
    and rela_cxc_recibo1_cglposteo.cxc_consecutivo = cxc_recibo1.consecutivo
    and rela_cxc_recibo1_cglposteo.almacen = almacen.almacen
    and almacen.compania = as_compania
    and cxc_recibo1.fecha >= ld_desde
    and cxc_recibo1.fecha <> cglposteo.fecha_comprobante;


    delete from rela_factura1_cglposteo
    using factura1, cglposteo, almacen
    where factura1.almacen = rela_factura1_cglposteo.almacen
    and factura1.caja = rela_factura1_cglposteo.caja
    and factura1.tipo = rela_factura1_cglposteo.tipo
    and factura1.num_documento = rela_factura1_cglposteo.num_documento
    and factura1.almacen = almacen.almacen
    and cglposteo.consecutivo = rela_factura1_cglposteo.consecutivo
    and cglposteo.fecha_comprobante <> factura1.fecha_factura
    and almacen.compania = as_compania
    and factura1.fecha_factura >= ld_desde;


    delete from rela_adc_cxc_1_cglposteo
    using cglposteo, adc_cxc_1
    where rela_adc_cxc_1_cglposteo.compania = adc_cxc_1.compania
    and rela_adc_cxc_1_cglposteo.consecutivo = adc_cxc_1.consecutivo
    and rela_adc_cxc_1_cglposteo.secuencia = adc_cxc_1.secuencia
    and rela_adc_cxc_1_cglposteo.cgl_consecutivo = cglposteo.consecutivo
    and adc_cxc_1.compania = as_compania
    and adc_cxc_1.fecha >= ld_desde
    and adc_cxc_1.fecha <> cglposteo.fecha_comprobante;



    delete from rela_adc_cxp_1_cglposteo
    using adc_cxp_1, cglposteo
    where rela_adc_cxp_1_cglposteo.compania = adc_cxp_1.compania
    and rela_adc_cxp_1_cglposteo.consecutivo = adc_cxp_1.consecutivo
    and rela_adc_cxp_1_cglposteo.secuencia = adc_cxp_1.secuencia
    and rela_adc_cxp_1_cglposteo.cgl_consecutivo = cglposteo.consecutivo
    and adc_cxp_1.fecha <> cglposteo.fecha_comprobante
    and adc_cxp_1.compania = as_compania
    and adc_cxp_1.fecha >= ld_desde;
    

    delete from cglposteo
    using rela_bcotransac1_cglposteo, bcotransac1, bcoctas
    where rela_bcotransac1_cglposteo.consecutivo = cglposteo.consecutivo
    and rela_bcotransac1_cglposteo.cod_ctabco = bcotransac1.cod_ctabco
    and rela_bcotransac1_cglposteo.sec_transacc = bcotransac1.sec_transacc
    and rela_bcotransac1_cglposteo.cod_ctabco = bcoctas.cod_ctabco
    and bcoctas.compania = as_compania
    and (bcotransac1.fecha_posteo >= ld_desde
    or cglposteo.fecha_comprobante >= ld_desde)
    and bcotransac1.fecha_posteo <> cglposteo.fecha_comprobante;


    delete from eys1
    using almacen
    where eys1.almacen = almacen.almacen
    and f_sum_eys(eys1.almacen, no_transaccion, ''eys2'') <> f_sum_eys(eys1.almacen, no_transaccion, ''eys3'')
    and fecha >= ld_desde
    and almacen.compania = as_compania
    and aplicacion_origen = ''FAC'';


    
    ldc_work = 0;
    li_retorno = 1;
    for r_work_1 in select aplicacion_origen, fecha_comprobante, sum(cglposteo.debito-cglposteo.credito) as monto
                        from cglposteo
                        where compania = as_compania
                        and fecha_comprobante >= ld_desde
                        group by 1, 2
                        having sum(cglposteo.debito-cglposteo.credito) <> 0
                        order by 1, 2
    loop
        delete from cglposteo
        where compania = as_compania
        and aplicacion_origen = r_work_1.aplicacion_origen
        and fecha_comprobante = r_work_1.fecha_comprobante;
        li_retorno = 0;
    end loop;    


    
    ldc_work = 0;
    li_retorno = 1;
    for r_cglposteo in select * from cglposteo
                        where compania = as_compania
                        and fecha_comprobante >= ld_desde
                        and aplicacion_origen = ''CGL''
                        order by fecha_comprobante, consecutivo
    loop
        select into r_rela_cgl_comprobante1_cglposteo *
        from rela_cgl_comprobante1_cglposteo
        where consecutivo = r_cglposteo.consecutivo;
        if not found then
            delete from cglposteo
            where consecutivo = r_cglposteo.consecutivo;
        end if;
    end loop;    


    
    for r_adc_master in select adc_master.* 
                        from adc_manifiesto, adc_master, rela_adc_master_cglposteo, cglposteo
                        where adc_manifiesto.compania = adc_master.compania
                        and adc_manifiesto.consecutivo = adc_master.consecutivo
                        and adc_master.compania = rela_adc_master_cglposteo.compania
                        and adc_master.consecutivo = rela_adc_master_cglposteo.consecutivo
                        and adc_master.linea_master = rela_adc_master_cglposteo.linea_master
                        and rela_adc_master_cglposteo.cgl_consecutivo = cglposteo.consecutivo
                        and adc_manifiesto.compania = as_compania
                        and adc_manifiesto.fecha >= ld_desde
                        and cglposteo.aplicacion_origen <> ''CXP''
    loop
        delete from rela_adc_master_cglposteo
        where compania = r_adc_master.compania
        and consecutivo = r_adc_master.consecutivo
        and linea_master = r_adc_master.linea_master;
    end loop;


    
    for r_rela_activos_cglposteo in 
                        select rela_activos_cglposteo.compania, rela_activos_cglposteo.codigo, count(*)
                        from activos, rela_activos_cglposteo
                        where activos.compania = rela_activos_cglposteo.compania
                        and activos.codigo = rela_activos_cglposteo.codigo
                        and activos.fecha_compra >= ld_desde
                        and activos.compania = as_compania
                        group by 1, 2
                        having count(*) <= 1
    loop
        delete from rela_activos_cglposteo
        where compania = r_rela_activos_cglposteo.compania
        and codigo = r_rela_activos_cglposteo.codigo;    
    end loop;       


    for r_rela_bcocheck1_cglposteo in 
                        select rela_bcocheck1_cglposteo.cod_ctabco, no_cheque, motivo_bco, sum(cglposteo.debito-cglposteo.credito)
                        from rela_bcocheck1_cglposteo, cglposteo, bcoctas
                        where cglposteo.consecutivo = rela_bcocheck1_cglposteo.consecutivo
                        and bcoctas.cod_ctabco = rela_bcocheck1_cglposteo.cod_ctabco
                        and cglposteo.fecha_comprobante >= ld_desde
                        and bcoctas.compania = as_compania
                        group by 1, 2, 3
                        having sum(cglposteo.debito-cglposteo.credito) <> 0
                        order by 1, 3, 2
    loop
        delete from rela_bcocheck1_cglposteo
        where cod_ctabco = r_rela_bcocheck1_cglposteo.cod_ctabco
        and no_cheque = r_rela_bcocheck1_cglposteo.no_cheque
        and motivo_bco = r_rela_bcocheck1_cglposteo.motivo_bco;
    end loop;       

    for r_factura1 in select factura1.*
        from almacen, factura1, factmotivos
        where almacen.almacen = factura1.almacen
        and factura1.tipo = factmotivos.tipo
        and almacen.compania = as_compania
        and factura1.fecha_factura >= ld_desde
        and factmotivos.cotizacion <> ''S'' and factmotivos.donacion <> ''S''
        and factura1.status <> ''A''
        order by factura1.fecha_factura, factura1.num_documento
    loop
        select into r_factura2 *
        from factura2
        where almacen = r_factura1.almacen
        and caja = r_factura1.caja
        and tipo = r_factura1.tipo
        and num_documento = r_factura1.num_documento;
        if not found then
            Raise Exception ''Almacen % Caja % Tipo % Numero % no tiene detalle Verifique'',r_factura1.almacen, r_factura1.caja, r_factura1.tipo, r_factura1.num_documento;
        end if;
        
        ldc_work = 0;
        select sum(monto) into ldc_work
        from factura4
        where almacen = r_factura1.almacen
        and caja = r_factura1.caja
        and tipo = r_factura1.tipo
        and num_documento = r_factura1.num_documento;
        if ldc_work is null or ldc_work = 0 then
            Raise Exception ''Almacen % Caja % Tipo % Numero % no tiene totales (factura4) Verifique'',r_factura1.almacen, r_factura1.caja, r_factura1.tipo, r_factura1.num_documento;
        end if;
    end loop;

    for r_cxc_recibo1 in select cxc_recibo1.*
        from almacen, cxc_recibo1
        where almacen.almacen = cxc_recibo1.almacen
        and almacen.compania = as_compania
        and cxc_recibo1.fecha >= ld_desde
        order by cxc_recibo1.fecha, cxc_recibo1.caja, cxc_recibo1.consecutivo
    loop
        for r_cxc_recibo2 in select * from cxc_recibo2
                                where almacen = r_cxc_recibo1.almacen
                                and caja = r_cxc_recibo1.caja
                                and consecutivo = r_cxc_recibo1.consecutivo
                                order by documento_aplicar
        loop
            select into r_cxcdocm *
            from cxcdocm
            where almacen = r_cxc_recibo2.almacen_aplicar
            and caja = r_cxc_recibo2.caja_aplicar
            and cliente = r_cxc_recibo1.cliente
            and documento = r_cxc_recibo2.documento_aplicar
            and docmto_aplicar = r_cxc_recibo2.documento_aplicar
            and motivo_cxc = r_cxc_recibo2.motivo_aplicar;
            if not found then
--                Raise Exception ''Almacen % Caja % Consecutivo % Recibo con Inconsistencia'',r_cxc_recibo2.almacen, r_cxc_recibo2.caja, r_cxc_recibo2.consecutivo;
            end if;
        end loop;                                
    end loop;
    
    
    return li_retorno;
end;
' language plpgsql;




create function f_balance_inicio_cglsldoaux2(char(2), char(24), char(10), int4, int4) returns decimal(10,2) as '
declare
    as_compania alias for $1;
    as_cuenta alias for $2;
    as_auxiliar alias for $3;
    ai_year alias for $4;
    ai_periodo alias for $5;
    r_gralperiodos record;
    r_cglsldoaux2 record;
    ldc_balance_inicio decimal(10,2);
    ldc_balance_final decimal(10,2);
    li_year int4;
    li_periodo int4;
    ld_fecha date;
    ld_inicio date;
    r_cglsldocuenta record;
begin
    select into r_cglsldoaux2 * from cglsldoaux2
    where cglsldoaux2.cuenta = as_cuenta
    and cglsldoaux2.auxiliar = as_auxiliar
    and cglsldoaux2.compania = as_compania
    and cglsldoaux2.year = ai_year
    and cglsldoaux2.periodo = ai_periodo;
    if found then                            
       ldc_balance_final := r_cglsldoaux2.balance_inicio + r_cglsldoaux2.debito -
                            r_cglsldoaux2.credito;        
    else
       ldc_balance_final := 0;
    end if;
    
    select into ld_inicio inicio from gralperiodos
    where compania = as_compania
    and aplicacion = ''CGL''
    and year = ai_year
    and periodo = ai_periodo;
    if not found then
       return 0;
    end if;
    
    for r_gralperiodos in select * from gralperiodos
                            where compania = as_compania
                            and inicio > ld_inicio
                            and aplicacion = ''CGL''
                            and estado = ''A''
                            order by year, periodo
    loop
        select into r_cglsldoaux2 * from cglsldoaux2
        where compania = as_compania
        and year = r_gralperiodos.year
        and periodo = r_gralperiodos.periodo
        and cuenta = as_cuenta
        and auxiliar = as_auxiliar;
        if not found then
            if ldc_balance_final <> 0 then
                select into r_cglsldocuenta * from cglsldocuenta
                where compania = as_compania 
                and cuenta = as_cuenta
                and year = r_gralperiodos.year
                and periodo = r_gralperiodos.periodo;
                if found then
                    insert into cglsldoaux2 (compania, cuenta, auxiliar, year, periodo, balance_inicio,
                        debito, credito)
                    values (as_compania, as_cuenta, as_auxiliar, r_gralperiodos.year, r_gralperiodos.periodo, 
                        ldc_balance_final, 0, 0);
                end if;
            end if;
        else
            update cglsldoaux2
            set balance_inicio = ldc_balance_final
            where compania = as_compania
            and year = r_gralperiodos.year
            and periodo = r_gralperiodos.periodo
            and cuenta = as_cuenta
            and auxiliar = as_auxiliar;
            
            ldc_balance_final := ldc_balance_final + r_cglsldoaux2.debito - r_cglsldoaux2.credito;
        end if;
    end loop;
    
    return 1;
end;
' language plpgsql;




create function f_cglsldoaux2(char(2), char(24), char(10), int4, int4, decimal(10,2), decimal(10,2)) returns integer as '
declare
    as_compania alias for $1;
    as_cuenta alias for $2;
    as_auxiliar alias for $3;
    ai_year alias for $4;
    ai_periodo alias for $5;
    adc_debito alias for $6;
    adc_credito alias for $7;
    r_cglsldoaux2 record;
    r_cglsldocuenta record;
    ldc_balance_final decimal(10,2);
    li_year int4;
    li_periodo int4;
begin
    select into r_cglsldoaux2 * from cglsldoaux2
    where compania = as_compania
    and cuenta = as_cuenta
    and auxiliar = as_auxiliar
    and year = ai_year
    and periodo = ai_periodo;
    if not found then
        select into r_cglsldocuenta * from cglsldocuenta
        where compania = as_compania
        and trim(cuenta) = trim(as_cuenta)
        and year = ai_year
        and periodo = ai_periodo;
        if found then
--           r_cglsldoaux1.balance_inicio := f_balance_inicio_cglsldoaux1(as_compania, 
--                                               as_cuenta, as_auxiliar, ai_year, ai_periodo);
            r_cglsldoaux2.balance_inicio := 0;            
           insert into cglsldoaux2 (compania, cuenta, auxiliar, year, periodo, balance_inicio,
                        debito, credito)
           values (as_compania, trim(as_cuenta), as_auxiliar, ai_year, ai_periodo, 
                        r_cglsldoaux2.balance_inicio, adc_debito, adc_credito);
        end if;                        
    else
       update cglsldoaux2
       set    debito       = debito + adc_debito,
              credito      = credito + adc_credito
       where  compania = as_compania
       and    cuenta = as_cuenta
       and    auxiliar = as_auxiliar
       and    year = ai_year
       and    periodo = ai_periodo;
    end if;
    
    r_cglsldoaux2.balance_inicio = f_balance_inicio_cglsldoaux2(as_compania, 
                                      as_cuenta, as_auxiliar, ai_year, ai_periodo);

    return 1;
end;
' language plpgsql;



create function f_verificar_balance(char(2), int4, int4) returns integer as '
declare
    as_compania alias for $1;
    ai_anio alias for $2;
    ai_mes alias for $3;
    ld_desde date;
    ldc_work decimal(14,2);
    ldc_monto decimal(14,2);
    r_work_1 record;
    r_gralperiodos record;
    li_retorno integer;
begin
    select * into r_gralperiodos
    from gralperiodos
    where compania = as_compania
    and aplicacion = ''CGL''
    and estado = ''A''
    and year = ai_anio
    and periodo = ai_mes;
    if not found then
        Raise Exception ''Cia % Anio % Periodo % no esta abierto'', as_compania, ai_anio, ai_mes;
    end if;
    
    ldc_work = 0;
    li_retorno = 1;
    for r_work_1 in select aplicacion_origen, fecha_comprobante, sum(cglposteo.debito-cglposteo.credito) as monto
                        from cglposteo
                        where compania = as_compania
                        and cglposteo.year = ai_anio
                        and cglposteo.periodo = ai_mes
                        group by 1, 2
                        having sum(cglposteo.debito-cglposteo.credito) <> 0
                        order by 1, 2
    loop
        Raise Exception ''Aplicacion % no esta balanceada %'',r_work_1.aplicacion_origen, r_work_1.monto;
    end loop;    

    for r_work_1 in select cglsldocuenta.cuenta, sum(balance_inicio+debito-credito) as monto
                        from cglsldocuenta, cglcuentas, cglniveles
                        where cglsldocuenta.cuenta = cglcuentas.cuenta
                        and cglcuentas.nivel = cglcuentas.nivel
                        and cglniveles.recibe = ''S''
                        and cglsldocuenta.year = ai_anio
                        and cglsldocuenta.periodo = ai_mes
                        and cglcuentas.auxiliar_1 = ''S''
                        and cglsldocuenta.compania = as_compania
                        group by 1
    loop
        ldc_monto   =   0;
        
        select sum(balance_inicio+debito-credito) into ldc_monto
        from cglsldoaux1
        where compania = as_compania
        and cuenta = r_work_1.cuenta
        and year = ai_anio
        and periodo = ai_mes;
        if not found or ldc_monto is null then
            ldc_monto = 0;
        end if;
        
        if ldc_monto <> r_work_1.monto then
            Raise Exception ''Cuenta % Esta desbalance con cglsldoaux1'',r_work_1.cuenta;
        end if;
        
    end loop;
    return li_retorno;
end;
' language plpgsql;





create function f_cglposteo(int4, char(20)) returns char(100) as '
declare
    ai_consecutivo alias for $1;
    as_retornar alias for $2;
    r_cglposteo record;
    r_rela_cxpfact1_cglposteo record;
    r_rela_cxpajuste1_cglposteo record;
    r_cxpmotivos record;
    r_rela_bcocheck1_cglposteo record;
    r_rela_bcotransac1_cglposteo record;
    r_cxpfact1 record;
    r_cxpajuste1 record;
    r_proveedores record;
    r_rela_caja_trx1_cglposteo record;
    r_rela_adc_master_cglposteo record;
    r_clientes record;
    r_caja_trx1 record;
    r_bcotransac1 record;
    lc_retornar char(100);
    lc_tipo_de_persona char(1);
begin
    lc_retornar = null;
    select into r_cglposteo * from cglposteo
    where consecutivo = ai_consecutivo;
    if not found then
        return null;
    end if;
    
    if trim(as_retornar) = ''RUC'' then
        select into r_rela_cxpfact1_cglposteo * 
        from rela_cxpfact1_cglposteo
        where consecutivo = r_cglposteo.consecutivo;
        if found then
            select into r_cxpfact1 * from cxpfact1    
            where compania = r_rela_cxpfact1_cglposteo.compania
            and proveedor = r_rela_cxpfact1_cglposteo.proveedor
            and fact_proveedor = r_rela_cxpfact1_cglposteo.fact_proveedor;
            if found then
                select into r_proveedores *
                from proveedores
                where proveedor = r_rela_cxpfact1_cglposteo.proveedor;
                if found then
                    return trim(r_proveedores.id_proveedor);
                end if;
            end if;
        else
            select into r_rela_cxpajuste1_cglposteo *
            from rela_cxpajuste1_cglposteo
            where consecutivo = r_cglposteo.consecutivo;
            if found then
                select into r_cxpajuste1 *
                from cxpajuste1
                where compania = r_rela_cxpajuste1_cglposteo.compania
                and sec_ajuste_cxp = r_rela_cxpajuste1_cglposteo.sec_ajuste_cxp;
                if found then
                    select into r_proveedores *
                    from proveedores
                    where proveedor = r_cxpajuste1.proveedor;
                    if found then
                        return trim(r_proveedores.id_proveedor);
                    end if;
                end if;
            else
                select into r_rela_adc_master_cglposteo *
                from rela_adc_master_cglposteo
                where cgl_consecutivo = ai_consecutivo;
                if found then
                    select into r_proveedores proveedores.*
                    from adc_manifiesto, navieras, proveedores
                    where adc_manifiesto.compania = r_rela_adc_master_cglposteo.compania
                    and adc_manifiesto.consecutivo = r_rela_adc_master_cglposteo.consecutivo
                    and adc_manifiesto.cod_naviera = navieras.cod_naviera
                    and navieras.proveedor = proveedores.proveedor;
                    if found then
                        return Trim(r_proveedores.id_proveedor);
                    end if;
                else
                    select into r_clientes clientes.*
                    from clientes, factura1, rela_factura1_cglposteo
                    where clientes.cliente = factura1.cliente
                    and factura1.almacen = rela_factura1_cglposteo.almacen
                    and factura1.tipo = rela_factura1_cglposteo.tipo
                    and factura1.num_documento = rela_factura1_cglposteo.num_documento
                    and rela_factura1_cglposteo.consecutivo = ai_consecutivo;
                    if found then
                        return Trim(r_clientes.id);
                    else
                        select into r_clientes clientes.*
                        from clientes, adc_cxc_1, rela_adc_cxc_1_cglposteo
                        where clientes.cliente = adc_cxc_1.cliente
                        and adc_cxc_1.compania= rela_adc_cxc_1_cglposteo.compania
                        and adc_cxc_1.consecutivo = rela_adc_cxc_1_cglposteo.consecutivo
                        and adc_cxc_1.secuencia = rela_adc_cxc_1_cglposteo.secuencia
                        and rela_adc_cxc_1_cglposteo.cgl_consecutivo = ai_consecutivo;
                        if found then
                            return Trim(r_clientes.id);
                        else
                            select into r_proveedores proveedores.*
                            from proveedores, adc_cxp_1, rela_adc_cxp_1_cglposteo
                            where proveedores.proveedor = adc_cxp_1.proveedor
                            and adc_cxp_1.compania = rela_adc_cxp_1_cglposteo.compania
                            and adc_cxp_1.consecutivo = rela_adc_cxp_1_cglposteo.consecutivo
                            and adc_cxp_1.secuencia = rela_adc_cxp_1_cglposteo.secuencia
                            and rela_adc_cxp_1_cglposteo.cgl_consecutivo = ai_consecutivo;
                            if found then
                                return trim(r_proveedores.id_proveedor);
                            end if;
                        end if;
                    end if;
                end if;
            end if;
        end if;

    elsif trim(as_retornar) = ''TIPO_DE_PERSONA'' then
        
        lc_tipo_de_persona = ''1'';
        
        select into r_rela_cxpfact1_cglposteo * 
        from rela_cxpfact1_cglposteo
        where consecutivo = r_cglposteo.consecutivo;
        if found then
            select into r_cxpfact1 * from cxpfact1    
            where compania = r_rela_cxpfact1_cglposteo.compania
            and proveedor = r_rela_cxpfact1_cglposteo.proveedor
            and fact_proveedor = r_rela_cxpfact1_cglposteo.fact_proveedor;
            if found then
                select into r_proveedores *
                from proveedores
                where proveedor = r_rela_cxpfact1_cglposteo.proveedor;
                if found then
                        lc_tipo_de_persona = r_proveedores.tipo_de_persona;
                end if;
            end if;
        else
            select into r_rela_cxpajuste1_cglposteo *
            from rela_cxpajuste1_cglposteo
            where consecutivo = r_cglposteo.consecutivo;
            if found then
                select into r_cxpajuste1 *
                from cxpajuste1
                where compania = r_rela_cxpajuste1_cglposteo.compania
                and sec_ajuste_cxp = r_rela_cxpajuste1_cglposteo.sec_ajuste_cxp;
                if found then
                    select into r_proveedores *
                    from proveedores
                    where proveedor = r_cxpajuste1.proveedor;
                    if found then
                        lc_tipo_de_persona = r_proveedores.tipo_de_persona;
                    end if;
                end if;
            else
                select into r_rela_adc_master_cglposteo *
                from rela_adc_master_cglposteo
                where cgl_consecutivo = ai_consecutivo;
                if found then
                    select into r_proveedores proveedores.*
                    from adc_manifiesto, navieras, proveedores
                    where adc_manifiesto.compania = r_rela_adc_master_cglposteo.compania
                    and adc_manifiesto.consecutivo = r_rela_adc_master_cglposteo.consecutivo
                    and adc_manifiesto.cod_naviera = navieras.cod_naviera
                    and navieras.proveedor = proveedores.proveedor;
                    if found then
                        lc_tipo_de_persona = r_proveedores.tipo_de_persona;
                    end if;
                else
                    select into r_clientes clientes.*
                    from clientes, factura1, rela_factura1_cglposteo
                    where clientes.cliente = factura1.cliente
                    and factura1.almacen = rela_factura1_cglposteo.almacen
                    and factura1.tipo = rela_factura1_cglposteo.tipo
                    and factura1.num_documento = rela_factura1_cglposteo.num_documento
                    and rela_factura1_cglposteo.consecutivo = ai_consecutivo;
                    if found then
                        lc_tipo_de_persona = r_clientes.tipo_de_persona;
                    else
                        select into r_clientes clientes.*
                        from clientes, adc_cxc_1, rela_adc_cxc_1_cglposteo
                        where clientes.cliente = adc_cxc_1.cliente
                        and adc_cxc_1.compania= rela_adc_cxc_1_cglposteo.compania
                        and adc_cxc_1.consecutivo = rela_adc_cxc_1_cglposteo.consecutivo
                        and adc_cxc_1.secuencia = rela_adc_cxc_1_cglposteo.secuencia
                        and rela_adc_cxc_1_cglposteo.cgl_consecutivo = ai_consecutivo;
                        if found then
                            lc_tipo_de_persona = r_clientes.tipo_de_persona;
                        else
                            select into r_proveedores proveedores.*
                            from proveedores, adc_cxp_1, rela_adc_cxp_1_cglposteo
                            where proveedores.proveedor = adc_cxp_1.proveedor
                            and adc_cxp_1.compania = rela_adc_cxp_1_cglposteo.compania
                            and adc_cxp_1.consecutivo = rela_adc_cxp_1_cglposteo.consecutivo
                            and adc_cxp_1.secuencia = rela_adc_cxp_1_cglposteo.secuencia
                            and rela_adc_cxp_1_cglposteo.cgl_consecutivo = ai_consecutivo;
                            if found then
                                lc_tipo_de_persona = r_proveedores.tipo_de_persona;
                            end if;
                        end if;
                    end if;
                end if;
            end if;
        end if;
        
        if lc_tipo_de_persona = ''1'' then
                return ''NATURAL'';
        elsif lc_tipo_de_persona = ''2'' then
                return ''JURIDICA'';
        else
                return ''EXTRANJERO'';
        end if;

    elsif trim(as_retornar) = ''DV'' then
        select into r_rela_cxpfact1_cglposteo * 
        from rela_cxpfact1_cglposteo
        where consecutivo = r_cglposteo.consecutivo;
        if found then
            select into r_cxpfact1 * from cxpfact1    
            where compania = r_rela_cxpfact1_cglposteo.compania
            and proveedor = r_rela_cxpfact1_cglposteo.proveedor
            and fact_proveedor = r_rela_cxpfact1_cglposteo.fact_proveedor;
            if found then
                select into r_proveedores *
                from proveedores
                where proveedor = r_rela_cxpfact1_cglposteo.proveedor;
                if found then
                    return trim(r_proveedores.dv_proveedor);
                end if;
            end if;
        else
            select into r_rela_cxpajuste1_cglposteo *
            from rela_cxpajuste1_cglposteo
            where consecutivo = r_cglposteo.consecutivo;
            if found then
                select into r_cxpajuste1 *
                from cxpajuste1
                where compania = r_rela_cxpajuste1_cglposteo.compania
                and sec_ajuste_cxp = r_rela_cxpajuste1_cglposteo.sec_ajuste_cxp;
                if found then
                    select into r_proveedores *
                    from proveedores
                    where proveedor = r_cxpajuste1.proveedor;
                    if found then
                        return trim(r_proveedores.dv_proveedor);
                    end if;
                end if;
            else
                select into r_rela_adc_master_cglposteo *
                from rela_adc_master_cglposteo
                where cgl_consecutivo = ai_consecutivo;
                if found then
                    select into r_proveedores proveedores.*
                    from adc_manifiesto, navieras, proveedores
                    where adc_manifiesto.compania = r_rela_adc_master_cglposteo.compania
                    and adc_manifiesto.consecutivo = r_rela_adc_master_cglposteo.consecutivo
                    and adc_manifiesto.cod_naviera = navieras.cod_naviera
                    and navieras.proveedor = proveedores.proveedor;
                    if found then
                        return Trim(r_proveedores.dv_proveedor);
                    end if;
                else
                    select into r_clientes clientes.*
                    from clientes, factura1, rela_factura1_cglposteo
                    where clientes.cliente = factura1.cliente
                    and factura1.almacen = rela_factura1_cglposteo.almacen
                    and factura1.tipo = rela_factura1_cglposteo.tipo
                    and factura1.num_documento = rela_factura1_cglposteo.num_documento
                    and rela_factura1_cglposteo.consecutivo = ai_consecutivo;
                    if found then
                        return Trim(r_clientes.dv);
                    else
                        select into r_clientes clientes.*
                        from clientes, adc_cxc_1, rela_adc_cxc_1_cglposteo
                        where clientes.cliente = adc_cxc_1.cliente
                        and adc_cxc_1.compania= rela_adc_cxc_1_cglposteo.compania
                        and adc_cxc_1.consecutivo = rela_adc_cxc_1_cglposteo.consecutivo
                        and adc_cxc_1.secuencia = rela_adc_cxc_1_cglposteo.secuencia
                        and rela_adc_cxc_1_cglposteo.cgl_consecutivo = ai_consecutivo;
                        if found then
                            return Trim(r_clientes.dv);
                        else
                            select into r_proveedores proveedores.*
                            from proveedores, adc_cxp_1, rela_adc_cxp_1_cglposteo
                            where proveedores.proveedor = adc_cxp_1.proveedor
                            and adc_cxp_1.compania = rela_adc_cxp_1_cglposteo.compania
                            and adc_cxp_1.consecutivo = rela_adc_cxp_1_cglposteo.consecutivo
                            and adc_cxp_1.secuencia = rela_adc_cxp_1_cglposteo.secuencia
                            and rela_adc_cxp_1_cglposteo.cgl_consecutivo = ai_consecutivo;
                            if found then
                                return trim(r_proveedores.dv_proveedor);
                            end if;
                        end if;
                    end if;
                end if;
            end if;
        end if;
        
    elsif trim(as_retornar) = ''NOMBRE'' then
        select into r_rela_cxpfact1_cglposteo * 
        from rela_cxpfact1_cglposteo
        where consecutivo = r_cglposteo.consecutivo;
        if found then
            select into r_cxpfact1 * from cxpfact1    
            where compania = r_rela_cxpfact1_cglposteo.compania
            and proveedor = r_rela_cxpfact1_cglposteo.proveedor
            and fact_proveedor = r_rela_cxpfact1_cglposteo.fact_proveedor;
            if found then
                select into r_proveedores *
                from proveedores
                where proveedor = r_rela_cxpfact1_cglposteo.proveedor;
                if found then
                    return trim(r_proveedores.nomb_proveedor);
                end if;
            end if;
        else
            select into r_rela_cxpajuste1_cglposteo *
            from rela_cxpajuste1_cglposteo
            where consecutivo = r_cglposteo.consecutivo;
            if found then
                select into r_cxpajuste1 *
                from cxpajuste1
                where compania = r_rela_cxpajuste1_cglposteo.compania
                and sec_ajuste_cxp = r_rela_cxpajuste1_cglposteo.sec_ajuste_cxp;
                if found then
                    select into r_proveedores *
                    from proveedores
                    where proveedor = r_cxpajuste1.proveedor;
                    if found then
                        return trim(r_proveedores.nomb_proveedor);
                    end if;
                end if;
            else
                select into r_rela_adc_master_cglposteo *
                from rela_adc_master_cglposteo
                where cgl_consecutivo = ai_consecutivo;
                if found then
                    select into r_proveedores proveedores.*
                    from adc_manifiesto, navieras, proveedores
                    where adc_manifiesto.compania = r_rela_adc_master_cglposteo.compania
                    and adc_manifiesto.consecutivo = r_rela_adc_master_cglposteo.consecutivo
                    and adc_manifiesto.cod_naviera = navieras.cod_naviera
                    and navieras.proveedor = proveedores.proveedor;
                    if found then
                        return Trim(r_proveedores.nomb_proveedor);
                    end if;
                else
                    select into r_clientes clientes.*
                    from clientes, factura1, rela_factura1_cglposteo
                    where clientes.cliente = factura1.cliente
                    and factura1.almacen = rela_factura1_cglposteo.almacen
                    and factura1.tipo = rela_factura1_cglposteo.tipo
                    and factura1.num_documento = rela_factura1_cglposteo.num_documento
                    and rela_factura1_cglposteo.consecutivo = ai_consecutivo;
                    if found then
                        return Trim(r_clientes.nomb_cliente);
                    else
                        select into r_clientes clientes.*
                        from clientes, adc_cxc_1, rela_adc_cxc_1_cglposteo
                        where clientes.cliente = adc_cxc_1.cliente
                        and adc_cxc_1.compania= rela_adc_cxc_1_cglposteo.compania
                        and adc_cxc_1.consecutivo = rela_adc_cxc_1_cglposteo.consecutivo
                        and adc_cxc_1.secuencia = rela_adc_cxc_1_cglposteo.secuencia
                        and rela_adc_cxc_1_cglposteo.cgl_consecutivo = ai_consecutivo;
                        if found then
                            return Trim(r_clientes.nomb_cliente);
                        else
                            select into r_proveedores proveedores.*
                            from proveedores, adc_cxp_1, rela_adc_cxp_1_cglposteo
                            where proveedores.proveedor = adc_cxp_1.proveedor
                            and adc_cxp_1.compania = rela_adc_cxp_1_cglposteo.compania
                            and adc_cxp_1.consecutivo = rela_adc_cxp_1_cglposteo.consecutivo
                            and adc_cxp_1.secuencia = rela_adc_cxp_1_cglposteo.secuencia
                            and rela_adc_cxp_1_cglposteo.cgl_consecutivo = ai_consecutivo;
                            if found then
                                return trim(r_proveedores.nomb_proveedor);
                            end if;
                        end if;
                    end if;
                end if;
            end if;
        end if;
             
    elsif trim(as_retornar) = ''PROVEEDOR'' then
        select into r_rela_cxpfact1_cglposteo * 
        from rela_cxpfact1_cglposteo
        where consecutivo = r_cglposteo.consecutivo;
        if found then
            select into r_cxpfact1 * from cxpfact1    
            where compania = r_rela_cxpfact1_cglposteo.compania
            and proveedor = r_rela_cxpfact1_cglposteo.proveedor
            and fact_proveedor = r_rela_cxpfact1_cglposteo.fact_proveedor;
            if found then
                return trim(r_cxpfact1.proveedor);
            end if;
        else
            select into r_rela_cxpajuste1_cglposteo *
            from rela_cxpajuste1_cglposteo
            where consecutivo = r_cglposteo.consecutivo;
            if found then
                select into r_cxpajuste1 *
                from cxpajuste1
                where compania = r_rela_cxpajuste1_cglposteo.compania
                and sec_sjuste_cxp = r_rela_cxpajuste1_cglposteo.sec_ajuste_cxp;
                if found then
                    return trim(r_cxpajuste1.proveedor);
                end if;
            end if;
        end if;
    
    elsif trim(as_retornar) = ''TIPO'' then
        select into r_rela_cxpfact1_cglposteo * 
        from rela_cxpfact1_cglposteo
        where consecutivo = r_cglposteo.consecutivo;
        if found then
            select into r_cxpfact1 * from cxpfact1    
            where compania = r_rela_cxpfact1_cglposteo.compania
            and proveedor = r_rela_cxpfact1_cglposteo.proveedor
            and fact_proveedor = r_rela_cxpfact1_cglposteo.fact_proveedor;
            if found then
                return ''FACTURA'';
            end if;
        else
            select into r_rela_cxpajuste1_cglposteo *
            from rela_cxpajuste1_cglposteo
            where consecutivo = r_cglposteo.consecutivo;
            if found then
                select into r_cxpajuste1 *
                from cxpajuste1
                where compania = r_rela_cxpajuste1_cglposteo.compania
                and sec_sjuste_cxp = r_rela_cxpajuste1_cglposteo.sec_ajuste_cxp;
                if found then
                    select into r_cxpmotivos *
                    from cxpmotivos
                    where motivo_cxp = r_cxpajuste1.motivo_cxp;
                    if found then
                        return trim(r_cxpmotivos.desc_motivos_cxp);
                    end if;
                end if;
            end if;
        end if;
    
    elsif trim(as_retornar) = ''DOCUMENTO'' then
        select into r_rela_cxpfact1_cglposteo * 
        from rela_cxpfact1_cglposteo
        where consecutivo = r_cglposteo.consecutivo;
        if found then
            select into r_cxpfact1 * from cxpfact1    
            where compania = r_rela_cxpfact1_cglposteo.compania
            and proveedor = r_rela_cxpfact1_cglposteo.proveedor
            and fact_proveedor = r_rela_cxpfact1_cglposteo.fact_proveedor;
            if found then
                return trim(r_cxpfact1.fact_proveedor);
            end if;
        else
            select into r_rela_cxpajuste1_cglposteo *
            from rela_cxpajuste1_cglposteo
            where consecutivo = r_cglposteo.consecutivo;
            if found then
                select into r_cxpajuste1 *
                from cxpajuste1
                where compania = r_rela_cxpajuste1_cglposteo.compania
                and sec_sjuste_cxp = r_rela_cxpajuste1_cglposteo.sec_ajuste_cxp;
                if found then
                    return trim(r_cxpajuste1.docm_ajuste_cxp);
                end if;
            end if;
        end if;
    
    elsif trim(as_retornar) = ''OBSERVACION'' then
        select into r_rela_cxpfact1_cglposteo * 
        from rela_cxpfact1_cglposteo
        where consecutivo = r_cglposteo.consecutivo;
        if found then
            select into r_cxpfact1 * from cxpfact1    
            where compania = r_rela_cxpfact1_cglposteo.compania
            and proveedor = r_rela_cxpfact1_cglposteo.proveedor
            and fact_proveedor = r_rela_cxpfact1_cglposteo.fact_proveedor;
            if found then
                return trim(r_cxpfact1.obs_fact_cxp);
            end if;
        else
            select into r_rela_cxpajuste1_cglposteo *
            from rela_cxpajuste1_cglposteo
            where consecutivo = r_cglposteo.consecutivo;
            if found then
                select into r_cxpajuste1 *
                from cxpajuste1
                where compania = r_rela_cxpajuste1_cglposteo.compania
                and sec_sjuste_cxp = r_rela_cxpajuste1_cglposteo.sec_ajuste_cxp;
                if found then
                    return trim(r_cxpajuste1.obs_ajuste_cxp);
                end if;
            else
                select into r_rela_caja_trx1_cglposteo *
                from rela_caja_trx1_cglposteo
                where consecutivo = r_cglposteo.consecutivo;
                if found then
                    select into r_caja_trx1 * 
                    from caja_trx1
                    where caja = r_rela_caja_trx1_cglposteo.caja
                    and numero_trx = r_rela_caja_trx1_cglposteo.numero_trx;
                    if found then
                        return trim(r_caja_trx1.concepto);
                    end if;
                else
                    select into r_rela_bcotransac1_cglposteo *
                    from rela_bcotransac1_cglposteo
                    where consecutivo = r_cglposteo.consecutivo;
                    if found then
                        select into r_bcotransac1 *
                        from bcotransac1
                        where cod_ctabco = r_rela_bcotransac1_cglposteo.cod_ctabco
                        and sec_transacc = r_rela_bcotransac1_cglposteo.sec_transacc;
                        if found then
                            return trim(r_bcotransac1.obs_transac_bco);
                        end if;
                    end if;
                end if;
            end if;
        end if;
    
    end if;
    
    
    
    return lc_retornar;
end;
' language plpgsql;




create function f_cglposteo_itbms(int4, char(20)) returns decimal as '
declare
    ai_consecutivo alias for $1;
    as_retornar alias for $2;
    r_cglposteo record;
    r_rela_cxpfact1_cglposteo record;
    r_rela_cxpajuste1_cglposteo record;
    r_cxpajuste1 record;
    r_cxpmotivos record;
    r_rela_bcocheck1_cglposteo record;
    r_rela_bcotransac1_cglposteo record;
    r_rela_caja_trx1_cglposteo record;
    ldc_retornar decimal;
    ldc_work decimal;
    ldc_compra decimal;
    ldc_compra_gravada decimal;
    ldc_compra_excenta decimal;
    ldc_itbms decimal;
begin
    ldc_retornar = 0;
    select into r_cglposteo * from cglposteo
    where consecutivo = ai_consecutivo;
    if not found then
        return 0;
    end if;
    
    if trim(as_retornar) = ''ITBMS'' then
        return r_cglposteo.debito - r_cglposteo.credito;
    else
        if r_cglposteo.aplicacion_origen = ''CXP'' or 
            r_cglposteo.aplicacion_origen = ''TAL'' or 
            r_cglposteo.aplicacion_origen = ''COM'' then
            select into r_rela_cxpfact1_cglposteo *
            from rela_cxpfact1_cglposteo
            where consecutivo = ai_consecutivo;
            if found then
                ldc_retornar = 0;
                ldc_work = 0;
                select sum(cxpfact2.monto) into ldc_retornar
                from cxpfact2
                where compania = r_rela_cxpfact1_cglposteo.compania
                and proveedor = r_rela_cxpfact1_cglposteo.proveedor
                and fact_proveedor = r_rela_cxpfact1_cglposteo.fact_proveedor
                and cuenta <> r_cglposteo.cuenta;
                
                select sum(eys2.costo) into ldc_work
                from eys2
                where compania = r_rela_cxpfact1_cglposteo.compania
                and proveedor = r_rela_cxpfact1_cglposteo.proveedor
                and fact_proveedor = r_rela_cxpfact1_cglposteo.fact_proveedor;
                
                if ldc_retornar is null then
                    ldc_retornar = 0;
                end if;
                
                if ldc_work is null then
                    ldc_work = 0;
                end if;

                ldc_compra = ldc_retornar + ldc_work;
                ldc_itbms = r_cglposteo.debito - r_cglposteo.credito;
                ldc_compra_gravada = 100 * ldc_itbms / 7;

                
                if trim(as_retornar) = ''COMPRA_GRAVADA'' then
                    if ldc_compra_gravada <= ldc_compra then
                        return ldc_compra_gravada;
                    else
                        return ldc_compra;
                    end if;     
                else
                    if ldc_compra > ldc_compra_gravada then
                        return ldc_compra - ldc_compra_gravada;
                    else
                        return 0;
                    end if;
                end if;
            else
                select into r_rela_cxpajuste1_cglposteo *
                from rela_cxpajuste1_cglposteo
                where consecutivo = r_cglposteo.consecutivo;
                if found then
                    select into r_cxpajuste1 *
                    from cxpajuste1
                    where compania = r_rela_cxpajuste1_cglposteo.compania
                    and sec_ajuste_cxp = r_rela_cxpajuste1_cglposteo.sec_ajuste_cxp;
                    
                    select into r_cxpmotivos *
                    from cxpmotivos
                    where motivo_cxp = r_cxajuste1.motivo_cxp;
                    
                    select into ldc_retornar sum(monto)*r_cxpmotivos.signo
                    from cxpajuste3
                    where compania = r_rela_cxpajuste1_cglposteo.compania
                    and sec_ajuste_cxp = r_rela_cxajuste1_cglposteo.sec_ajuste_cxp
                    and cuenta <> r_cglposteo.cuenta;
                    return ldc_retornar;
                end if;
            end if;
            
        elsif r_cglposteo.aplicacion_origen = ''BCO'' then
            select into r_rela_bcocheck1_cglposteo *
            from rela_bcocheck1_cglposteo
            where consecutivo = ai_consecutivo;
            if found then
                select into ldc_retornar sum(monto)
                from bcocheck2
                where cod_ctabco = r_rela_bcocheck1_cglposteo.cod_ctabco
                and motivo_bco = r_rela_bcocheck1_cglposteo.motivo_bco
                and no_cheque = r_rela_bcocheck1_cglposteo.no_cheque
                and cuenta <> r_cglposteo.cuenta;
                
                ldc_compra = ldc_retornar;
                ldc_itbms = r_cglposteo.debito - r_cglposteo.credito;
                ldc_compra_gravada = 100 * ldc_itbms / 7;

                
                if trim(as_retornar) = ''COMPRA_GRAVADA'' then
                    if ldc_compra_gravada <= ldc_compra then
                        return ldc_compra_gravada;
                    else
                        return ldc_compra;
                    end if;     
                else
                    if ldc_compra > ldc_compra_gravada then
                        return ldc_compra - ldc_compra_gravada;
                    else
                        return 0;
                    end if;
                end if;
            else
                select into r_rela_bcotransac1_cglposteo *
                from rela_bcotransac1_cglposteo
                where consecutivo = r_cglposteo.consecutivo;
                
                select into ldc_retornar -sum(bcotransac2.monto*bcomotivos.signo)
                from bcomotivos, bcotransac2, bcotransac1
                where bcomotivos.motivo_bco = bcotransac1.motivo_bco
                and bcotransac1.cod_ctabco = bcotransac2.cod_ctabco
                and bcotransac1.sec_transacc = bcotransac2.sec_transacc
                and bcotransac1.cod_ctabco = r_rela_bcotransac1_cglposteo.cod_ctabco
                and bcotransac1.sec_transacc = r_rela_bcotransac1_cglposteo.sec_transacc
                and bcotransac2.cuenta <> r_cglposteo.cuenta;

                ldc_compra = ldc_retornar;
                ldc_itbms = r_cglposteo.debito - r_cglposteo.credito;
                ldc_compra_gravada = 100 * ldc_itbms / 7;

                
                if trim(as_retornar) = ''COMPRA_GRAVADA'' then
                    if ldc_compra_gravada <= ldc_compra then
                        return ldc_compra_gravada;
                    else
                        return ldc_compra;
                    end if;     
                else
                    if ldc_compra > ldc_compra_gravada then
                        return ldc_compra - ldc_compra_gravada;
                    else
                        return 0;
                    end if;
                end if;
                
            end if;
        
        
        elsif r_cglposteo.aplicacion_origen = ''CAJ'' then
            select into r_rela_caja_trx1_cglposteo *
            from rela_caja_trx1_cglposteo
            where consecutivo = r_cglposteo.consecutivo;
            
            select into ldc_retornar sum(caja_trx2.monto) 
            from caja_trx2
            where caja = r_rela_caja_trx1_cglposteo.caja
            and numero_trx = r_rela_caja_trx1_cglposteo.numero_trx
            and cuenta <> r_cglposteo.cuenta;

            ldc_compra = ldc_retornar;
            ldc_itbms = r_cglposteo.debito - r_cglposteo.credito;
            ldc_compra_gravada = (100 * ldc_itbms) / 7;
            
            
            if trim(as_retornar) = ''COMPRA_GRAVADA'' then
                if ldc_compra_gravada <= ldc_compra then
                    return ldc_compra_gravada;
                else
                    return ldc_compra;
                end if;     
            else
                if ldc_compra > ldc_compra_gravada then
                    return ldc_compra - ldc_compra_gravada;
                else 
                    return 0;
                end if;
            end if;
        
        end if;
    end if;
    return ldc_retornar;
end;
' language plpgsql;



create function f_update_cglsldocuenta(char(2), int4, int4) returns integer as '
declare
    as_compania alias for $1;
    ai_anio alias for $2;
    ai_mes alias for $3;
    r_gralperiodos record;
    ld_ultimo_cierre date;
begin
    select into ld_ultimo_cierre Max(final) from gralperiodos
    where compania = as_compania
    and aplicacion = ''CGL''
    and year = ai_anio
    and periodo = ai_mes;
    if not found then
        return 0;
    end if;
    
    
    if ld_ultimo_cierre is null then
        return 0;
    end if;
    
    for r_gralperiodos in select * from gralperiodos
                                where compania = as_compania
                                and aplicacion = ''CGL''
                                and year = ai_anio
                                and periodo = ai_mes
                                order by inicio
    loop
    
        insert into cglsldoaux1
        select cglposteo.compania, cglposteo.cuenta, 
        cglposteoaux1.auxiliar, 
        cglposteo.year, 
        cglposteo.periodo,  0, 
        sum(cglposteo.debito), sum(cglposteo.credito)
        from cglposteo, cglposteoaux1
        where cglposteo.consecutivo = cglposteoaux1.consecutivo
        and cglposteo.compania = as_compania
        and cglposteo.year = r_gralperiodos.year
        and cglposteo.periodo = r_gralperiodos.periodo
        and not exists
            (select * from cglsldoaux1 b
                where b.compania = cglposteo.compania
                and b.year = cglposteo.year
                and b.periodo = cglposteo.periodo
                and b.auxiliar = cglposteoaux1.auxiliar)
        group by 1, 2, 3, 4, 5;
    
        update cglsldocuenta
        set debito = v_cglposteo.debito, credito = v_cglposteo.credito
        where cglsldocuenta.compania = v_cglposteo.compania
        and cglsldocuenta.year = v_cglposteo.year
        and cglsldocuenta.periodo = v_cglposteo.periodo
        and cglsldocuenta.cuenta = v_cglposteo.cuenta
        and cglsldocuenta.compania = as_compania
        and cglsldocuenta.year = r_gralperiodos.year
        and cglsldocuenta.periodo = r_gralperiodos.periodo;


        update cglsldoaux1
        set debito = v_cglsldoaux1.debito, credito = v_cglsldoaux1.credito
        where cglsldoaux1.compania = v_cglsldoaux1.compania
        and cglsldoaux1.cuenta = v_cglsldoaux1.cuenta
        and cglsldoaux1.auxiliar = v_cglsldoaux1.auxiliar
        and cglsldoaux1.year = v_cglsldoaux1.year
        and cglsldoaux1.periodo = v_cglsldoaux1.periodo
        and cglsldoaux1.compania = as_compania
        and cglsldoaux1.year = r_gralperiodos.year
        and cglsldoaux1.periodo = r_gralperiodos.periodo;
        
    end loop;    
        
    return 1;
end;
' language plpgsql;


create function f_update_balance_inicio_cgl(char(2)) returns integer as '
declare
    as_compania alias for $1;
    ldc_balance_inicio decimal(10,2);
    r_gralperiodos record;
    r_cglsldocuenta record;
    r_cglsldoaux1 record;
    r_cglsldoaux2 record;
    r_cglcuentas record;
    r_work record;
    ld_work date;
    li_next_year integer;
    li_next_periodo integer;
    li_dias integer;
begin
    select into ld_work Min(inicio) from gralperiodos
    where compania = as_compania
    and aplicacion = ''CGL''
    and estado = ''A'';
    if not found then
        return 0;
    end if;
    
    for r_gralperiodos in select * from gralperiodos
                        where compania = as_compania
                        and aplicacion = ''CGL''
                        and estado = ''A''
                        and inicio >= ld_work
                        order by inicio
    loop
        li_next_year = r_gralperiodos.year;
        li_next_periodo = r_gralperiodos.periodo + 1;
        if li_next_periodo > 13 then
            li_next_periodo = 1;
            li_next_year = r_gralperiodos.year + 1;
        end if;
        
        li_dias =   r_gralperiodos.final - current_date;
        
        if li_dias >= 65 then
            Exit;
        end if;
        
        update cglsldocuenta
        set balance_inicio = 0
        where compania = as_compania
        and year = li_next_year
        and periodo = li_next_periodo;
        
        update cglsldoaux1
        set balance_inicio = 0
        where compania = as_compania
        and year = li_next_year
        and periodo = li_next_periodo;

        update cglsldoaux2
        set balance_inicio = 0
        where compania = as_compania
        and year = li_next_year
        and periodo = li_next_periodo;
        
        for r_cglsldocuenta in select cglsldocuenta.* from cglsldocuenta
                                where cglsldocuenta.compania = as_compania
                                and cglsldocuenta.year = r_gralperiodos.year
                                and cglsldocuenta.periodo = r_gralperiodos.periodo
                                order by cglsldocuenta.cuenta
        loop
            ldc_balance_inicio = r_cglsldocuenta.balance_inicio + r_cglsldocuenta.debito - r_cglsldocuenta.credito;
            
            select into r_work * from cglsldocuenta
            where compania = as_compania
            and cuenta = r_cglsldocuenta.cuenta
            and year = li_next_year
            and periodo = li_next_periodo;
            if not found then
                insert into cglsldocuenta (compania, cuenta, year, periodo, balance_inicio,
                    debito, credito)
                values (as_compania, r_cglsldocuenta.cuenta,
                        li_next_year, li_next_periodo, ldc_balance_inicio, 0, 0);
            else
                update cglsldocuenta
                set balance_inicio = ldc_balance_inicio
                where compania = as_compania
                and cuenta = r_cglsldocuenta.cuenta
                and year = li_next_year
                and periodo = li_next_periodo;
            end if;
            
            for r_cglsldoaux1 in select cglsldoaux1.* from cglsldoaux1
                                    where cglsldoaux1.compania = as_compania
                                    and cglsldoaux1.year = r_gralperiodos.year
                                    and cglsldoaux1.periodo = r_gralperiodos.periodo
                                    and cglsldoaux1.cuenta = r_cglsldocuenta.cuenta
                                    order by cglsldoaux1.auxiliar
            loop
                ldc_balance_inicio = r_cglsldoaux1.balance_inicio + r_cglsldoaux1.debito - r_cglsldoaux1.credito;
                select into r_work * from cglsldoaux1
                where compania = as_compania
                and cuenta = r_cglsldoaux1.cuenta
                and auxiliar = r_cglsldoaux1.auxiliar
                and year = li_next_year
                and periodo = li_next_periodo;
                if not found then
                    insert into cglsldoaux1 (compania, cuenta, auxiliar, year, periodo, balance_inicio,
                        debito, credito)
                    values (as_compania, r_cglsldoaux1.cuenta, r_cglsldoaux1.auxiliar,
                            li_next_year, li_next_periodo, ldc_balance_inicio, 0, 0);
                else
                    update cglsldoaux1
                    set balance_inicio = ldc_balance_inicio
                    where compania = as_compania
                    and cuenta = r_cglsldoaux1.cuenta
                    and auxiliar = r_cglsldoaux1.auxiliar
                    and year = li_next_year
                    and periodo = li_next_periodo;
                end if;
            end loop;

            for r_cglsldoaux2 in select cglsldoaux2.* from cglsldoaux2
                                    where cglsldoaux2.compania = as_compania
                                    and cglsldoaux2.year = r_gralperiodos.year
                                    and cglsldoaux2.periodo = r_gralperiodos.periodo
                                    and cglsldoaux2.cuenta = r_cglsldocuenta.cuenta
                                    order by cglsldoaux2.auxiliar
            loop
                ldc_balance_inicio = r_cglsldoaux2.balance_inicio + r_cglsldoaux2.debito - r_cglsldoaux2.credito;
                select into r_work * from cglsldoaux2
                where compania = as_compania
                and cuenta = r_cglsldoaux2.cuenta
                and auxiliar = r_cglsldoaux2.auxiliar
                and year = li_next_year
                and periodo = li_next_periodo;
                if not found then
                    insert into cglsldoaux2 (compania, cuenta, auxiliar, year, periodo, balance_inicio,
                        debito, credito)
                    values (as_compania, r_cglsldoaux2.cuenta, r_cglsldoaux2.auxiliar,
                            li_next_year, li_next_periodo, ldc_balance_inicio, 0, 0);
                else
                    update cglsldoaux2
                    set balance_inicio = ldc_balance_inicio
                    where compania = as_compania
                    and cuenta = r_cglsldoaux2.cuenta
                    and auxiliar = r_cglsldoaux2.auxiliar
                    and year = li_next_year
                    and periodo = li_next_periodo;
                end if;
            end loop;
        end loop;
    end loop;
    return 1;
end;
' language plpgsql;


create function f_balance_inicio_cuenta(char(2), char(24), int4, int4) returns decimal as '
declare
    as_compania alias for $1;
    as_cuenta alias for $2;
    ai_year alias for $3;
    ai_periodo alias for $4;
    ldc_balance_inicio decimal(10,2);
    li_periodo int4;
    li_year int4;
begin
    li_year =   ai_year;
    li_periodo = ai_periodo;
    li_periodo = li_periodo - 1;
    if li_periodo = 0 then
        li_year = li_year - 1;
        li_periodo = 13;
    end if;
    
    select into ldc_balance_inicio (balance_inicio + debito - credito)
    from cglsldocuenta
    where cglsldocuenta.cuenta = as_cuenta
    and cglsldocuenta.compania = as_compania
    and cglsldocuenta.year = li_year
    and cglsldocuenta.periodo = li_periodo;
    
    if ldc_balance_inicio is null then
        ldc_balance_inicio = 0;
    end if;

    return ldc_balance_inicio;
end;
' language plpgsql;




create function f_postea_comprobantes(char(2)) returns integer as '
declare
    as_cia alias for $1;
    r_cgl_comprobante1 record;
    r_cglcomprobante1 record;
    i integer;
    ld_fecha date;
begin
    select into ld_fecha Min(inicio) from gralperiodos
    where compania = as_cia
    and aplicacion = ''CGL''
    and estado = ''A'';
    if not found then
        return 0;
    end if;
    
    for r_cglcomprobante1 in select * from cglcomprobante1
                    where compania = as_cia
                    and fecha_comprobante >= ld_fecha
                    and not exists
                        (select * from rela_cglcomprobante1_cglposteo
                        where rela_cglcomprobante1_cglposteo.compania = cglcomprobante1.compania
                        and rela_cglcomprobante1_cglposteo.secuencia = cglcomprobante1.secuencia
                        and rela_cglcomprobante1_cglposteo.aplicacion = cglcomprobante1.aplicacion
                        and rela_cglcomprobante1_cglposteo.year = cglcomprobante1.year
                        and rela_cglcomprobante1_cglposteo.periodo = cglcomprobante1.periodo)
                    order by fecha_comprobante
    loop
        i   :=  f_cglcomprobante1_cglposteo(r_cglcomprobante1.compania, r_cglcomprobante1.aplicacion,
                    r_cglcomprobante1.year, r_cglcomprobante1.periodo, r_cglcomprobante1.secuencia);
        
    end loop;
    

    for r_cgl_comprobante1 in select * from cgl_comprobante1
                    where compania = as_cia
                    and fecha >= ld_fecha
                    and not exists
                        (select * from rela_cgl_comprobante1_cglposteo
                        where rela_cgl_comprobante1_cglposteo.compania = cgl_comprobante1.compania
                        and rela_cgl_comprobante1_cglposteo.secuencia = cgl_comprobante1.secuencia)
                    order by fecha
    loop
        i   :=  f_cgl_comprobante1_cglposteo(r_cgl_comprobante1.compania, r_cgl_comprobante1.secuencia);
    end loop;
    
    return 1;
end;
' language plpgsql;



create function f_update_cglsldocuenta(char(2)) returns integer as '
declare
    as_compania alias for $1;
    r_gralperiodos record;
    ld_ultimo_cierre date;
begin
    select into ld_ultimo_cierre Max(final) from gralperiodos
    where compania = as_compania
    and aplicacion = ''CGL''
    and final <= current_date
    and estado = ''I'';
    if not found then
        return 0;
    end if;
    
    
    if ld_ultimo_cierre is null then
        return 0;
    end if;
    
    for r_gralperiodos in select * from gralperiodos
                                where compania = as_compania
                                and aplicacion = ''CGL''
                                and estado = ''A''
                                and inicio > ld_ultimo_cierre
                                order by inicio
    loop
    
        insert into cglsldoaux1
        select cglposteo.compania, cglposteo.cuenta, 
        cglposteoaux1.auxiliar, 
        cglposteo.year, 
        cglposteo.periodo,  0, 
        sum(cglposteo.debito), sum(cglposteo.credito)
        from cglposteo, cglposteoaux1
        where cglposteo.consecutivo = cglposteoaux1.consecutivo
        and cglposteo.compania = as_compania
        and cglposteo.year = r_gralperiodos.year
        and cglposteo.periodo = r_gralperiodos.periodo
        and not exists
            (select * from cglsldoaux1 b
                where b.compania = cglposteo.compania
                and b.year = cglposteo.year
                and b.periodo = cglposteo.periodo
                and b.auxiliar = cglposteoaux1.auxiliar)
        group by 1, 2, 3, 4, 5;
    
        update cglsldocuenta
        set debito = v_cglposteo.debito, credito = v_cglposteo.credito
        where cglsldocuenta.compania = v_cglposteo.compania
        and cglsldocuenta.year = v_cglposteo.year
        and cglsldocuenta.periodo = v_cglposteo.periodo
        and cglsldocuenta.cuenta = v_cglposteo.cuenta
        and cglsldocuenta.compania = as_compania
        and cglsldocuenta.year = r_gralperiodos.year
        and cglsldocuenta.periodo = r_gralperiodos.periodo;


        update cglsldoaux1
        set debito = v_cglsldoaux1.debito, credito = v_cglsldoaux1.credito
        where cglsldoaux1.compania = v_cglsldoaux1.compania
        and cglsldoaux1.cuenta = v_cglsldoaux1.cuenta
        and cglsldoaux1.auxiliar = v_cglsldoaux1.auxiliar
        and cglsldoaux1.year = v_cglsldoaux1.year
        and cglsldoaux1.periodo = v_cglsldoaux1.periodo
        and cglsldoaux1.compania = as_compania
        and cglsldoaux1.year = r_gralperiodos.year
        and cglsldoaux1.periodo = r_gralperiodos.periodo;
        
    end loop;    
        
    return 1;
end;
' language plpgsql;



create function f_cgl_comprobante1_cglposteo(char(2), int4) returns integer as '
declare
    as_compania alias for $1;
    ai_secuencia alias for $2;
    li_consecutivo int4;
    r_cgl_comprobante1 record;
    r_cgl_comprobante2 record;
    r_cglcuentas record;
    ldc_work decimal(10,2);
    ldc_work2 decimal(10,2);
begin
    
    delete from rela_cgl_comprobante1_cglposteo
    where compania = as_compania
    and secuencia = ai_secuencia;

    select into r_cgl_comprobante1 * from cgl_comprobante1
    where compania = as_compania
    and secuencia = ai_secuencia;
    if not found then
       return 0;
    end if;
    
    
    select into ldc_work sum(monto) from cgl_comprobante2
    where compania = as_compania
    and secuencia = ai_secuencia;
    if ldc_work is null or ldc_work <> 0 then
       Raise Exception ''Comprobante % esta en desbalance...Verifique %'',ai_secuencia, ldc_work;
       Return 0;
    end if;
    
    
    for r_cgl_comprobante2 in select * from cgl_comprobante2
                                where compania = as_compania
                                and secuencia = ai_secuencia
                                order by cuenta
    loop
       li_consecutivo := f_cglposteo(as_compania, ''CGL'', r_cgl_comprobante1.fecha,
                            r_cgl_comprobante2.cuenta, r_cgl_comprobante2.auxiliar, '' '',
                            ''00'', r_cgl_comprobante1.concepto, r_cgl_comprobante2.monto);
        if li_consecutivo > 0 then
            insert into rela_cgl_comprobante1_cglposteo (compania, secuencia, consecutivo)
            values (as_compania, ai_secuencia, li_consecutivo);
        end if;
    end loop;
    
    return 1;
end;
' language plpgsql;


create function f_cglsldocuenta_update_balance_inicio(char(2), char(24), int4, int4) returns integer as '
declare
    as_compania alias for $1;
    as_cuenta alias for $2;
    ai_year alias for $3;
    ai_periodo alias for $4;
    r_cglsldocuenta record;
    r_gralperiodos record;
    ldc_balance_final decimal(10,2);
    li_year integer;
    li_periodo integer;
    ld_inicio date;
begin
    select into r_cglsldocuenta * from cglsldocuenta
    where cglsldocuenta.cuenta = as_cuenta
    and cglsldocuenta.compania = as_compania
    and cglsldocuenta.year = ai_year
    and cglsldocuenta.periodo = ai_periodo;
    if found then                            
       ldc_balance_final = r_cglsldocuenta.balance_inicio + r_cglsldocuenta.debito -
                            r_cglsldocuenta.credito;        
    else
       ldc_balance_final = 0;
    end if;

            
        
    select into ld_inicio inicio from gralperiodos
    where compania = as_compania
    and aplicacion = ''CGL''
    and year = ai_year
    and periodo = ai_periodo;
    if not found then
       return 0;
    end if;

    for r_gralperiodos in select * from gralperiodos
                            where compania = as_compania
                            and inicio > ld_inicio
                            and aplicacion = ''CGL''
                            and estado = ''A''
                            order by year, periodo
    loop
        select into r_cglsldocuenta * from cglsldocuenta
        where compania = as_compania
        and year = r_gralperiodos.year
        and periodo = r_gralperiodos.periodo
        and cuenta = as_cuenta;
        if not found then
            insert into cglsldocuenta (compania, cuenta, year, periodo, balance_inicio,
                debito, credito)
            values (as_compania, as_cuenta, r_gralperiodos.year, r_gralperiodos.periodo, 
                ldc_balance_final, 0, 0);
        else
            update cglsldocuenta
            set balance_inicio = ldc_balance_final
            where compania = as_compania
            and year = r_gralperiodos.year
            and periodo = r_gralperiodos.periodo
            and cuenta = as_cuenta;

            
            ldc_balance_final := ldc_balance_final + r_cglsldocuenta.debito - r_cglsldocuenta.credito;
        end if;

    if as_cuenta = ''21.07'' then
--        raise exception ''entre % '', ld_inicio;
    end if;
        
        if (r_gralperiodos.inicio - 31) > current_date then
            return 1;
        end if;
    end loop;
    
        
    return 1;
end;
' language plpgsql;


create function f_update_balances_y_niveles(char(2)) returns integer as '
declare
    as_compania alias for $1;
    r_gralperiodos record;
    r_gralperiodos2 record;
    r_cglsldocuenta record;
    r_cglsldocuenta2 record;
    r_cglsldoaux1 record;
    r_cglsldoaux12 record;
    r_work record;
    r_cglcuentas record;
    ld_work date;
    i integer;
    ldc_balance_final decimal(10,2);
    li_year integer;
    li_periodo integer;
begin
    select into ld_work Max(inicio) from gralperiodos
    where compania = as_compania
    and aplicacion = ''CGL''
    and estado = ''I''
    and inicio <= current_date;
    if not found or ld_work is null then
       return 0;
    end if;

    select into r_gralperiodos * from gralperiodos
    where compania = as_compania
    and aplicacion = ''CGL''
    and inicio = ld_work;
    
    delete from cglsldocuenta
    where cglsldocuenta.compania = gralperiodos.compania
    and cglsldocuenta.year = gralperiodos.year
    and cglsldocuenta.periodo = gralperiodos.periodo
    and cglsldocuenta.compania = as_compania
    and gralperiodos.aplicacion = ''CGL''
    and gralperiodos.estado = ''A''
    and gralperiodos.inicio > ld_work
    and cglsldocuenta.balance_inicio = 0 
    and cglsldocuenta.debito = 0
    and cglsldocuenta.credito = 0;
    

    update cglsldocuenta
    set balance_inicio = 0
    where cglsldocuenta.compania = gralperiodos.compania
    and cglsldocuenta.year = gralperiodos.year
    and cglsldocuenta.periodo = gralperiodos.periodo
    and cglsldocuenta.compania = as_compania
    and gralperiodos.aplicacion = ''CGL''
    and gralperiodos.estado = ''A''
    and gralperiodos.inicio > ld_work;
    
    update cglsldoaux1
    set balance_inicio = 0
    where cglsldoaux1.compania = gralperiodos.compania
    and cglsldoaux1.year = gralperiodos.year
    and cglsldoaux1.periodo = gralperiodos.periodo
    and cglsldoaux1.compania = as_compania
    and gralperiodos.aplicacion = ''CGL''
    and gralperiodos.estado = ''A''
    and gralperiodos.inicio > ld_work;
    
    
    for r_cglcuentas in select * from cglcuentas, cglniveles
                            where cglcuentas.nivel = cglniveles.nivel
                            and cglniveles.recibe = ''S''
                            order by cglcuentas.cuenta    
    loop
        i := f_cglsldocuenta_update_balance_inicio(as_compania, r_cglcuentas.cuenta, r_gralperiodos.year, r_gralperiodos.periodo);
        
       
        for r_work in select auxiliar from cglsldoaux1
                            where cuenta = r_cglcuentas.cuenta
                            and compania = as_compania
                            group by 1
                            order by 1
        loop
            i := f_balance_inicio_cglsldoaux1(as_compania, r_cglcuentas.cuenta, r_work.auxiliar, r_gralperiodos.year, r_gralperiodos.periodo);
        end loop;

        
/*        
        for r_cglsldoaux1 in select * from cglsldoaux1
            where cglsldoaux1.cuenta = r_cglcuentas.cuenta
            and cglsldoaux1.compania = as_compania
            and cglsldoaux1.year = r_gralperiodos.year
            and cglsldoaux1.periodo = r_gralperiodos.periodo
            order by auxiliar
        loop
            i := f_balance_inicio_cglsldoaux1(as_compania, r_cglcuentas.cuenta, r_cglsldoaux1.auxiliar, r_gralperiodos.year, r_gralperiodos.periodo);
        end loop;    
*/        
    end loop;

    return 1;
end;
' language plpgsql;



create function f_cglsldocuenta_update_niveles(char(2), char(24), int4, int4, decimal(10,2), decimal(10,2), decimal(10,2)) returns integer as '
declare
    as_compania alias for $1;
    as_cuenta alias for $2;
    ai_year alias for $3;
    ai_periodo alias for $4;
    adc_balance_inicio alias for $5;
    adc_debito alias for $6;
    adc_credito alias for $7;
    r_cglniveles record;
    r_cglcuentas record;
    r_cglsldocuenta record;
    ls_cuenta char(24);
    r_work record;
begin
    select into r_cglcuentas cglcuentas.* from cglcuentas, cglniveles
    where cglcuentas.nivel = cglniveles.nivel
    and cglniveles.recibe = ''N''
    and cglcuentas.cuenta = as_cuenta;
    if found then
       return 0;
    end if;

    select into r_cglcuentas * from cglcuentas
    where cuenta = as_cuenta;
    
    if adc_balance_inicio = 0 and adc_debito = 0 and adc_credito = 0 then
        return 0;
    end if;
    
    for r_cglniveles in select * from cglniveles
                            where recibe = ''N'' 
                            order by posicion_inicial desc
    loop
        ls_cuenta = substring(as_cuenta from 1 for r_cglniveles.posicion_final);
        
        select into r_cglcuentas * from cglcuentas
        where trim(cuenta) = trim(ls_cuenta);
        if not found then
        
            select into r_cglcuentas * from cglcuentas
            where cuenta = as_cuenta;
        
           insert into cglcuentas (cuenta, nombre, nivel, naturaleza,
    		auxiliar_1, auxiliar_2, efectivo, tipo_cuenta, status)
    	   values (trim(ls_cuenta), ''GENERADA POR ABACO '' || trim(ls_cuenta), 
            r_cglniveles.nivel, r_cglcuentas.naturaleza, ''N'', ''N'', 
            ''N'', r_cglcuentas.tipo_cuenta, ''A'');
            
        end if;
        
        select into r_cglsldocuenta * from cglsldocuenta
        where compania = as_compania
        and trim(cuenta) = trim(ls_cuenta)
        and year = ai_year
        and periodo = ai_periodo;
        if not found then
            insert into cglsldocuenta (compania, cuenta, year, periodo, balance_inicio,
                debito, credito)
            values (as_compania, ls_cuenta, ai_year, ai_periodo, adc_balance_inicio,
                adc_debito, adc_credito);
        else
            update cglsldocuenta
            set    debito         = debito + adc_debito,
                   credito        = credito + adc_credito,
                   balance_inicio = balance_inicio + adc_balance_inicio
            where  compania       = as_compania
            and    trim(cuenta)   = trim(ls_cuenta)
            and    year           = ai_year
            and    periodo        = ai_periodo;
        end if;
    end loop;
 
    return 1;
end;
' language plpgsql;


create function f_balance_inicio_cglsldoaux1(char(2), char(24), char(10), int4, int4) returns decimal(10,2) as '
declare
    as_compania alias for $1;
    as_cuenta alias for $2;
    as_auxiliar alias for $3;
    ai_year alias for $4;
    ai_periodo alias for $5;
    r_gralperiodos record;
    r_cglsldoaux1 record;
    ldc_balance_inicio decimal(10,2);
    ldc_balance_final decimal(10,2);
    li_year int4;
    li_periodo int4;
    ld_fecha date;
    ld_inicio date;
    r_cglsldocuenta record;
begin
    select into r_cglsldoaux1 * from cglsldoaux1
    where cglsldoaux1.cuenta = as_cuenta
    and cglsldoaux1.auxiliar = as_auxiliar
    and cglsldoaux1.compania = as_compania
    and cglsldoaux1.year = ai_year
    and cglsldoaux1.periodo = ai_periodo;
    if found then                            
       ldc_balance_final := r_cglsldoaux1.balance_inicio + r_cglsldoaux1.debito -
                            r_cglsldoaux1.credito;        
    else
       ldc_balance_final := 0;
    end if;
    
    select into ld_inicio inicio from gralperiodos
    where compania = as_compania
    and aplicacion = ''CGL''
    and year = ai_year
    and periodo = ai_periodo;
    if not found then
       return 0;
    end if;
    
    for r_gralperiodos in select * from gralperiodos
                            where compania = as_compania
                            and inicio > ld_inicio
                            and aplicacion = ''CGL''
                            and estado = ''A''
                            order by year, periodo
    loop
        select into r_cglsldoaux1 * from cglsldoaux1
        where compania = as_compania
        and year = r_gralperiodos.year
        and periodo = r_gralperiodos.periodo
        and cuenta = as_cuenta
        and auxiliar = as_auxiliar;
        if not found then
            if ldc_balance_final <> 0 then
                select into r_cglsldocuenta * from cglsldocuenta
                where compania = as_compania 
                and cuenta = as_cuenta
                and year = r_gralperiodos.year
                and periodo = r_gralperiodos.periodo;
                if found then
                    insert into cglsldoaux1 (compania, cuenta, auxiliar, year, periodo, balance_inicio,
                        debito, credito)
                    values (as_compania, as_cuenta, as_auxiliar, r_gralperiodos.year, r_gralperiodos.periodo, 
                        ldc_balance_final, 0, 0);
                end if;
            end if;
        else
            update cglsldoaux1
            set balance_inicio = ldc_balance_final
            where compania = as_compania
            and year = r_gralperiodos.year
            and periodo = r_gralperiodos.periodo
            and cuenta = as_cuenta
            and auxiliar = as_auxiliar;
            
            ldc_balance_final := ldc_balance_final + r_cglsldoaux1.debito - r_cglsldoaux1.credito;
        end if;
    end loop;
    
    return 1;
end;
' language plpgsql;


create function f_cglsldocuenta(char(2), char(24), int4, int4, decimal(10,2), decimal(10,2)) returns integer as '
declare
    as_compania alias for $1;
    as_cuenta alias for $2;
    ai_year alias for $3;
    ai_periodo alias for $4;
    adc_debito alias for $5;
    adc_credito alias for $6;
    r_cglsldocuenta record;
    ldc_balance_final decimal(20,2);
    ldc_balance_inicio decimal(20,2);
    li_year int4;
    li_periodo int4;
    i integer;
begin
    ldc_balance_inicio = f_balance_inicio_cglsldocuenta(as_compania, as_cuenta, ai_year, ai_periodo);

    select into r_cglsldocuenta * from cglsldocuenta
    where compania = as_compania
    and cuenta = as_cuenta
    and year = ai_year
    and periodo = ai_periodo;
    if not found then
       insert into cglsldocuenta (compania, cuenta, year, periodo, balance_inicio,debito, credito)
       values (as_compania, as_cuenta, ai_year, ai_periodo, ldc_balance_inicio, adc_debito, adc_credito);
    else
       update cglsldocuenta
       set    debito            = debito + adc_debito,
              credito           = credito + adc_credito
       where  compania     = as_compania
       and    cuenta       = as_cuenta
       and    year         = ai_year
       and    periodo      = ai_periodo;
       ldc_balance_inicio = r_cglsldocuenta.balance_inicio;
    end if;
    
    i = f_cglsldocuenta_update_balance_inicio(as_compania, as_cuenta, ai_year, ai_periodo);

    return 1;
end;
' language plpgsql;



create function f_balance_inicio_cglsldocuenta(char(2), char(24), int4, int4) returns decimal(20,2) as '
declare
    as_compania alias for $1;
    as_cuenta alias for $2;
    ai_year alias for $3;
    ai_periodo alias for $4;
    r_gralperiodos record;
    r_cglsldocuenta record;
    ldc_balance_inicio decimal(20,2);
    li_year int4;
    li_periodo int4;
    li_dias int4;
    ld_fecha date;
begin
    ldc_balance_inicio = 0;
    
    select into r_gralperiodos *
    from gralperiodos
    where compania = as_compania
    and aplicacion = ''CGL''
    and year = ai_year
    and periodo = ai_periodo;
    if found then
        select sum(cglposteo.debito-cglposteo.credito) into ldc_balance_inicio
        from cglposteo
        where compania = as_compania
        and cuenta = as_cuenta
        and fecha_comprobante < r_gralperiodos.inicio;
        if ldc_balance_inicio is null then
            ldc_balance_inicio = 0;
        end if;
        return ldc_balance_inicio;
        
    else
        return 0;
    end if;
        
    select into ld_fecha Max(inicio) from gralperiodos
    where compania = as_compania
    and aplicacion = ''CGL''
    and estado = ''I'';
    if not found or ld_fecha is null then
       return 0;
    end if;
    

    for r_gralperiodos in select * from gralperiodos
                            where compania = as_compania
                            and inicio > ld_fecha
                            and aplicacion = ''CGL''
                            and estado = ''A''
                            order by year, periodo
    loop
        li_year     =   r_gralperiodos.year;
        li_periodo  =   r_gralperiodos.periodo;

        li_dias     =   r_gralperiodos.final - current_date;
        if li_dias >= 65 then
            Exit;
        end if;

        select into r_cglsldocuenta * from cglsldocuenta
        where compania = as_compania
        and cuenta = as_cuenta
        and year = li_year
        and periodo = li_periodo;
        if found then
            ldc_balance_inicio = ldc_balance_inicio + r_cglsldocuenta.balance_inicio + r_cglsldocuenta.debito - r_cglsldocuenta.credito;
        end if;
    end loop;
    
    return ldc_balance_inicio;
end;
' language plpgsql;



create function f_cglsldoaux1(char(2), char(24), char(10), int4, int4, decimal(10,2), decimal(10,2)) returns integer as '
declare
    as_compania alias for $1;
    as_cuenta alias for $2;
    as_auxiliar alias for $3;
    ai_year alias for $4;
    ai_periodo alias for $5;
    adc_debito alias for $6;
    adc_credito alias for $7;
    r_cglsldoaux1 record;
    r_cglsldocuenta record;
    ldc_balance_final decimal(10,2);
    li_year int4;
    li_periodo int4;
begin
    select into r_cglsldoaux1 * from cglsldoaux1
    where compania = as_compania
    and cuenta = as_cuenta
    and auxiliar = as_auxiliar
    and year = ai_year
    and periodo = ai_periodo;
    if not found then
        select into r_cglsldocuenta * from cglsldocuenta
        where compania = as_compania
        and trim(cuenta) = trim(as_cuenta)
        and year = ai_year
        and periodo = ai_periodo;
        if found then
--           r_cglsldoaux1.balance_inicio := f_balance_inicio_cglsldoaux1(as_compania, 
--                                               as_cuenta, as_auxiliar, ai_year, ai_periodo);
            r_cglsldoaux1.balance_inicio := 0;            
           insert into cglsldoaux1 (compania, cuenta, auxiliar, year, periodo, balance_inicio,
                        debito, credito)
           values (as_compania, trim(as_cuenta), as_auxiliar, ai_year, ai_periodo, 
                        r_cglsldoaux1.balance_inicio, adc_debito, adc_credito);
        end if;                        
    else
       update cglsldoaux1
       set    debito       = debito + adc_debito,
              credito      = credito + adc_credito
       where  compania = as_compania
       and    cuenta = as_cuenta
       and    auxiliar = as_auxiliar
       and    year = ai_year
       and    periodo = ai_periodo;
    end if;
    
    r_cglsldoaux1.balance_inicio := f_balance_inicio_cglsldoaux1(as_compania, 
                                      as_cuenta, as_auxiliar, ai_year, ai_periodo);

    return 1;
end;
' language plpgsql;


create function f_cglcomprobante1_cglposteo(char(2), char(3), int4, int4, int4) returns integer as '
declare
    as_compania alias for $1;
    as_aplicacion alias for $2;
    ai_year alias for $3;
    ai_periodo alias for $4;
    ai_secuencia alias for $5;
    li_consecutivo int4;
    r_cglcomprobante1 record;
    r_cglcomprobante2 record;
    r_cglcomprobante3 record;
    r_cglcuentas record;
    ldc_work decimal(10,2);
    ldc_work2 decimal(10,2);
begin
    
    select into r_cglcomprobante1 * from cglcomprobante1
    where compania = as_compania
    and aplicacion = as_aplicacion
    and year = ai_year
    and periodo = ai_periodo
    and secuencia = ai_secuencia;
    if not found then
       return 0;
    end if;

    select into r_cglcomprobante2 * from cglcomprobante1
    where compania = as_compania
    and aplicacion = as_aplicacion
    and year = ai_year
    and periodo = ai_periodo
    and secuencia = ai_secuencia;
    if not found then
       Raise Exception ''Comprobante % No Tiene Detalle...Verifique '',ai_secuencia;
       return 0;
    else
        select into ldc_work sum(debito-credito) from cglcomprobante2
        where compania = as_compania
        and aplicacion = as_aplicacion
        and year = ai_year
        and periodo = ai_periodo
        and secuencia = ai_secuencia
        and debito = 0 and credito = 0;
        if ldc_work = 0 then
           Raise Exception ''Comprobante % esta en cero ...Verifique'',ai_secuencia;
           Return 0;
        end if;
    end if;
    
    
    select into ldc_work sum(debito-credito) from cglcomprobante2
    where compania = as_compania
    and aplicacion = as_aplicacion
    and year = ai_year
    and periodo = ai_periodo
    and secuencia = ai_secuencia;
    if ldc_work is null or ldc_work <> 0 then
--       Raise Exception ''Comprobante % esta en desbalance...Verifique %'',ai_secuencia, ldc_work;
       Return 0;
    end if;
    
    delete from rela_cglcomprobante1_cglposteo
    where compania = as_compania
    and aplicacion = as_aplicacion
    and year = ai_year
    and periodo = ai_periodo
    and secuencia = ai_secuencia;
    
    for r_cglcomprobante2 in select * from cglcomprobante2
                                where compania = as_compania
                                and aplicacion = as_aplicacion
                                and year = ai_year
                                and periodo = ai_periodo
                                and secuencia = ai_secuencia
                                and (debito <> 0 or credito <> 0)
                                order by cuenta
    loop
        select into r_cglcuentas * from cglcuentas
        where cuenta = r_cglcomprobante2.cuenta
        and auxiliar_1 = ''S'';
        if found then
           select into ldc_work sum(debito-credito) from cglcomprobante3
            where compania = as_compania
            and aplicacion = as_aplicacion
            and year = ai_year
            and periodo = ai_periodo
            and secuencia = ai_secuencia
            and linea = r_cglcomprobante2.linea;
            if ldc_work is null then
               Raise Exception ''Comprobante % esta en desbalance.  Verifica cuenta %  %'',ai_secuencia, r_cglcomprobante2.cuenta,ldc_work;
            end if;
            
            ldc_work := ldc_work - (r_cglcomprobante2.debito-r_cglcomprobante2.credito);
            if ldc_work <> 0 then
               Raise Exception ''Comprobante % esta en desbalance.  Verifica cuenta %  '',ai_secuencia, r_cglcomprobante2.cuenta;
            end if;
            
        end if;
    end loop;
    
    
    for r_cglcomprobante2 in select * from cglcomprobante2
                                where compania = as_compania
                                and aplicacion = as_aplicacion
                                and year = ai_year
                                and periodo = ai_periodo
                                and secuencia = ai_secuencia
                                and (debito <> 0 or credito <> 0)
                                order by cuenta
    loop
        select into r_cglcuentas * from cglcuentas
        where cuenta = r_cglcomprobante2.cuenta
        and auxiliar_1 = ''S'';
        if found then
           for r_cglcomprobante3 in select * from cglcomprobante3
                                    where compania = as_compania
                                    and aplicacion = as_aplicacion
                                    and year = ai_year
                                    and periodo = ai_periodo
                                    and secuencia = ai_secuencia
                                    and linea = r_cglcomprobante2.linea
           loop
           
               li_consecutivo := f_cglposteo(as_compania, as_aplicacion, r_cglcomprobante1.fecha_comprobante,
                                    r_cglcomprobante2.cuenta, r_cglcomprobante3.auxiliar, null,
                                    r_cglcomprobante1.tipo_comp, r_cglcomprobante2.descripcion,
                                    (r_cglcomprobante3.debito-r_cglcomprobante3.credito));
                if li_consecutivo > 0 then
                    insert into rela_cglcomprobante1_cglposteo (compania, aplicacion, year, periodo, secuencia, consecutivo)
                    values (as_compania, as_aplicacion, ai_year, ai_periodo, ai_secuencia, li_consecutivo);
                end if;
                
           end loop;
        else
        
           li_consecutivo := f_cglposteo(as_compania, as_aplicacion, r_cglcomprobante1.fecha_comprobante,
                                r_cglcomprobante2.cuenta, null, null,
                                r_cglcomprobante1.tipo_comp, r_cglcomprobante2.descripcion,
                                (r_cglcomprobante2.debito-r_cglcomprobante2.credito));
            if li_consecutivo > 0 then
                insert into rela_cglcomprobante1_cglposteo (compania, aplicacion, year, periodo, secuencia, consecutivo)
                values (as_compania, as_aplicacion, ai_year, ai_periodo, ai_secuencia, li_consecutivo);
            end if;
            
        end if;
    end loop;
    
    return 1;
end;
' language plpgsql;
