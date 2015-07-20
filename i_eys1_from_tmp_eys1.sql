
insert into eys1 select * from tmp_eys1
where not exists
(select * from eys1 a
where a.almacen = tmp_eys1.almacen
and a.no_transaccion = tmp_eys1.no_transaccion);
