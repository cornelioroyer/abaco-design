drop function f_sec_inventario(char(2));
create function f_sec_inventario(char(2)) returns integer as '
declare
    as_almacen alias for $1;
    as_tipo alias for $2;
    ai_num_documento alias for $3;
    r_factmotivos record;
    r_factura1 record;
    r_factura2 record;
    r_eys1 record;
    r_eys2 record;
    r_work1 record;
begin
    
    select into r_factura1 factura1.* from factura1, factmotivos
    where factura1.tipo = factmotivos.tipo
    and factura1.almacen = as_almacen
    and factura1.tipo = as_tipo
    and factura1.num_documento = ai_num_documento
    and (factmotivos.nota_credito = ''S'' or
    factmotivos.cotizacion = ''S'' or factura1.despachar = ''N'' or factura1.fecha_despacho is null);
    if found then
       return 0;
    end if;
    
    select into r_eys2 eys2.* from factura2_eys2, eys1
    where factura2_eys2.almacen = eys1.almacen
    and factura2_eys2.no_transaccion = eys1.no_transaccion
    and factura2_eys2.almacen = as_almacen
    and factura2_eys2.tipo = as_tipo
    and factura2_eys2.num_documento = ai_num_documento
    and eys1.status = ''P'';
    if found then
       return 0;
    end if;
    
    delete from factura2_eys2
    where almacen = as_almacen
    and tipo = as_tipo
    and num_documento = ai_num_documento;
    
    select into r_factura1 * from factura1
    where almacen = as_almacen
    and tipo = as_tipo
    and num_documento = ai_num_documento;
    
    
    select into r_factmotivos * from factmotivos
    where tipo = as_tipo;
    
    select into r_eys1 eys1.* from eys1
    where eys1.almacen = as_almacen
    and eys1.motivo = r_factmotivos.motivo
    and eys1.aplicacion_origen = ''FAC''
    and eys1.fecha = r_factura1.fecha_despacho;
    if not found then
       
    end if;
    

    
    for r_factura2 in select factura2.* from factura2, articulos 
                        where factura2.articulo = articulos.articulo
                        and articulos.servicio = ''N''
                        and factura2.almacen = as_almacen 
                        and factura2.tipo = as_tipo 
                        and factura2.num_documento = ai_num_documento
    loop
    
    end  loop;
        
    return 1;
end;
' language plpgsql;