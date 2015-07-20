

drop function f_id(char(1), char(25), char(10)) cascade;
drop function f_get_nombre(char(10),char(20)) cascade;
drop function f_apc(char(10),char(20), date) cascade;
drop function f_apc(date) cascade;



create function f_apc(date) returns integer as '
declare
    ad_fecha alias for $1;
    r_clientes record;
begin
    delete from apc_refere;
    delete from apc_clientes;
-- raise exception ''entre'';

    for r_clientes in select * from clientes
                        where to_number(trim(f_apc(cliente, ''SALDO'', ad_fecha)), ''9999999.999'') > 0
                        and estado_cuenta = ''S''
                        order by cliente
    loop

    
        insert into apc_clientes(ident1, ident2, ident3, ident4, tipo_clie, apel_pater,
            apel_mater, primer_nom, segundo_no, sexo_clie, nom_legal, direc_clie,
            telef_casa, telef_fax1, telef_fax2, ingreso_me)
        values(f_id(r_clientes.tipo_de_persona, r_clientes.id, ''IDENT1''),
            f_id(r_clientes.tipo_de_persona, r_clientes.id, ''IDENT2''),
            f_id(r_clientes.tipo_de_persona, r_clientes.id, ''IDENT3''),
            f_id(r_clientes.tipo_de_persona, r_clientes.id, ''IDENT4''),        
            case when r_clientes.tipo_de_persona = ''2'' then ''2'' else ''1'' end,
            f_get_nombre(r_clientes.cliente, ''APELLIDO_PATERNO''),
            f_get_nombre(r_clientes.cliente, ''APELLITO_MATERNO''),
            f_get_nombre(r_clientes.cliente, ''PRIMER_NOMBRE''),
            f_get_nombre(r_clientes.cliente, ''SEGUNDO_NOMBRE''),
            ''1'', 
            substring(trim(f_get_nombre(r_clientes.cliente, ''NOMBRE_LEGAL'')) from 1 for 70),
            trim(r_clientes.direccion1), SubString(Trim(r_clientes.tel1_cliente) from 1 for 7), 
            Substring(Trim(r_clientes.fax_cliente) from 1 for 7), 
            Substring(Trim(r_clientes.tel2_cliente) from 1 for 7),0);


            insert into apc_refere(ident1, ident2, ident3, ident4,
                tipo_clie, cod_grupo_econ, tipo_asoc, ident_asoc, cuenta, user_id,
                tipo_forma_pago, tipo_relacion, fec_inicio_rel,
                monto_original, saldo_actual,
                num_pagos, importe_pago, fec_ultimo_pago,
                monto_ultimo_pago,  tipo_comporta, estatus_ref,
                num_dias_atraso, fec_corte, nom_fiador, ced_fiador)
            values(f_id(r_clientes.tipo_de_persona, r_clientes.id, ''IDENT1''),
                f_id(r_clientes.tipo_de_persona, r_clientes.id, ''IDENT2''),
                f_id(r_clientes.tipo_de_persona, r_clientes.id, ''IDENT3''),
                f_id(r_clientes.tipo_de_persona, r_clientes.id, ''IDENT4''),        
                case when r_clientes.tipo_de_persona = ''2'' then ''2'' else ''1'' end,
                ''E'', 
                ''07'', 
                ''080006'', 
                trim(r_clientes.cliente),
                ''DM08006'', 
                ''P30'', 
                ''LCR'', 
                trim(to_char(r_clientes.fecha_apertura, ''mm/dd/yyyy'')),
                r_clientes.limite_credito, 
                f_apc(r_clientes.cliente, ''SALDO'', ad_fecha),
                0,0, 
                f_apc(r_clientes.cliente, ''FECHA_ULTIMO_PAGO'', ad_fecha),
                f_apc(r_clientes.cliente, ''MONTO_ULTIMO_PAGO'', ad_fecha),''0'',1,
                f_apc(r_clientes.cliente, ''NUMERO_DIAS_ATRASO'', ad_fecha), 
                trim(to_char(ad_fecha,''mm/dd/yyyy'')),
                substring(trim(r_clientes.nomb_cliente) from 1 for 50), 
                Substring(Trim(r_clientes.id) from 1 for 21));
    end loop;
    return 1;
end;
' language plpgsql;


create function f_apc(char(10),char(20), date) returns char(100) as '
declare
    ac_cliente alias for $1;
    ac_retornar alias for $2;
    ad_fecha alias for $3;
    lc_retornar char(100);
    r_clientes record;
    r_cxcdocm record;
    li_work integer;
    ldc_saldo decimal(10,2);
    ldc_work decimal(10,2);
    ld_work date;
