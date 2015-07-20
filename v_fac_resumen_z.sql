drop view v_fac_resumen_z;

create view v_fac_resumen_z as
select factura1.cajero, almacen.compania, gralcompanias.nombre, gralcompanias.id_tributario, 
gralcompanias.dv, factura1.almacen, almacen.desc_almacen, factura1.caja, factura1.tipo, 
factura1.num_documento, factura1.sec_z, 
gral_forma_de_pago.dias, fac_z.fecha as fecha, fac_z.hora as hora,
f_desglose_factura(factura1.almacen, factura1.tipo, factura1.num_documento,'VENTA') as venta,
f_desglose_factura(factura1.almacen, factura1.tipo, factura1.num_documento,'DESCUENTO') as descuento,
f_desglose_factura(factura1.almacen, factura1.tipo, factura1.num_documento,'VTA_GRAVADA') as venta_gravada,
f_desglose_factura(factura1.almacen, factura1.tipo, factura1.num_documento,'DEVOLUCION') as devoluciones,
f_desglose_factura(factura1.almacen, factura1.tipo, factura1.num_documento,'IMPUESTO') as impuesto,
f_desglose_factura(factura1.almacen, factura1.tipo, factura1.num_documento,'EFECTIVO') as efectivo,
f_desglose_factura(factura1.almacen, factura1.tipo, factura1.num_documento,'CHEQUE') as cheque,
f_desglose_factura(factura1.almacen, factura1.tipo, factura1.num_documento,'TARJETA_CREDITO') as tarjeta_credito,
f_desglose_factura(factura1.almacen, factura1.tipo, factura1.num_documento,'TARJETA_DEBITO') as tarjeta_debito,
f_desglose_factura(factura1.almacen, factura1.tipo, factura1.num_documento,'OTRO') as otro
from almacen, factura1, gral_forma_de_pago, factmotivos, fac_z, gralcompanias
where almacen.compania = gralcompanias.compania
and factura1.almacen = fac_z.almacen
and factura1.caja = fac_z.caja
and factura1.sec_z = fac_z.sec_z
and almacen.almacen = factura1.almacen
and factura1.forma_pago = gral_forma_de_pago.forma_pago
and factura1.tipo = factmotivos.tipo
and factura1.status <> 'A'
and (factmotivos.factura = 'S' or factmotivos.devolucion = 'S')