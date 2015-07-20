
drop function f_factura1_cglposteo(char(2), char(3), int4, char(3)) cascade;

create function f_factura1_cglposteo(char(2), char(3), int4, char(3)) returns integer as '
declare
    as_almacen alias for $1;
    as_tipo alias for $2;
    ai_num_documento alias for $3;
    as_caja alias for $4;
    li_consecutivo int4;
    r_almacen record;
    r_factura1 record;
    r_factura2 record;
    r_factura4 record;
    r_gral_forma_de_pago record;
    r_clientes record;
    r_work record;
    r_factmotivos record;
    r_cglcuentas record;
    r_articulos_por_almacen record;
    r_articulos record;
    r_articulos_agrupados record;
    r_cglauxiliares record;
    r_clientes_exentos record;
    ldc_sum_factura1 decimal(10,2);
    ldc_sum_factura2 decimal(10,2);
    ldc_sum_factura3 decimal(12,4);
    ldc_sum_factura4 decimal(10,2);
    ldc_sum_inv_en_proceso decimal(10,2);
    ldc_monto_factura decimal(10,2);
    ldc_monto_factura2 decimal(10,2);
    ldc_work decimal(10,2);
    ldc_desbalance decimal(10,2);
    ls_cuenta char(24);
    ls_cuenta_costo char(24);
    ls_aux1 char(10);
    ls_rubro_subtotal char(60);
    ls_observacion text;
    ls_cta_cxp_da char(24);
begin

    delete from rela_factura1_cglposteo
    where almacen = as_almacen
    and tipo = as_tipo
    and num_documento = ai_num_documento
    and caja = as_caja;

    select into r_factura1 * from factura1
    where almacen = as_almacen
    and tipo = as_tipo
    and caja = as_caja
    and num_documento = ai_num_documento;
    if not found then
       return 0;
    end if;

    
    select into r_clientes * from clientes
    where cliente = r_factura1.cliente;
        
    if r_factura1.status = ''A'' then
       return 0;
    end if;
    
    select into r_factmotivos * from factmotivos
    where tipo = r_factura1.tipo;
    if r_factmotivos.cotizacion = ''S'' or r_factmotivos.donacion = ''S'' or r_factmotivos.promocion = ''S'' then
       return 0;
    end if;
    
    ldc_monto_factura = f_monto_factura_new(as_almacen, as_tipo, ai_num_documento, as_caja);
    if ldc_monto_factura = 0 or ldc_monto_factura is null then
        return 0;
/*    
       Raise Exception ''Monto de Factura % no puede ser cero...Verifique'',ai_num_documento;
*/       
    end if;
    
    select into ldc_sum_factura2 sum((cantidad*precio)-descuento_linea-descuento_global) 
    from factura2
    where almacen = as_almacen
    and tipo = as_tipo
    and caja = as_caja
    and num_documento = ai_num_documento;
    if ldc_sum_factura2 is null then
       ldc_sum_factura2 := 0;
    end if;
    ldc_sum_factura2 = ldc_sum_factura2 * r_factmotivos.signo;
    
    select into ldc_sum_factura3 sum(monto) 
    from factura3
    where almacen = as_almacen
    and tipo = as_tipo
    and caja = as_caja
    and num_documento = ai_num_documento;
    if ldc_sum_factura3 is null then
       ldc_sum_factura3 := 0;
    end if;
    ldc_sum_factura3 = ldc_sum_factura3 * r_factmotivos.signo;


    ldc_monto_factura = (ldc_sum_factura2 + ldc_sum_factura3) * r_factmotivos.signo;
