insert into factura2 (almacen, tipo, num_documento,
linea, articulo, cantidad, precio, descuento_linea,
descuento_global, cif)
select eys2.almacen, '00', 27, eys2.linea, eys2.articulo, eys2.cantidad, (eys2.costo/eys2.cantidad),
0, 0, 0
from cxpfact1, cxpfact2, eys4, eys2
where cxpfact1.proveedor = cxpfact2.proveedor
and cxpfact1.fact_proveedor = cxpfact2.fact_proveedor
and cxpfact1.compania = cxpfact2.compania
and cxpfact2.proveedor = eys4.proveedor
and cxpfact2.fact_proveedor = eys4.fact_proveedor
and cxpfact2.rubro_fact_cxp = eys4.rubro_fact_cxp
and cxpfact2.linea = eys4.cxp_linea
and cxpfact2.compania = eys4.compania
and eys4.articulo = eys2.articulo
and eys4.almacen = eys2.almacen
and eys4.no_transaccion = eys2.no_transaccion
and eys4.inv_linea = eys2.linea
and cxpfact1.numero_oc in (16,25)
and cxpfact1.compania = '03'