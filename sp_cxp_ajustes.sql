
drop function f_cxpajuste1_cxpdocm(char(2), int4) cascade;
drop function f_cxpajuste1_cglposteo(char(2), int4) cascade;


create function f_cxpajuste1_cglposteo(char(2), int4) returns integer as '
declare
    as_compania alias for $1;
    ai_sec_ajuste_cxp alias for $2;
    li_consecutivo int4;
    r_cxpajuste1 record;
    r_cxpajuste2 record;
    r_work record;
    r_proveedores record;
    r_cxpmotivos record;
    r_cglcuentas record;
    r_cglauxiliares record;
    ldc_sum_cxpajuste2 decimal(10,2);
    ldc_sum_cxpajuste3 decimal(10,2);
    ls_aux1 char(10);
begin
    select into r_cxpajuste1 * from cxpajuste1
    where compania = as_compania
    and sec_ajuste_cxp = ai_sec_ajuste_cxp;
    if not found then
       return 0;
    end if;
    
    select into ldc_sum_cxpajuste2 sum(monto) from cxpajuste2
    where compania = as_compania
    and sec_ajuste_cxp = ai_sec_ajuste_cxp;
    if ldc_sum_cxpajuste2 is null then
       ldc_sum_cxpajuste2 := 0;
    end if;
    
    select into ldc_sum_cxpajuste3 sum(monto) from cxpajuste3
    where compania = as_compania
    and sec_ajuste_cxp = ai_sec_ajuste_cxp;
    if ldc_sum_cxpajuste3 is null then
       ldc_sum_cxpajuste3 := 0;
    end if;
    
    if ldc_sum_cxpajuste2 <> 0 and ldc_sum_cxpajuste2 <> ldc_sum_cxpajuste3 then
       raise exception ''Transaccion % esta desbalanceada...Verifique'',r_cxpajuste1.sec_ajuste_cxp;
    end if;
    
    delete from rela_cxpajuste1_cglposteo
    where compania = r_cxpajuste1.compania
    and sec_ajuste_cxp = r_cxpajuste1.sec_ajuste_cxp;
    
    select into r_cxpmotivos * from cxpmotivos
    where motivo_cxp = r_cxpajuste1.motivo_cxp;
    
    select into r_proveedores * from proveedores
    where proveedor = r_cxpajuste1.proveedor;
    
    if r_cxpajuste1.obs_ajuste_cxp is null then
       r_cxpajuste1.obs_ajuste_cxp := ''TRANSACCION #  '' || r_cxpajuste1.sec_ajuste_cxp;
    else
       r_cxpajuste1.obs_ajuste_cxp := ''TRANSACCION #  '' || r_cxpajuste1.sec_ajuste_cxp || ''  '' || trim(r_cxpajuste1.obs_ajuste_cxp);
    end if;
    
    ls_aux1 := null;
    select into r_cglcuentas * from cglcuentas
    where cuenta = r_proveedores.cuenta
    and auxiliar_1 = ''S'';
    if found then
        ls_aux1 :=   r_proveedores.proveedor;
        select into r_cglauxiliares * from cglauxiliares
        where trim(auxiliar) = trim(ls_aux1);
        if not found then
            insert into cglauxiliares (auxiliar, nombre, tipo_persona, status)
            values (ls_aux1, trim(r_proveedores.nomb_proveedor), ''1'', ''A'');
        end if;
    end if;
    

    li_consecutivo := f_cglposteo(r_cxpajuste1.compania, ''CXP'', r_cxpajuste1.fecha_posteo_ajuste_cxp, 
                            r_proveedores.cuenta, ls_aux1, null,
                            r_cxpmotivos.tipo_comp, r_cxpajuste1.obs_ajuste_cxp, 
                            (ldc_sum_cxpajuste3*r_cxpmotivos.signo));
    if li_consecutivo > 0 then
        insert into rela_cxpajuste1_cglposteo (compania, sec_ajuste_cxp, consecutivo)
        values (r_cxpajuste1.compania, r_cxpajuste1.sec_ajuste_cxp, li_consecutivo);
    end if;
    
    for r_work in select cxpajuste3.cuenta, cxpajuste3.auxiliar1, cxpajuste3.auxiliar2, cxpajuste3.monto
                    from cxpajuste3
                    where cxpajuste3.compania = r_cxpajuste1.compania
                    and cxpajuste3.sec_ajuste_cxp = r_cxpajuste1.sec_ajuste_cxp
                    order by 1
    loop
        li_consecutivo := f_cglposteo(r_cxpajuste1.compania, ''CXP'', r_cxpajuste1.fecha_posteo_ajuste_cxp, 
                                r_work.cuenta, r_work.auxiliar1, r_work.auxiliar2,
                                r_cxpmotivos.tipo_comp, r_cxpajuste1.obs_ajuste_cxp, 
                                -(r_work.monto*r_cxpmotivos.signo));
        if li_consecutivo > 0 then
            insert into rela_cxpajuste1_cglposteo (compania, sec_ajuste_cxp, consecutivo)
            values (r_cxpajuste1.compania, r_cxpajuste1.sec_ajuste_cxp, li_consecutivo);
        end if;
    end loop;
    return 1;
