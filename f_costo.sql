drop function f_costo(char(2), char(15), date);
create function f_costo(char(2), char(15), date) returns decimal(12,4)
as 'select  sum(eys2.costo * invmotivos.signo)
where eys1.almacen = eys2.almacen
and eys1.no_transaccion = eys2.no_transaccion
and eys1.motivo = invmotivos.motivo
and eys1.almacen = $1
and eys2.articulo = $2
and eys1.fecha <= $3;' language 'sql';

