//drop function f_stock(char(2), char(15), date, char(20));
drop function f_stock(char(2), char(15), date, integer, text);
create function f_stock(char(2), char(15), date, integer, text) returns decimal(12,4) as '
declare
    as_almacen alias for $1;
    as_articulo alias for $2;
    ad_fecha alias for $3;
    ai_no_transaccion alias for $4;
    as_retornar alias for $5;
    stock decimal(12,4);
    ld_ultimo_cierre date;
    registro record;
    li_year integer;
    li_periodo integer;
    ldc_existencia1 decimal(12,4);
    ldc_existencia2 decimal(12,4);
    ldc_costo1 decimal(12,4);
    ldc_costo2 decimal(12,4);
    ldc_retornar decimal(12,4);
begin
    stock := 0;
    select into registro * from articulos
    where articulos.articulo = as_articulo
    and servicio = ''S'';
    if found then
       return 0;
    end if;
        
    select Max(final) into ld_ultimo_cierre from gralperiodos, almacen
    where almacen.compania = gralperiodos.compania
    and almacen.almacen = as_almacen
    and aplicacion = ''INV'' 
    and estado = ''I''
    and final < ad_fecha;

    if ld_ultimo_cierre is null then
        ld_ultimo_cierre := ''1960-01-01'';
    else
        select year into li_year from gralperiodos, almacen
        where gralperiodos.compania = almacen.compania
        and almacen.almacen = as_almacen
        and aplicacion = ''INV''
        and estado = ''I''
        and final = ld_ultimo_cierre;

        select periodo into li_periodo from gralperiodos, almacen
        where gralperiodos.compania = almacen.compania
        and almacen.almacen = as_almacen
        and aplicacion = ''INV''
        and estado = ''I''
        and final = ld_ultimo_cierre;
    end if;

    select existencia, costo into ldc_existencia1, ldc_costo1 from invbalance
    where almacen = as_almacen
    and articulo = as_articulo
    and year = li_year
    and periodo = li_periodo;
    if ldc_existencia1 is null then
        ldc_existencia1 := 0;
    end if;
    
    if ldc_costo1 is null then
        ldc_costo1 := 0;
    end if;
    
        select sum(eys2.cantidad * invmotivos.signo), sum(eys2.costo * invmotivos.signo) 
        into ldc_existencia2, ldc_costo2 from eys1, eys2, invmotivos
        where eys1.almacen = eys2.almacen
        and eys1.no_transaccion = eys2.no_transaccion
        and eys1.motivo = invmotivos.motivo
        and eys1.almacen = as_almacen
        and eys2.articulo = as_articulo
        and eys1.fecha > ld_ultimo_cierre
        and eys1.fecha <= ad_fecha;
    
    if ldc_existencia2 is null then
        ldc_existencia2 := 0;
    end if;
    
    if ldc_costo2 is null then
        ldc_costo2 := 0;
    end if;
    
    
    if as_retornar = ''COSTO'' then
        ldc_retornar := ldc_costo1 + ldc_costo2;
    else
        ldc_retornar := ldc_existencia1 + ldc_existencia2;
    end if;
    
    return ldc_retornar;
end;
' language plpgsql;