begin
--raise exception ''entre'';

    lc_retornar = null;
    
    select into r_clientes * from clientes
    where trim(cliente) = trim(ac_cliente);
    if not found then
        return trim(lc_retornar);
    end if;


    if trim(ac_retornar) = ''SALDO'' then
        ldc_saldo = 0;
        select sum(cxcdocm.monto*cxcmotivos.signo) into ldc_saldo
        from cxcdocm, cxcmotivos
        where cxcdocm.motivo_cxc = cxcmotivos.motivo_cxc
        and cxcdocm.fecha_posteo <= ad_fecha
        and cxcdocm.cliente = ac_cliente;
        if ldc_saldo is null or not found then
            return ''0'';
        else
            return Trim(to_char(ldc_saldo, ''9999999.99''));
        end if;

    elsif trim(ac_retornar) = ''FECHA_ULTIMO_PAGO'' then
        select into ld_work Max(fecha_posteo)
        from cxcdocm, cxcmotivos
        where cxcdocm.motivo_cxc = cxcmotivos.motivo_cxc
        and cxcmotivos.cobros = ''S''
        and cxcdocm.cliente = ac_cliente
        and cxcdocm.fecha_posteo <= ad_fecha;
        
        return trim(to_char(ld_work, ''mm/dd/yyyy''));

    elsif trim(ac_retornar) = ''MONTO_ULTIMO_PAGO'' then
        select into ld_work Max(fecha_posteo)
        from cxcdocm, cxcmotivos
        where cxcdocm.motivo_cxc = cxcmotivos.motivo_cxc
        and cxcmotivos.cobros = ''S''
        and cxcdocm.cliente = ac_cliente
        and cxcdocm.fecha_posteo <= ad_fecha;
        
        ldc_work = 0;
        select into ldc_work sum(cxcdocm.monto)
        from cxcdocm, cxcmotivos
        where cxcdocm.motivo_cxc = cxcmotivos.motivo_cxc
        and cxcmotivos.cobros = ''S''
        and cxcdocm.cliente = ac_cliente
        and fecha_posteo = ld_work;
        
        if ldc_work is null then
            ldc_work = 0;
        end if;
        
        if ldc_work = 0 then
            ldc_work = null;
        end if;
        
        return trim(to_char(ldc_work, ''99999999.99''));


    elsif trim(ac_retornar) = ''NUMERO_DIAS_ATRASO'' then
        for r_cxcdocm in select * from cxcdocm
                            where documento = docmto_aplicar
                            and motivo_cxc = motivo_ref
                            and fecha_posteo <= ad_fecha
                            and cliente = ac_cliente
                            and f_saldo_documento_cxc(almacen, caja, cliente, motivo_cxc, documento, ad_fecha) > 0
                            order by fecha_posteo
        loop
            ld_work =   r_cxcdocm.fecha_posteo + 30;
            li_work =   ad_fecha - ld_work;
            if li_work < 0 then
                li_work = 0;
            end if;
            return trim(to_char(li_work,''999999''));
        end loop;
    end if;
    
    return Trim(lc_retornar);
end;
' language plpgsql;




create function f_get_nombre(char(10),char(20)) returns char(100) as '
declare
    ac_cliente alias for $1;
    ac_retornar alias for $2;
    li_pos integer;
    li_largo integer;
    li_nombre integer;
    r_clientes record;
    lc_nombre char(100);
    lc_retornar  char(100);
    lc_nombre_1 char(100);
    lc_nombre_2 char(100);
    lc_nombre_3 char(100);
    lc_nombre_4 char(100);
