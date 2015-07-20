drop function f_informacion_cliente(char(2),char(10)) cascade;


create function f_informacion_cliente(char(2),char(10))returns integer as '
declare
    as_cia alias for $1;
    as_cliente alias for $2;
    ldc_morosidad1 decimal;
    ldc_morosidad2 decimal;
    ldc_morosidad3 decimal;
    ldc_morosidad4 decimal;
    ldc_morosidad5 decimal;
    ldc_morosidad_total decimal;
    ldc_work decimal;
    li_mes1 integer;
    li_mes2 integer;
    li_mes3 integer;
    li_mes4 integer;
    li_mes5 integer;
    li_anio1 integer;
    li_anio2 integer;
    li_anio3 integer;
    li_anio4 integer;
    li_anio5 integer;
    ls_mes1 char(30);
    ls_mes2 char(30);
    ls_mes3 char(30);
    ls_mes4 char(30);
    ls_mes5 char(30);
    r_work record;
    r_cxcdocm record;
    r_clientes record;
    ls_mensaje char(80);
begin
    delete from gral_informe;
    
    
    select into r_clientes * from clientes
    where trim(cliente) = trim(as_cliente);
    if not found then
        Raise Exception ''Codigo de Cliente % No Existe'',as_cliente;
    end if;
    
    ls_mensaje      =   ''Cliente: '' || trim(r_clientes.nomb_cliente) || ''   ''  || trim(as_cliente);
    
    insert into gral_informe(usuario, mensaje)
    values(current_user,ls_mensaje);
    
    ldc_morosidad1 = 0;
    ldc_morosidad2 = 0;
    ldc_morosidad3 = 0;
    ldc_morosidad4 = 0;
    ldc_morosidad5 = 0;

    li_anio1 = Anio(current_date);
    li_mes1 = Mes(current_date);
    
    li_anio2 = li_anio1;
    li_mes2 = li_mes1 - 1;
    if li_mes2 = 0 then
        li_anio2 = li_anio2 - 1;
        li_mes2 = 12;
    end if;
    
    li_anio3 = li_anio2;
    li_mes3 = li_mes2 - 1;
    if li_mes3 = 0 then
        li_anio3 = li_anio3 - 1;
        li_mes3 = 12;
    end if;
    
    li_anio4 = li_anio3;
    li_mes4 = li_mes3 - 1;
    if li_mes4 = 0 then
        li_anio4 = li_anio4 - 1;
        li_mes4 = 12;
    end if;
    
    li_anio5 = li_anio4;
    li_mes5 = li_mes4 - 1;
    if li_mes5 = 0 then
        li_anio5 = li_anio5 - 1;
        li_mes5 = 12;
    end if;
    
    ldc_morosidad1 = 0;
    ldc_morosidad2 = 0;
    ldc_morosidad3 = 0;
    ldc_morosidad4 = 0;
    ldc_morosidad5 = 0;
    
    for r_work in select cxcdocm.almacen, cliente, 
                    docmto_aplicar, docmto_ref, motivo_ref, 
                    sum(cxcdocm.monto*cxcmotivos.signo) as saldo
                    from cxcdocm, cxcmotivos, almacen
                    where cxcdocm.almacen = almacen.almacen
                    and cxcdocm.motivo_cxc = cxcmotivos.motivo_cxc
                    and almacen.compania = as_cia
                    and cxcdocm.cliente = as_cliente
                    and cxcdocm.fecha_posteo <= current_date
                    group by 1, 2, 3, 4, 5
                    having sum(cxcdocm.monto*cxcmotivos.signo) <> 0
    loop
        select into r_cxcdocm * from cxcdocm
        where almacen = r_work.almacen
        and cliente = r_work.cliente
        and documento = r_work.docmto_aplicar
        and docmto_aplicar = r_work.docmto_aplicar
        and motivo_cxc = r_work.motivo_ref;
        if found then
            if Anio(r_cxcdocm.fecha_posteo) = li_anio1
                and Mes(r_cxcdocm.fecha_posteo) = li_mes1 then
               ldc_morosidad1 = ldc_morosidad1 + r_work.saldo;
            elsif Anio(r_cxcdocm.fecha_posteo) = li_anio2
                    and Mes(r_cxcdocm.fecha_posteo)= li_mes2 then
               ldc_morosidad2 = ldc_morosidad2 + r_work.saldo;
            elsif Anio(r_cxcdocm.fecha_posteo) = li_anio3
                    and Mes(r_cxcdocm.fecha_posteo)= li_mes3 then
               ldc_morosidad3 = ldc_morosidad3 + r_work.saldo;
            elsif Anio(r_cxcdocm.fecha_posteo) = li_anio4
                    and Mes(r_cxcdocm.fecha_posteo)= li_mes4 then
               ldc_morosidad4 = ldc_morosidad4 + r_work.saldo;
            else
               ldc_morosidad5 = ldc_morosidad5 + r_work.saldo;
            end if;            
        end if;
    end loop;
    
    ls_mes1 = f_mes(li_mes1) || ''-'' || li_anio1 || ''      '' || Trim(to_char(ldc_morosidad1,''9,999,999D99''));
    ls_mes2 = f_mes(li_mes2) || ''-'' || li_anio2 || ''      '' || Trim(to_char(ldc_morosidad2,''9,999,999D99''));
    ls_mes3 = f_mes(li_mes3) || ''-'' || li_anio3 || ''      '' || Trim(to_char(ldc_morosidad3,''9,999,999D99''));
    ls_mes4 = f_mes(li_mes4) || ''-'' || li_anio4 || ''      '' || Trim(to_char(ldc_morosidad4,''9,999,999D99''));
    ls_mes5 = f_mes(li_mes5) || ''-'' || li_anio5 || ''      '' || Trim(to_char(ldc_morosidad5,''9,999,999D99''));
    

    insert into gral_informe(usuario, mensaje)
    values(current_user,ls_mes1);
    
    insert into gral_informe(usuario, mensaje)
    values(current_user,ls_mes2);

    insert into gral_informe(usuario, mensaje)
    values(current_user,ls_mes3);
    
    insert into gral_informe(usuario, mensaje)
    values(current_user,ls_mes4);
    
    insert into gral_informe(usuario, mensaje)
    values(current_user,ls_mes5);
    
    ldc_morosidad_total =   ldc_morosidad1 + ldc_morosidad2 + ldc_morosidad3 + ldc_morosidad4 + ldc_morosidad5;
    
    ls_mensaje          =   ''Morosidad Total:    '' || Trim(to_char(ldc_morosidad_total, ''9,999,999D99''));
    insert into gral_informe(usuario, mensaje)
    values(current_user,ls_mensaje);

    ls_mensaje      =   ''Facturas Vencidas'';
    insert into gral_informe(usuario, mensaje)
    values(current_user,ls_mensaje);

    ls_mensaje      =   ''F.Factura        F.Vmto                Factura              Saldo'';
    insert into gral_informe(usuario, mensaje)
    values(current_user,ls_mensaje);

    ldc_work = 0;
    for r_work in select cxcdocm.almacen, cliente, 
                    docmto_aplicar, docmto_ref, motivo_ref, fecha_posteo, fecha_vmto,
                    sum(cxcdocm.monto*cxcmotivos.signo) as saldo
                    from cxcdocm, cxcmotivos, almacen
                    where cxcdocm.almacen = almacen.almacen
                    and cxcdocm.motivo_cxc = cxcmotivos.motivo_cxc
                    and almacen.compania = as_cia
                    and cxcdocm.cliente = as_cliente
                    and cxcdocm.fecha_vmto <= current_date
                    group by 1, 2, 3, 4, 5, 6, 7
                    having sum(cxcdocm.monto*cxcmotivos.signo) <> 0
                    order by 6, 3
    loop
        ls_mensaje  =   to_char(r_work.fecha_posteo,''DD Mon YYYY'') || ''   '' ||
                        to_char(r_work.fecha_vmto, ''DD Mon YYYY'') || ''       '' ||
                        r_work.docmto_aplicar || ''       '' ||
                        to_char(r_work.saldo,''9,999,999D99'');
        insert into gral_informe(usuario, mensaje)
        values(current_user,ls_mensaje);
        ldc_work = ldc_work + r_work.saldo;
    end loop;
    
    ls_mensaje  =   ''Total de Facturas Vencidas: '' || to_char(ldc_work,''9,999,999D99'');
    insert into gral_informe(usuario, mensaje)
    values(current_user,ls_mensaje);
    
    return 1;
end;
' language plpgsql;    


