

update factura1
set num_documento = 999916238
where almacen = '01'
and caja = '02'
and tipo = '08'
and num_documento = 16238


/*
select * from factura1
        where almacen_aplica = '01'
        and caja_aplica = '02'
        and tipo_aplica = '08'
        and num_factura = 16238;

    delete from eys2
    using factura2_eys2
    where factura2_eys2.almacen = eys2.almacen
    and factura2_eys2.articulo = eys2.articulo
    and factura2_eys2.no_transaccion = eys2.no_transaccion
    and factura2_eys2.eys2_linea = eys2.linea
    and factura2_eys2.almacen = '01'
    and factura2_eys2.tipo = '08'
    and factura2_eys2.caja = '02'
    and factura2_eys2.num_documento = 16238;

    delete from factura2_eys2
    where almacen = '01'
    and tipo = '08'
    and caja = '02'
    and num_documento = 16238;

select f_delete_rela_factura1_cglposteo('01', '02', '08', 16238);


*/

