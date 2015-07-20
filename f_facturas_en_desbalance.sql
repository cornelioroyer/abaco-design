
drop function f_facturas_en_desbalance(char(2)) cascade;

create function f_facturas_en_desbalance(char(2)) returns integer as '
declare
    as_compania alias for $1;
    ld_desde date;
    r_work record;
begin
    select Min(inicio) into ld_desde
    from gralperiodos
    where compania = as_compania
    and aplicacion = ''CGL''
    and estado = ''A'';
    if not found then
        return 0;
    end if;
    
    for r_work in select factura1.almacen, factura1.tipo, factura1.num_documento, factura1.caja, count(*)
                    from rela_factura1_cglposteo, factura1, almacen, factmotivos
                    where factura1.tipo = factmotivos.tipo
                    and factmotivos.cotizacion = ''N'' and factmotivos.donacion = ''N''
                    and factura1.almacen = almacen.almacen
                    and factura1.almacen = rela_factura1_cglposteo.almacen                    
                    and factura1.tipo = rela_factura1_cglposteo.tipo
                    and factura1.num_documento = rela_factura1_cglposteo.num_documento
                    and factura1.caja = rela_factura1_cglposteo.caja
                    and factura1.fecha_factura >= ld_desde
                    and almacen.compania = as_compania
                    group by 1, 2, 3, 4
                    having count(*) <= 1
                    order by 1, 2, 3
    loop
        delete from rela_factura1_cglposteo
        where almacen = r_work.almacen
        and tipo = r_work.tipo
        and caja = r_work.caja
        and num_documento = r_work.num_documento;
    end loop;
    

    for r_work in select factura1.almacen, factura1.tipo, factura1.num_documento, factura1.caja,
                    sum(cglposteo.debito-cglposteo.credito)
                    from factura1, rela_factura1_cglposteo, cglposteo, almacen, factmotivos
                    where factura1.almacen = almacen.almacen
                    and factura1.tipo = factmotivos.tipo
                    and factmotivos.cotizacion = ''N'' and factmotivos.donacion = ''N''
                    and factura1.tipo = rela_factura1_cglposteo.tipo
                    and factura1.almacen = rela_factura1_cglposteo.almacen                    
                    and factura1.tipo = rela_factura1_cglposteo.tipo
                    and factura1.num_documento = rela_factura1_cglposteo.num_documento
                    and factura1.caja = rela_factura1_cglposteo.caja
                    and rela_factura1_cglposteo.consecutivo = cglposteo.consecutivo
                    and factura1.fecha_factura >= ld_desde
                    and almacen.compania = as_compania
                    group by 1, 2, 3, 4
                    having sum(cglposteo.debito-cglposteo.credito) <> 0    
    loop
        delete from rela_factura1_cglposteo
        where almacen = r_work.almacen
        and tipo = r_work.tipo
        and caja = r_work.caja
        and num_documento = r_work.num_documento;
    end loop;
    
    return 1;
end;
' language plpgsql;

