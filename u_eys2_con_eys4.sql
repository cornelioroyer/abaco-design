update eys2
set proveedor = eys4.proveedor,
fact_proveedor = eys4.fact_proveedor,
compania = eys4.compania
where eys2.articulo = eys4.articulo
and eys2.almacen = eys4.almacen
and eys2.no_transaccion = eys4.no_transaccion
and eys2.linea = eys4.inv_linea
and eys2.proveedor is null;
