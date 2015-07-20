drop view v_fac_declaracion_impuestos;
create view v_fac_declaracion_impuestos as 
select almacen.compania, gralcompanias.nombre, factura1.almacen, factura1.fecha_factura, factmotivos.descripcion,
factura1.num_documento, factura1.nombre_cliente,
case when gral_forma_de_pago.dias = 0 then f_desglose_factura(factura1.almacen, factura1.tipo, factura1.num_documento, 'VTA_GRAVADA') else 0 end as venta_gravada_contado,
case when gral_forma_de_pago.dias = 0 then 0 else f_desglose_factura(factura1.almacen, factura1.tipo, factura1.num_documento, 'VTA_GRAVADA') end as venta_gravada_credito,
case when gral_forma_de_pago.dias = 0 then f_desglose_factura(factura1.almacen, factura1.tipo, factura1.num_documento, 'VTA_EXCENTA') else 0 end as venta_excenta_contado,
case when gral_forma_de_pago.dias = 0 then 0 else f_desglose_factura(factura1.almacen, factura1.tipo, factura1.num_documento, 'VTA_EXCENTA') end as venta_excenta_credito,
case when gral_forma_de_pago.dias = 0 then f_desglose_factura(factura1.almacen, factura1.tipo, factura1.num_documento, 'IMPUESTO') else 0 end as impuesto_contado,
case when gral_forma_de_pago.dias = 0 then 0 else f_desglose_factura(factura1.almacen, factura1.tipo, factura1.num_documento, 'IMPUESTO') end as impuesto_credito,
case when gral_forma_de_pago.dias = 0 then f_desglose_factura(factura1.almacen, factura1.tipo, factura1.num_documento, 'TOTAL') else 0 end as total_contado,
case when gral_forma_de_pago.dias = 0 then 0 else f_desglose_factura(factura1.almacen, factura1.tipo, factura1.num_documento, 'TOTAL') end as total_credito
from factura1, factmotivos, almacen, gralcompanias, gral_forma_de_pago
where factura1.forma_pago = gral_forma_de_pago.forma_pago
and factura1.tipo = factmotivos.tipo
and factura1.almacen = almacen.almacen
and almacen.compania = gralcompanias.compania
and factura1.status <> 'A'
and (factmotivos.factura = 'S' or factmotivos.nota_credito = 'S' or factmotivos.devolucion = 'S')