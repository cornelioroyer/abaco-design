drop function f_ultimo_costo_unitario(char(2), char(15), date) cascade;

create function f_ultimo_costo_unitario(char(2), char(15), date) returns decimal(12,4) as '
declare
    as_almacen alias for $1;
    as_articulo alias for $2;
    ad_fecha alias for $3;
    stock decimal(12,4);
    ld_ultimo_cierre date;
    r_articulos record;
    r_articulos_por_almacen record;
    r_work record;
    r_eys2 record;
    li_year integer;
    li_periodo integer;
    ldc_existencia1 decimal(12,4);
    ldc_existencia2 decimal(12,4);
    ldc_costo1 decimal(12,4);
    ldc_costo2 decimal(12,4);
    ldc_retornar decimal;
    ldc_costo decimal;
    ldc_cantidad decimal;
    ldc_cu decimal;
begin
    stock           =   0;
    ldc_retornar    =   0;
    ldc_cu          =   0;
    select into r_articulos * from articulos
    where articulos.articulo = as_articulo;
    if r_articulos.servicio = ''S'' then
       return 0;
    end if;
    
    select into r_articulos_por_almacen * from articulos_por_almacen
    where almacen = as_almacen
    and articulo = as_articulo;
    if not found then
        return 0;
    end if;
    
    select Max(fecha) into ld_ultimo_cierre from eys1, eys2
    where eys1.almacen = eys2.almacen
    and eys1.no_transaccion = eys2.no_transaccion
    and eys2.almacen = as_almacen
    and eys2.articulo = as_articulo
    and eys1.aplicacion_origen = ''COM''
    and eys2.cantidad > 0
    and eys1.fecha <= ad_fecha;
    if ld_ultimo_cierre is not null then
        select (sum(eys2.costo)/sum(eys2.cantidad)) into ldc_cu
        from eys1, eys2
        where eys1.almacen = eys2.almacen
        and eys1.no_transaccion = eys2.no_transaccion
        and eys2.almacen = as_almacen
        and eys2.articulo = as_articulo
        and eys1.aplicacion_origen = ''COM''
        and eys2.cantidad > 0
        and eys2.costo is not null
        and eys2.cantidad is not null
        and eys1.fecha = ld_ultimo_cierre;
        if found then
            return ldc_cu;
        end if;
    end if;

    return ldc_cu;
end;
' language plpgsql;