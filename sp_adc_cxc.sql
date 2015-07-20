drop function f_adc_cxc_1_cglposteo(char(2), int4, int4) cascade;

create function f_adc_cxc_1_cglposteo(char(2), int4, int4) returns integer as '
declare
    as_cia alias for $1;
    ai_consecutivo alias for $2;
    ai_secuencia alias for $3;
    li_consecutivo int4;
    r_almacen record;
    r_cxctrx1 record;
    r_cxctrx2 record;
    r_work record;
    r_clientes record;
    r_cxcmotivos record;
    r_cglauxiliares record;
    r_cglcuentas record;
    r_adc_cxc_1 record;
    r_adc_cxc_2 record;
    r_adc_manifiesto record;
    r_fact_referencias record;
    ldc_sum_cxctrx1 decimal(10,2);
    ldc_sum_adc_cxc_2 decimal(10,2);
    ldc_sum_cxctrx3 decimal(10,2);
    ls_cuenta char(24);
    ls_aux1 char(10);
    ls_cliente char(10);
begin

    select into r_adc_cxc_1 * from adc_cxc_1
    where compania = as_cia
    and consecutivo = ai_consecutivo
    and secuencia = ai_secuencia;
    if not found then
        return 0;
    end if;
    
    if r_adc_cxc_1.status = ''A'' then
        return 0;
    end if;
    
    select into r_adc_manifiesto * from adc_manifiesto
    where compania = as_cia
    and consecutivo = ai_consecutivo;
    
    
    select into r_fact_referencias * from fact_referencias
    where referencia = r_adc_manifiesto.referencia;

    delete from rela_adc_cxc_1_cglposteo
    where compania = as_cia
    and consecutivo = ai_consecutivo
    and secuencia = ai_secuencia;
    
    select into r_cxcmotivos * from cxcmotivos
    where motivo_cxc = r_adc_cxc_1.motivo_cxc;
    
    select into ldc_sum_adc_cxc_2 sum(monto) from adc_cxc_2
    where compania = as_cia
    and consecutivo = ai_consecutivo
    and secuencia = ai_secuencia;
    if ldc_sum_adc_cxc_2 is null then
       ldc_sum_adc_cxc_2 = 0;
    end if;
    ldc_sum_cxctrx3 = (r_cxcmotivos.signo*r_adc_cxc_1.monto) + ldc_sum_adc_cxc_2;
    if ldc_sum_cxctrx3 <> 0 then
       raise exception ''Transaccion % esta desbalanceada...Verifique'',ai_secuencia;
    end if;
    
    if r_fact_referencias.tipo = ''I'' then
        ls_cliente = r_adc_manifiesto.from_agent;
    else
        ls_cliente = r_adc_manifiesto.to_agent;
    end if;
    
    if r_adc_cxc_1.cliente is not null then
        ls_cliente = r_adc_cxc_1.cliente;
    end if;
    
    select into r_clientes * from clientes
    where cliente = ls_cliente;
    
    if r_adc_cxc_1.observacion is null then
       r_adc_cxc_1.observacion = ''TRANSACCION #  '' || ai_secuencia || '' DOCUMENTO # '' || Trim(r_adc_cxc_1.documento);
    else
       r_adc_cxc_1.observacion = ''TRANSACCION #  '' || ai_secuencia || ''  DOCUMENTO # '' || Trim(r_adc_cxc_1.documento) || ''  '' || trim(r_adc_cxc_1.observacion);
    end if;
    
    ls_cuenta := r_clientes.cuenta;
    
    select into r_cglcuentas * from cglcuentas
    where trim(cuenta) = trim(ls_cuenta) and auxiliar_1 = ''S'';
    if not found then
        ls_aux1 := null;
    else
        ls_aux1 := r_cxctrx1.cliente;
        select into r_cglauxiliares * from cglauxiliares
        where trim(auxiliar) = trim(ls_aux1);
        if not found then
            insert into cglauxiliares (auxiliar, nombre, tipo_persona, status)
            values (r_clientes.cliente, r_clientes.nomb_cliente, ''1'', ''A'');
        end if;
        
    end if;        
    
    li_consecutivo := f_cglposteo(as_cia, ''CXC'', r_adc_cxc_1.fecha,
                            ls_cuenta, ls_aux1, null,
                            r_cxcmotivos.tipo_comp, r_adc_cxc_1.observacion,
                            (r_adc_cxc_1.monto*r_cxcmotivos.signo));
    if li_consecutivo > 0 then
        insert into rela_adc_cxc_1_cglposteo (cgl_consecutivo, compania, consecutivo, secuencia)
        values (li_consecutivo, as_cia, ai_consecutivo, ai_secuencia);
    end if;
    
    for r_adc_cxc_2 in select * from adc_cxc_2
                    where compania = as_cia
                    and consecutivo = ai_consecutivo
                    and secuencia = ai_secuencia
                    order by cuenta
    loop
        li_consecutivo := f_cglposteo(as_cia, ''CXC'', r_adc_cxc_1.fecha,
                                r_adc_cxc_2.cuenta, r_adc_cxc_2.auxiliar, null,
                                r_cxcmotivos.tipo_comp, r_adc_cxc_1.observacion,
                                r_adc_cxc_2.monto);
        if li_consecutivo > 0 then
            insert into rela_adc_cxc_1_cglposteo (cgl_consecutivo, compania, consecutivo, secuencia)
            values (li_consecutivo, as_cia, ai_consecutivo, ai_secuencia);
        end if;
    end loop;
    
    return 1;
end;
' language plpgsql;