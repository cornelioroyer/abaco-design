update eys2
set costo = 0
where exists
(select * from eys1
where eys1.almacen = eys2.almacen
and eys1.no_transaccion = eys2.no_transaccion
and eys1.motivo = '11')