begin
    lc_retornar = null;
    
    select into r_clientes * from clientes
    where trim(cliente) = trim(ac_cliente);
    if not found then
        return trim(lc_retornar);
    end if;
    
    
    if r_clientes.tipo_de_persona = ''2'' then
        if trim(ac_retornar) = ''NOMBRE_LEGAL'' then
            return trim(r_clientes.nomb_cliente);
        else
            return trim(lc_retornar);
        end if;    
    end if;
    
    lc_nombre   = trim(r_clientes.nomb_cliente);
    li_largo    = Length(lc_nombre);
    lc_nombre_1 = null;
    lc_nombre_2 = null;
    lc_nombre_3 = null;
    lc_nombre_4 = null;
    li_nombre   = 1;
    for i in 1..li_largo loop
        if substr(lc_nombre, i, 1) = '' '' then
            li_nombre = li_nombre + 1;
            continue;
        else
            if li_nombre = 1 then
                if lc_nombre_1 is null then
                    lc_nombre_1 = substr(lc_nombre, i, 1);
                else
                    lc_nombre_1 = lc_nombre_1 || substr(lc_nombre, i, 1);
                end if;
                
            elsif li_nombre = 2 then
                if lc_nombre_2 is null then
                    lc_nombre_2 = substr(lc_nombre, i, 1);
                else
                    lc_nombre_2 = lc_nombre_2 || substr(lc_nombre, i, 1);
                end if;
            
            elsif li_nombre = 3 then
                if lc_nombre_3 is null then
                    lc_nombre_3 = substr(lc_nombre, i, 1);
                else
                    lc_nombre_3 = lc_nombre_3 || substr(lc_nombre, i, 1);
                end if;

            elsif li_nombre = 4 then
                if lc_nombre_4 is null then
                    lc_nombre_4 = substr(lc_nombre, i, 1);
                else
                    lc_nombre_4 = lc_nombre_4 || substr(lc_nombre, i, 1);
                end if;
            end if;    
        end if;
    end loop;

    lc_retornar = null;
    if li_nombre = 1 then
        if trim(ac_retornar) = ''PRIMER_NOMBRE'' then
            return trim(lc_nombre_1);
        else
            return lc_retornar;
        end if;
        
    elsif li_nombre = 2 then
        if trim(ac_retornar) = ''PRIMER_NOMBRE'' then
            return lc_nombre_1;
        elsif trim(ac_retornar) = ''APELLIDO_PATERNO'' then
            return lc_nombre_2;
        else
            return lc_retornar;
        end if;
        
    elsif li_nombre = 3 then
        if trim(ac_retornar) = ''PRIMER_NOMBRE'' then
            return lc_nombre_1;
        elsif trim(ac_retornar) = ''APELLIDO_PATERNO'' then
            return lc_nombre_2;
        elsif trim(ac_retornar) = ''APELLIDO_MATERNO'' then
            return lc_nombre_3;
        else
            return lc_retornar;
        end if;
    
    elsif li_nombre = 4 then
        if trim(ac_retornar) = ''PRIMER_NOMBRE'' then
            return lc_nombre_1;
        elsif trim(ac_retornar) = ''SEGUNDO_NOMBRE'' then
            return lc_nombre_2;
        elsif trim(ac_retornar) = ''APELLIDO_PATERNO'' then
            return lc_nombre_3;
        elsif trim(ac_retornar) = ''APELLIDO_MATERNO'' then
            return lc_nombre_4;
        else
            return lc_retornar;
        end if;
    end if;
    
    return Trim(lc_retornar);
end;
' language plpgsql;


create function f_id(char(1), char(30), char(10)) returns char(20) as '
declare
    ac_tipo_de_persona alias for $1;
    ac_id alias for $2;
    ac_retornar alias for $3;
    lc_retornar  char(100);
    li_largo integer;
    i integer;
    j integer;
    li_guion integer;
    lc_id char(30);
    lc_work char(1);
