

delete from factura2_eys2
where not exists
(select * from eys2
where eys2.almacen = factura2_eys2.almacen
and eys2.no_transaccion = factura2_eys2.no_transaccion
and eys2.linea = factura2_eys2.eys2_linea
and eys2.articulo = factura2_eys2.articulo);
