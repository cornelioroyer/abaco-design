insert into eys2 select * from tmp_eys2
where not exists
(select * from eys2 a
where a.almacen = tmp_eys2.almacen
and a.no_transaccion = tmp_eys2.no_transaccion
and a.articulo = tmp_eys2.articulo
and a.linea = tmp_eys2.linea);
