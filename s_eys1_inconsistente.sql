
select * from eys1, almacen
       where eys1.almacen = almacen.almacen
    and f_sum_eys(eys1.almacen, no_transaccion, 'eys2') <> f_sum_eys(eys1.almacen, no_transaccion, 'eys3')
    and fecha >= '2013-10-01'
    and eys1.aplicacion_origen in ('FAC','INV')
    order by fecha