/*    
    if ldc_monto_factura < 0 then
        ldc_monto_factura2 := -ldc_monto_factura;
    else
        ldc_monto_factura2 := ldc_monto_factura;
    end if;    
*/    

    ldc_desbalance := ldc_monto_factura2 - ldc_sum_factura2 - ldc_sum_factura3;
    if ldc_desbalance <> 0 then
       raise exception ''Factura % esta desbalanceada...Verifique %  Total % Factura2 % Impuesto %'',
        ai_num_documento, ldc_desbalance, ldc_monto_factura2, ldc_sum_factura2, ldc_sum_factura3;
    end if;
    
    
    select into r_almacen * from almacen
    where almacen = r_factura1.almacen;
    
    r_factura1.observacion = ''CLIENTE: '' || trim(r_factura1.cliente) || ''  FACTURA # '' || ai_num_documento;

    r_factura1.observacion = ''CLIENTE: '' || trim(r_factura1.nombre_cliente) || ''  '' || trim(r_factura1.cliente) || ''   '' || trim(r_factmotivos.descripcion) ||  '' # ''  || ai_num_documento;
    
    if r_factura1.mbl is not null then
       r_factura1.observacion := trim(r_factura1.observacion) || ''  '' || trim(r_factura1.mbl);
    end if;
    
    if r_factura1.hbl is not null then
       r_factura1.observacion := trim(r_factura1.observacion) || ''  '' || trim(r_factura1.hbl);
    end if;
    
    ls_cta_cxp_da   = Trim(f_gralparaxcia(r_almacen.compania, ''FAC'', ''cta_cxp_da''));
    
    ldc_sum_factura2 := 0;
    for r_work in select factura2.almacen, factura2.articulo, -sum(((cantidad*precio)-descuento_linea-descuento_global)*factmotivos.signo) as monto
                        from factura2, factmotivos
                        where factura2.tipo = factmotivos.tipo
                        and factura2.almacen = r_factura1.almacen
                        and factura2.tipo = r_factura1.tipo
                        and factura2.caja = as_caja
                        and factura2.num_documento = r_factura1.num_documento
                        group by 1, 2
                        order by 1, 2
    loop
        ls_aux1 := null;
        select into r_articulos * from articulos
        where articulo = r_work.articulo and servicio = ''S'';
        if found then
            select into r_articulos_por_almacen * from articulos_por_almacen
            where almacen = r_work.almacen
            and articulo = r_work.articulo;
            ls_cuenta = r_articulos_por_almacen.cuenta;
            if Trim(r_factura1.tipo) = ''DA'' then
                ls_cuenta   = f_gralparaxcia(r_almacen.compania, ''FAC'', ''cta_gto_da'');
                ls_aux1     = r_factura1.cliente;
            end if;
            
            select into r_cglcuentas * from cglcuentas
            where cuenta = ls_cuenta and auxiliar_1 = ''S'';
            if found then
                if r_factura1.referencia = ''1'' or r_factura1.referencia = ''2'' or r_factura1.referencia = ''7'' then
                    ls_aux1 := r_factura1.ciudad_origen;
                else
                    ls_aux1 := r_factura1.ciudad_destino;
                end if;
                
                ls_aux1 := r_factura1.agente;
                
                if ls_aux1 is null then
                    select into r_cglauxiliares * from cglauxiliares
                    where trim(auxiliar) = trim(r_factura1.cliente);
                    if not found then
                        insert into cglauxiliares (auxiliar, nombre, tipo_persona, status)
                        values (r_factura1.cliente, r_clientes.nomb_cliente, ''1'', ''A'');
                    end if;
                    ls_aux1 = r_factura1.cliente;
                end if;
            end if;
        else
            if Trim(r_factura1.tipo) = ''DA'' then
                ls_cuenta   = f_gralparaxcia(r_almacen.compania, ''FAC'', ''cta_gto_da'');
                ls_aux1     = r_factura1.cliente;
                
                select into r_cglauxiliares * from cglauxiliares
                where trim(auxiliar) = trim(ls_aux1);
                if not found then
                    insert into cglauxiliares (auxiliar, nombre, tipo_persona, status)
                    values (trim(r_factura1.cliente), trim(r_clientes.nomb_cliente), ''1'', ''A'');
                end if;
            else
                if r_factmotivos.devolucion = ''S'' then
                    select into ls_cuenta facparamcgl.cuenta_devolucion
                    from articulos_agrupados, facparamcgl
                    where r_work.articulo = articulos_agrupados.articulo
                    and facparamcgl.almacen = r_work.almacen
                    and facparamcgl.codigo_valor_grupo = articulos_agrupados.codigo_valor_grupo;
                    if ls_cuenta is null or not found then
                        select into r_articulos_agrupados * from articulos_agrupados
                        where codigo_valor_grupo = ''NO''
                        and articulo = r_work.articulo;
                        if found then
                            select into ls_cuenta fac_parametros_contables.vtas_exentas
                            from fac_parametros_contables, articulos_agrupados
                            where articulos_agrupados.codigo_valor_grupo = fac_parametros_contables.codigo_valor_grupo
                            and articulos_agrupados.articulo = r_work.articulo
                            and fac_parametros_contables.almacen = r_work.almacen
                            and fac_parametros_contables.referencia = r_factura1.referencia;
                            if ls_cuenta is null or not found then
                                Raise Exception ''En la Factura # % El articulo % no tiene definido cuenta de ventas excentas...Verifique'',r_factura1.num_documento, r_work.articulo;
                            end if;
                        else
                            select into ls_cuenta fac_parametros_contables.cta_de_ingreso
                            from fac_parametros_contables, articulos_agrupados
                            where articulos_agrupados.codigo_valor_grupo = fac_parametros_contables.codigo_valor_grupo
                            and articulos_agrupados.articulo = r_work.articulo
                            and fac_parametros_contables.almacen = r_work.almacen
                            and fac_parametros_contables.referencia = r_factura1.referencia;
                            if ls_cuenta is null or not found then
                                Raise Exception ''En la Factura # % El articulo % no tiene definido cuenta de ingreso...Verifique'',r_factura1.num_documento, r_work.articulo;
                            end if;
                        end if;
                    end if;                
                else
                    select into ls_cuenta facparamcgl.cuenta_ingreso
                    from articulos_agrupados, facparamcgl
                    where r_work.articulo = articulos_agrupados.articulo
                    and facparamcgl.almacen = r_work.almacen
                    and facparamcgl.codigo_valor_grupo = articulos_agrupados.codigo_valor_grupo;
                    if ls_cuenta is null or not found then
                        select into r_articulos_agrupados * from articulos_agrupados
                        where codigo_valor_grupo = ''NO''
                        and articulo = r_work.articulo;
                        if found then
                            select into ls_cuenta fac_parametros_contables.vtas_exentas
                            from fac_parametros_contables, articulos_agrupados
                            where articulos_agrupados.codigo_valor_grupo = fac_parametros_contables.codigo_valor_grupo
                            and articulos_agrupados.articulo = r_work.articulo
                            and fac_parametros_contables.almacen = r_work.almacen
                            and fac_parametros_contables.referencia = r_factura1.referencia;
                            if ls_cuenta is null or not found then
                                Raise Exception ''En la Factura # % El articulo % no tiene definido cuenta de ventas excentas...Verifique'',r_factura1.num_documento, r_work.articulo;
                            end if;
                        else
                            select into ls_cuenta fac_parametros_contables.cta_de_ingreso
                            from fac_parametros_contables, articulos_agrupados
                            where articulos_agrupados.codigo_valor_grupo = fac_parametros_contables.codigo_valor_grupo
                            and articulos_agrupados.articulo = r_work.articulo
                            and fac_parametros_contables.almacen = r_work.almacen
                            and fac_parametros_contables.referencia = r_factura1.referencia;
                            if ls_cuenta is null or not found then
                                Raise Exception ''En la Factura # % El articulo % no tiene definido cuenta de ingreso...Verifique'',r_factura1.num_documento, r_work.articulo;
                            end if;
                        end if;
                    end if;
                end if;
            end if;
        end if;
        
        select into r_clientes_exentos * from clientes_exentos
        where cliente = r_factura1.cliente;
        if found and Trim(r_factura1.tipo) <> ''DA''then
            select into ls_cuenta fac_parametros_contables.vtas_exentas
            from fac_parametros_contables, articulos_agrupados
            where articulos_agrupados.codigo_valor_grupo = fac_parametros_contables.codigo_valor_grupo
            and articulos_agrupados.articulo = r_work.articulo
            and fac_parametros_contables.almacen = r_work.almacen
            and fac_parametros_contables.referencia = r_factura1.referencia;
            if ls_cuenta is null or not found then
                select into ls_cuenta facparamcgl.cta_vta_exenta
                from facparamcgl, articulos_agrupados
                where articulos_agrupados.codigo_valor_grupo = facparamcgl.codigo_valor_grupo
                and articulos_agrupados.articulo = r_work.articulo
                and facparamcgl.almacen = r_work.almacen
                and facparamcgl.codigo_valor_grupo = articulos_agrupados.codigo_valor_grupo;
                if ls_cuenta is null or not found then
                    ls_cuenta := r_clientes_exentos.cuenta;
                end if;
            end if;
        end if;

        if ls_cuenta is null then
            Raise Exception ''En la Factura # % El articulo % no tiene definido cuenta de ingreso...Verifique'',r_factura1.num_documento, r_work.articulo;
        end if;

        
        li_consecutivo := f_cglposteo(r_almacen.compania, ''FAC'', r_factura1.fecha_factura, 
                                Trim(ls_cuenta), ls_aux1, null, r_factmotivos.tipo_comp, 
                                trim(r_factura1.observacion), Round(r_work.monto,2));
        if li_consecutivo > 0 then
            insert into rela_factura1_cglposteo (almacen, tipo, num_documento, consecutivo, caja)
            values (r_factura1.almacen, r_factura1.tipo, r_factura1.num_documento, li_consecutivo, as_caja);
        end if;
        ldc_sum_factura2 := ldc_sum_factura2 + Round(r_work.monto,2);
    end loop;
    
    if Trim(f_gralparaxcia(r_almacen.compania, ''INV'', ''inv_en_proceso'')) = ''S'' then
        ldc_sum_inv_en_proceso = 0;
        for r_work in select tal_ot1.cliente, eys2.almacen, eys2.articulo, sum(factmotivos.signo*eys2.costo) as costo
                            from tal_ot1, tal_ot2, articulos, tal_ot2_eys2, eys2, factmotivos
                            where factmotivos.tipo = tal_ot1.tipo_factura
                            and tal_ot1.almacen = as_almacen
                            and tal_ot1.tipo_factura = as_tipo
                            and tal_ot1.numero_factura = ai_num_documento
                            and tal_ot1.caja = as_caja
                            and tal_ot1.almacen = tal_ot2.almacen
                            and tal_ot1.tipo = tal_ot2.tipo
                            and tal_ot1.no_orden = tal_ot2.no_orden
                            and tal_ot2.articulo = articulos.articulo
                            and articulos.servicio = ''N''
                            and tal_ot2.no_orden = tal_ot2_eys2.no_orden
                            and tal_ot2.tipo = tal_ot2_eys2.tipo
                            and tal_ot2.almacen = tal_ot2_eys2.almacen
                            and tal_ot2.linea = tal_ot2_eys2.linea_tal_ot2
                            and tal_ot2.articulo = tal_ot2_eys2.articulo
                            and eys2.articulo = tal_ot2_eys2.articulo
                            and eys2.almacen = tal_ot2_eys2.almacen
                            and eys2.no_transaccion = tal_ot2_eys2.no_transaccion
                            and eys2.linea = tal_ot2_eys2.linea_eys2
                            and tal_ot2.fecha_despacho >= ''2006-01-01''
                            group by 1, 2, 3
                            order by 1, 2, 3
        loop
            select into ls_cuenta_costo fac_parametros_contables.cta_de_costo
            from articulos_agrupados, fac_parametros_contables
            where articulos_agrupados.codigo_valor_grupo = fac_parametros_contables.codigo_valor_grupo
            and articulos_agrupados.articulo = r_work.articulo
            and fac_parametros_contables.almacen = r_work.almacen
            and fac_parametros_contables.referencia = r_factura1.referencia;
            if Not Found or ls_cuenta_costo is null then
                raise exception ''No existe cuenta de costo para el articulo % en la factura %'', r_work.articulo, ai_num_documento;
            end if;                
    
            li_consecutivo := f_cglposteo(r_almacen.compania, ''FAC'', r_factura1.fecha_factura, 
                                    Trim(ls_cuenta_costo), null, null, r_factmotivos.tipo_comp, 
                                    trim(r_factura1.observacion), Round(r_work.costo,2));
            if li_consecutivo > 0 then
                insert into rela_factura1_cglposteo (almacen, tipo, num_documento, consecutivo, caja)
                values (as_almacen, as_tipo, ai_num_documento, li_consecutivo, as_caja);
            end if;
            ldc_sum_inv_en_proceso = ldc_sum_inv_en_proceso + Round(r_work.costo,2);
        end loop;
    
        if ldc_sum_inv_en_proceso <> 0 then
            ls_cuenta_costo = f_gralparaxcia(r_almacen.compania, ''INV'', ''cta_inv_en_proceso'');
            li_consecutivo := f_cglposteo(r_almacen.compania, ''FAC'', r_factura1.fecha_factura, 
                                    Trim(ls_cuenta_costo), null, null, r_factmotivos.tipo_comp, 
                                    trim(r_factura1.observacion), -ldc_sum_inv_en_proceso);
            if li_consecutivo > 0 then
                insert into rela_factura1_cglposteo (almacen, tipo, num_documento, consecutivo, caja)
                values (as_almacen, as_tipo, ai_num_documento, li_consecutivo, as_caja);
            end if;
        end if;        
    end if;
    
    ls_rubro_subtotal = f_gralparaxcia(r_almacen.compania, ''FAC'', ''rubro_subtotal'');
    select into ldc_sum_factura4 sum(monto*rubros_fact_cxc.signo_rubro_fact_cxc) 
    from factura4, rubros_fact_cxc
    where almacen = as_almacen
    and tipo = as_tipo
    and caja = as_caja
    and num_documento = ai_num_documento
    and trim(factura4.rubro_fact_cxc) = trim(rubros_fact_cxc.rubro_fact_cxc)
    and trim(factura4.rubro_fact_cxc) <> ''ITBMS'';
    if found then
        ldc_work := (r_factmotivos.signo*ldc_sum_factura4) - ldc_sum_factura2;
        if ldc_work <> 0 then
            ls_observacion := ''FACTURA # '' || ai_num_documento || '' AJUSTE POR REDONDEO '';
    
            if ls_cuenta is null then
                Raise Exception ''En la Factura # % no tiene cuenta de ajuste...Verifique'',r_factura1.num_documento;
            end if;
