drop view v_fac_totales;
create view v_fac_totales as
select almacen.compania, factura1.almacen, factmotivos.descripcion, factura1.tipo, factura1.num_documento, factura1.cliente, 
factura1.nombre_cliente, factura1.fecha_factura, Anio(factura1.fecha_factura),
Mes(factura1.fecha_factura),
f_monto_factura(factura1.almacen, factura1.tipo, factura1.num_documento) as contado,
0 as credito
from factura1, factmotivos, gral_forma_de_pago, almacen
where factura1.tipo = factmotivos.tipo
and factura1.almacen = almacen.almacen
and factura1.forma_pago = gral_forma_de_pago.forma_pago
and gral_forma_de_pago.dias = 0
and factura1.status <> 'A'
and factmotivos.cotizacion = 'N'
and factmotivos.donacion = 'N'
union
select almacen.compania, factura1.almacen, factmotivos.descripcion, factura1.tipo, factura1.num_documento, factura1.cliente, 
factura1.nombre_cliente, factura1.fecha_factura, Anio(factura1.fecha_factura),
Mes(factura1.fecha_factura), 0, 
f_monto_factura(factura1.almacen, factura1.tipo, factura1.num_documento)
from factura1, factmotivos, gral_forma_de_pago, almacen
where factura1.tipo = factmotivos.tipo
and factura1.almacen = almacen.almacen
and factura1.forma_pago = gral_forma_de_pago.forma_pago
and gral_forma_de_pago.dias <> 0
and factura1.status <> 'A'
and factmotivos.cotizacion = 'N'
and factmotivos.donacion = 'N'
union
select almacen.compania, factura1.almacen, factmotivos.descripcion, factura1.tipo, factura1.num_documento, factura1.cliente, 
factura1.nombre_cliente, factura1.fecha_factura, Anio(factura1.fecha_factura),
Mes(factura1.fecha_factura), 0, 0
from factura1, factmotivos, gral_forma_de_pago, almacen
where factura1.tipo = factmotivos.tipo
and factura1.almacen = almacen.almacen
and factura1.forma_pago = gral_forma_de_pago.forma_pago
and factura1.status = 'A'
and factmotivos.cotizacion = 'N'
and factmotivos.donacion = 'N'