drop view v_factura_cglposteo;
create view v_factura_cglposteo as
select cglposteo.compania, factura1.num_documento, factura1.cliente,   
         factura1.nombre_cliente,   
         cglposteo.cuenta,   
         cglposteo.fecha_comprobante as fecha,   
         gralcompanias.nombre,   
         'RESUMEN DE FACTURAS POR CUENTA DE MAYOR' as titulo,
         sum(cglposteo.debito-cglposteo.credito) as monto
from gralcompanias, factura1, cglposteo, rela_factura1_cglposteo
where gralcompanias.compania = cglposteo.compania
and factura1.almacen = rela_factura1_cglposteo.almacen
and factura1.tipo = rela_factura1_cglposteo.tipo
and factura1.num_documento = rela_factura1_cglposteo.num_documento
and cglposteo.consecutivo = rela_factura1_cglposteo.consecutivo
group by cglposteo.compania, factura1.num_documento, factura1.cliente,   
         factura1.nombre_cliente,   
         cglposteo.cuenta,   
         cglposteo.fecha_comprobante,
         gralcompanias.nombre
union
select almacen.compania, factura1.num_documento, factura1.cliente,   
         factura1.nombre_cliente, eys2.cuenta,
         eys1.fecha,   
         gralcompanias.nombre,   
         'RESUMEN DE FACTURAS POR CUENTA DE MAYOR' as titulo,
         -(eys2.costo*invmotivos.signo)
from gralcompanias, factura1, factura2_eys2, eys2, almacen, eys1, invmotivos
where gralcompanias.compania = almacen.compania
and factura1.almacen = almacen.almacen
and factura1.almacen = factura2_eys2.almacen
and factura1.tipo = factura2_eys2.tipo
and factura1.num_documento = factura2_eys2.num_documento
and eys2.articulo = factura2_eys2.articulo
and eys2.almacen = factura2_eys2.almacen
and eys2.no_transaccion = factura2_eys2.no_transaccion
and eys2.linea = factura2_eys2.eys2_linea
and eys1.almacen = eys2.almacen
and eys1.no_transaccion = eys2.no_transaccion
and eys1.motivo = invmotivos.motivo
union
select almacen.compania, factura1.num_documento, factura1.cliente,   
         factura1.nombre_cliente, articulos_por_almacen.cuenta,
         eys1.fecha,   
         gralcompanias.nombre,   
         'RESUMEN DE FACTURAS POR CUENTA DE MAYOR' as titulo,
         (eys2.costo*invmotivos.signo)
from gralcompanias, factura1, factura2_eys2, eys2, almacen, eys1, invmotivos, articulos_por_almacen
where gralcompanias.compania = almacen.compania
and factura1.almacen = almacen.almacen
and factura1.almacen = factura2_eys2.almacen
and factura1.tipo = factura2_eys2.tipo
and factura1.num_documento = factura2_eys2.num_documento
and eys2.articulo = factura2_eys2.articulo
and eys2.almacen = factura2_eys2.almacen
and eys2.no_transaccion = factura2_eys2.no_transaccion
and eys2.linea = factura2_eys2.eys2_linea
and eys1.almacen = eys2.almacen
and eys1.no_transaccion = eys2.no_transaccion
and eys1.motivo = invmotivos.motivo
and eys2.almacen = articulos_por_almacen.almacen
and eys2.articulo = articulos_por_almacen.articulo
