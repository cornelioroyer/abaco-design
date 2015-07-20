
drop table tmp_matame;
create table tmp_matame as
select eys1.almacen, eys1.no_transaccion, 
f_sum_eys(eys1.almacen, no_transaccion, 'eys2') as eys2,
f_sum_eys(eys1.almacen, no_transaccion, 'eys3') as eys3
 from eys1, almacen
       where eys1.almacen = almacen.almacen
    and f_sum_eys(eys1.almacen, no_transaccion, 'eys2') <> f_sum_eys(eys1.almacen, no_transaccion, 'eys3')
    and fecha >= '2009-01-01'
    and eys1.almacen = '02'
    and aplicacion_origen not in ('COM','FAC')
    order by fecha;
    
select * from tmp_matame;    