--            li_consecutivo := f_cglposteo(r_almacen.compania, ''FAC'', r_factura1.fecha_factura, 
--                                    Trim(ls_cuenta), ls_aux1, null, r_factmotivos.tipo_comp, 
--                                    trim(ls_observacion), (ldc_work*r_factmotivos.signo));
--            if li_consecutivo > 0 then
--                insert into rela_factura1_cglposteo (almacen, tipo, num_documento, consecutivo)
--                values (r_factura1.almacen, r_factura1.tipo, r_factura1.num_documento, li_consecutivo);
--            end if;
        end if;
    end if;
    
    ldc_sum_factura3 = 0;    
    for r_work in select gral_impuestos.cuenta, -sum(monto*factmotivos.signo) as monto
                    from factura3, gral_impuestos, factmotivos
                    where factura3.impuesto = gral_impuestos.impuesto
                    and factura3.almacen = r_factura1.almacen
                    and factura3.caja = as_caja
                    and factura3.tipo = r_factura1.tipo
                    and factura3.num_documento = r_factura1.num_documento
                    and factura3.tipo = factmotivos.tipo
                    group by 1
                    having sum(monto*factmotivos.signo) <> 0
                    order by 1
    loop
        if r_work.cuenta is null then
            Raise Exception ''En la Factura # % no tiene cuenta de impuestos...Verifique'',r_factura1.num_documento;
        end if;
        
        li_consecutivo = f_cglposteo(r_almacen.compania, ''FAC'', r_factura1.fecha_factura, 
                                Trim(r_work.cuenta), null, null, r_factmotivos.tipo_comp, 
                                trim(r_factura1.observacion), r_work.monto);
        if li_consecutivo > 0 then
            insert into rela_factura1_cglposteo (almacen, tipo, num_documento, consecutivo, caja)
            values (r_factura1.almacen, r_factura1.tipo, r_factura1.num_documento, li_consecutivo, as_caja);
        end if;
        ldc_sum_factura3 := ldc_sum_factura3 + r_work.monto;
    end loop;

    
    select into r_factura4 * from factura4
    where almacen = as_almacen
    and tipo = as_tipo
    and caja = as_caja
    and num_documento = ai_num_documento
    and monto <> 0
    and trim(rubro_fact_cxc) = ''ITBMS'';
    if found then
        ldc_work = (r_factura4.monto*r_factmotivos.signo) + ldc_sum_factura3;
        if ldc_work <> 0 then
            if r_work.cuenta is null then
                Raise Exception ''En la Factura # % no tiene cuenta de impuestos...Verifique'',r_factura1.num_documento;
            end if;
        
            ls_observacion := ''FACTURA # '' || ai_num_documento || '' AJUSTE POR REDONDEO '';
    
            li_consecutivo := f_cglposteo(r_almacen.compania, ''FAC'', r_factura1.fecha_factura, 
                                    Trim(r_work.cuenta), ls_aux1, null, r_factmotivos.tipo_comp, 
                                    trim(ls_observacion), (ldc_work));
            if li_consecutivo > 0 then
                insert into rela_factura1_cglposteo (almacen, tipo, num_documento, consecutivo, caja)
                values (r_factura1.almacen, r_factura1.tipo, r_factura1.num_documento, li_consecutivo, as_caja);
            end if;
        end if;
    end if;        
    
    ldc_monto_factura := -(ldc_sum_factura2 + ldc_sum_factura3);
    
    select into r_clientes * from clientes
    where cliente = r_factura1.cliente;
    
    select into r_gral_forma_de_pago * from gral_forma_de_pago
    where forma_pago = r_factura1.forma_pago;
    
    if r_gral_forma_de_pago.dias > 0 then