begin
    lc_retornar = null;
    lc_id = substring(trim(ac_id) from 1 for 10);
    lc_id = trim(ac_id);
        
    if ac_tipo_de_persona = ''1'' then
        if trim(ac_retornar) = ''IDENT1'' then
            li_largo = Length(lc_id);
            i = 0;
            while i <= li_largo loop
                i = i + 1;
                lc_work = substring(lc_id from i for 1);
                if i = 1 then
                    lc_retornar = lc_work;
                else
                    if lc_work = ''-'' then
                        return Trim(lc_retornar);
                    else
                        lc_retornar = lc_retornar || lc_work;
                    end if;
                end if;
            end loop;
            
        elsif trim(ac_retornar) = ''IDENT2'' then
            return Trim(lc_retornar);
            
        elsif trim(ac_retornar) = ''IDENT4'' then
            li_largo = Length(lc_id);
            i = 0;
            li_guion = 0;
            while li_guion < 2 loop
                i = i + 1;
                lc_work = substring(lc_id from i for 1);
                if lc_work = ''-'' then
                    li_guion = li_guion + 1;
                end if;
                if i > 30 then
                    li_guion = 3;
                end if;
            end loop;
            i = i + 1;
            lc_retornar = lc_id;
            lc_retornar = Trim(substring(lc_id from i for 20));

        elsif trim(ac_retornar) = ''IDENT3'' then
            li_largo = Length(lc_id);
            i = 0;
            li_guion = 0;
            while i <= li_largo loop
                i = i + 1;
                lc_work = substring(lc_id from i for 1);
                if lc_work = ''-'' then
                    if li_guion < 1 then
                        li_guion = li_guion + 1;
                        continue;
                    end if;
                else
                    if li_guion < 1 then
                        continue;
                    end if;                    
                end if;
                
                if li_guion = 1 then
                    li_guion = 2;
                    lc_retornar = lc_work;
                else
                    if lc_work = ''-'' then
                        return lc_retornar;
                    else
                        lc_retornar = lc_retornar || lc_work;
                    end if;
                end if;
            end loop;
        end if;
        
    elsif ac_tipo_de_persona = ''2'' then
        if trim(ac_retornar) = ''IDENT1'' then
            li_largo = Length(lc_id);
            i = 0;
            while i <= li_largo loop
                i = i + 1;
                lc_work = substring(lc_id from i for 1);
                if i = 1 then
                    lc_retornar = lc_work;
                else
                    if lc_work = ''-'' then
                        return Trim(lc_retornar);
                    else
                        lc_retornar = lc_retornar || lc_work;
                    end if;
                end if;
            end loop;
            
        elsif trim(ac_retornar) = ''IDENT4'' then
            return Trim(lc_retornar);
            
        elsif trim(ac_retornar) = ''IDENT2'' then
            li_largo = Length(lc_id);
            i = 0;
            li_guion = 0;
            while i <= li_largo loop
                i = i + 1;
                lc_work = substring(lc_id from i for 1);
                if lc_work = ''-'' then
                    if li_guion < 1 then
                        li_guion = li_guion + 1;
                        continue;
                    end if;
                else
                    if li_guion < 1 then
                        continue;
                    end if;                    
                end if;
                
                if li_guion = 1 then
                    li_guion = 2;
                    lc_retornar = lc_work;
                else
                    if lc_work = ''-'' then
                        return lc_retornar;
                    else
                        lc_retornar = lc_retornar || lc_work;
                    end if;
                end if;
            end loop;
        
        
        elsif trim(ac_retornar) = ''IDENT3'' then
            li_largo = Length(lc_id);
            i = 0;
            li_guion = 0;
            while li_guion < 2 loop
                i = i + 1;
                lc_work = substring(lc_id from i for 1);
                if lc_work = ''-'' then
                    li_guion = li_guion + 1;
                end if;
                if i > 30 then
                    li_guion = 3;
                end if;
            end loop;
            i = i + 1;
            lc_retornar = lc_id;
            lc_retornar = Trim(substring(lc_id from i for 20));
        end if;
                    
    elsif ac_tipo_de_persona = ''3'' then
        if trim(ac_retornar) = ''IDENT2'' then
            li_largo = Length(lc_id);
            i = 0;
            while i <= li_largo loop
                i = i + 1;
                lc_work = substring(lc_id from i for 1);
                if i = 1 then
                    lc_retornar = lc_work;
                else
                    if lc_work = ''-'' then
                        return Trim(lc_retornar);
                    else
                        lc_retornar = lc_retornar || lc_work;
                    end if;
                end if;
            end loop;
            
        elsif trim(ac_retornar) = ''IDENT1'' then
            return Trim(lc_retornar);
            
        elsif trim(ac_retornar) = ''IDENT3'' then
            li_largo = Length(lc_id);
            i = 0;
            li_guion = 0;
            while i <= li_largo loop
                i = i + 1;
                lc_work = substring(lc_id from i for 1);
                if lc_work = ''-'' then
                    if li_guion < 2 then
                        li_guion = li_guion + 1;
                        continue;
                    end if;
                else
                    if li_guion < 2 then
                        continue;
                    end if;                    
                end if;
                
                j = li_largo - i + 1;  
                lc_retornar = substring(lc_id from i for j);
                return trim(lc_retornar);
            end loop;
             
        elsif trim(ac_retornar) = ''IDENT4'' then
            li_largo = Length(lc_id);
            i = 0;
            li_guion = 0;
            while i <= li_largo loop
                i = i + 1;
                lc_work = substring(lc_id from i for 1);
                if lc_work = ''-'' then
                    if li_guion < 1 then
                        li_guion = li_guion + 1;
                        continue;
                    end if;
                else
                    if li_guion < 1 then
                        continue;
                    end if;                    
                end if;
                
                if li_guion = 1 then
                    li_guion = 2;
                    lc_retornar = lc_work;
                else
                    if lc_work = ''-'' then
                        return lc_retornar;
                    else
                        lc_retornar = lc_retornar || lc_work;
                    end if;
                end if;
            end loop;
        end if;
            
    end if;
    return SubString(Trim(lc_retornar) from 1 for 10);
end;
' language plpgsql;