end;
' language plpgsql;




create function f_cxpajuste1_cxpdocm(char(2), int4) returns integer as '
declare
    as_compania alias for $1;
    ai_sec_ajuste_cxp alias for $2;
    r_cxpajuste1 record;
    r_cxpajuste3 record;
    r_cxpajuste2 record;
    r_cxpdocm record;
    r_cxpdocm2 record;
    ldc_monto decimal(10,2);
    li_work integer;
begin
    return 0;
    
    select into r_cxpajuste1 * from cxpajuste1
    where compania = as_compania
    and sec_ajuste_cxp = ai_sec_ajuste_cxp;
    
    
    select into li_work count(*) from cxpajuste2
    where compania = as_compania
    and sec_ajuste_cxp = ai_sec_ajuste_cxp
    and monto <> 0;
    
   
    if li_work is null or li_work = 0 then
       select into ldc_monto sum(monto) from cxpajuste3
       where compania = as_compania
       and   sec_ajuste_cxp = ai_sec_ajuste_cxp;
       
       select into r_cxpdocm * from cxpdocm
       where compania = r_cxpajuste1.compania
       and proveedor = r_cxpajuste1.proveedor
       and documento = r_cxpajuste1.docm_ajuste_cxp
       and docmto_aplicar = r_cxpajuste1.docm_ajuste_cxp
       and motivo_cxp = r_cxpajuste1.motivo_cxp;
       if not found then
           insert into cxpdocm (proveedor, compania, documento, docmto_aplicar,
            motivo_cxp, docmto_aplicar_ref, motivo_cxp_ref, aplicacion_origen,
            uso_interno, fecha_docmto, fecha_vmto, monto, fecha_posteo, status,
            usuario, fecha_captura, obs_docmto, fecha_cancelo, referencia)
           values (r_cxpajuste1.proveedor, r_cxpajuste1.compania, trim(r_cxpajuste1.docm_ajuste_cxp),
            trim(r_cxpajuste1.docm_ajuste_cxp), r_cxpajuste1.motivo_cxp, trim(r_cxpajuste1.docm_ajuste_cxp),
            r_cxpajuste1.motivo_cxp, ''CXP'', ''N'', r_cxpajuste1.fecha_posteo_ajuste_cxp,
            r_cxpajuste1.fecha_posteo_ajuste_cxp, ldc_monto, r_cxpajuste1.fecha_posteo_ajuste_cxp,
            ''R'', current_user, current_timestamp, trim(r_cxpajuste1.obs_ajuste_cxp),
            current_date, trim(r_cxpajuste1.referencia));
       else
          update cxpdocm
          set    fecha_docmto         = r_cxpajuste1.fecha_posteo_ajuste_cxp,
                 fecha_vmto           = r_cxpajuste1.fecha_posteo_ajuste_cxp,
                 monto                = ldc_monto,
                 fecha_posteo         = r_cxpajuste1.fecha_posteo_ajuste_cxp,
                 usuario              = current_user,
                 fecha_captura        = current_timestamp,
                 obs_docmto           = r_cxpajuste1.obs_ajuste_cxp
          where  compania             = r_cxpajuste1.compania
          and    proveedor            = r_cxpajuste1.proveedor
          and    documento            = r_cxpajuste1.docm_ajuste_cxp
          and    docmto_aplicar       = r_cxpajuste1.docm_ajuste_cxp
          and    motivo_cxp           = r_cxpajuste1.motivo_cxp;
       end if;
    else
       for r_cxpajuste2 in select cxpajuste2.* from cxpajuste2
                            where compania = as_compania
                            and sec_ajuste_cxp = ai_sec_ajuste_cxp
                            and monto <> 0
       loop
        select into r_cxpdocm * from cxpdocm
        where  proveedor            = r_cxpajuste1.proveedor
        and    compania             = r_cxpajuste1.compania
        and    documento            = r_cxpajuste1.docm_ajuste_cxp
        and    docmto_aplicar       = r_cxpajuste2.aplicar_a
        and    motivo_cxp           = r_cxpajuste1.motivo_cxp;
        if not found then
        
           select into r_cxpdocm2 * from cxpdocm
           where  proveedor            = r_cxpajuste1.proveedor
           and    compania             = r_cxpajuste1.compania
           and    documento            = r_cxpajuste2.aplicar_a
           and    docmto_aplicar       = r_cxpajuste2.aplicar_a
           and    motivo_cxp           = r_cxpajuste2.motivo_cxp;
           if found then
              insert into cxpdocm (proveedor, compania, documento, docmto_aplicar,
                motivo_cxp, docmto_aplicar_ref, motivo_cxp_ref, aplicacion_origen,
                uso_interno, fecha_docmto, fecha_vmto, monto, fecha_posteo, status,
                usuario, fecha_captura, obs_docmto, fecha_cancelo, referencia)
              values (r_cxpajuste1.proveedor, r_cxpajuste1.compania, trim(r_cxpajuste1.docm_ajuste_cxp),
                trim(r_cxpajuste2.aplicar_a), r_cxpajuste1.motivo_cxp, trim(r_cxpajuste2.aplicar_a),
                r_cxpajuste2.motivo_cxp, ''CXP'', ''N'', r_cxpajuste1.fecha_posteo_ajuste_cxp,
                r_cxpajuste1.fecha_posteo_ajuste_cxp, r_cxpajuste2.monto, r_cxpajuste1.fecha_posteo_ajuste_cxp,
                ''R'', current_user, current_timestamp, trim(r_cxpajuste1.obs_ajuste_cxp),
                current_date, trim(r_cxpajuste1.referencia));
           else
              return 0;
           end if;
           
        else
           update cxpdocm
           set    fecha_docmto         = r_cxpajuste1.fecha_posteo_ajuste_cxp,
                  fecha_vmto           = r_cxpajuste1.fecha_posteo_ajuste_cxp,
                  monto                = r_cxpajuste2.monto,
                  fecha_posteo         = r_cxpajuste1.fecha_posteo_ajuste_cxp,
                  usuario              = current_user,
                  fecha_captura        = current_timestamp,
                  obs_docmto           = r_cxpajuste1.obs_ajuste_cxp
           where  proveedor            = r_cxpajuste1.proveedor
           and    compania             = r_cxpajuste1.compania
           and    documento            = r_cxpajuste1.docm_ajuste_cxp
           and    docmto_aplicar       = r_cxpajuste2.aplicar_a
           and    motivo_cxp           = r_cxpajuste1.motivo_cxp;
        end if;
       end loop;
    end if;

    return 1;
end;
' language plpgsql;    