/*
       select into ls_cuenta trim(valor) from invparal
       where almacen = r_factura1.almacen
       and parametro = ''cta_cxc''
       and aplicacion =  ''INV'';
       if not found then
          ls_cuenta := r_clientes.cuenta;
       end if;
*/

       ls_cuenta := r_clientes.cuenta;

        if Trim(r_factura1.tipo) = ''DA''then
/*        
           select into ls_cuenta trim(valor) from invparal
           where almacen = r_factura1.almacen
           and trim(parametro) = ''cta_cxp_comisiones''
           and aplicacion =  ''INV'';
           if not found then
                ls_cuenta = trim(ls_cta_cxp_da);
           else
              ls_cuenta = Trim(r_clientes.cuenta);
           end if;
*/           
           ls_cuenta    =   Trim(f_invparal(r_factura1.almacen, ''cta_cxp_comisiones''));
        end if;
    else
       select into ls_cuenta trim(valor) from invparal
       where almacen = r_factura1.almacen
       and parametro = ''cta_caja''
       and aplicacion =  ''INV'';
       if not found then
          Raise Exception ''Parametro cta_caja no existe en el almacen % ...Verifique'',r_factura1.almacen;
       end if;
    end if;
    
    
    ls_aux1 :=  null;
    select into r_cglcuentas * from cglcuentas
    where trim(cuenta) = trim(ls_cuenta)
    and auxiliar_1 = ''S'';
    if found then
        ls_aux1 :=   r_factura1.cliente;
        select into r_cglauxiliares * from cglauxiliares
        where trim(auxiliar) = trim(ls_aux1);
        if not found then
            insert into cglauxiliares (auxiliar, nombre, tipo_persona, status)
            values (r_factura1.cliente, r_clientes.nomb_cliente, ''1'', ''A'');
        end if;
    end if;

    li_consecutivo := f_cglposteo(r_almacen.compania, ''FAC'', r_factura1.fecha_factura, 
                            ls_cuenta, ls_aux1, null, r_factmotivos.tipo_comp, 
                            trim(r_factura1.observacion), ldc_monto_factura);
    if li_consecutivo > 0 then
        insert into rela_factura1_cglposteo (almacen, tipo, num_documento, consecutivo, caja)
        values (r_factura1.almacen, r_factura1.tipo, r_factura1.num_documento, li_consecutivo, as_caja);
    end if;

    return 1;
end;
' language plpgsql;

