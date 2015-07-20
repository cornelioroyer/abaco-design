drop function f_stock(char(2), char(15), date);
create function f_stock(char(2), char(15), date) returns decimal(12,4) as '
declare
    almacen alias for $1;
    articulo alias for $2;
    fecha alias for $3;
    stock decimal(12,4);
    ld_ultimo_cierre date;
begin
/*    stock := 0;
    select * from articulos
    where articulos.articulo = articulo
    and servicio = ''S'';
    if not found then
        select compania into ls_compania from almacen
        where almacen.almacen = almacen;
        
        select Max(final) into ld_ultimo_cierre from gralperiodos
        where compania = ls_compania
        and aplicacion = ''INV'' 
        and estado = ''I''
        and final < ld_fecha;
    
        if ld_ultimo_cierre is null then
            ld_ultimo_cierre := ''1960-01-01'';
        end if;
  */      
        select sum(eys2.cantidad * invmotivos.signo) into stock
        where eys1.almacen = eys2.almacen
        and eys1.no_transaccion = eys2.no_transaccion
        and eys1.motivo = invmotivos.motivo
        and eys1.almacen = almacen
        and eys2.articulo = articulo
        and eys1.fecha <= fecha;
//    end if;
    return stock;
end;
' language plpgsql;