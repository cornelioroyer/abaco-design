drop view fact_ventas_harinas;

/*==============================================================*/
/* View: fact_ventas_harinas                                    */
/*==============================================================*/
create view fact_ventas_harinas as
select d.linea, a.compania, a.almacen, c.num_documento, c.codigo_vendedor as vendedor, c.cliente, 
c.fecha_factura, Anio(c.fecha_factura) as anio, Mes(c.fecha_factura) as mes, c.forma_pago, 
d.articulo, 
((((d.precio*d.cantidad)-d.descuento_linea-d.descuento_global))*b.signo) as venta, 
(d.cantidad*f.factor*b.signo) as cantidad 
from almacen a, factmotivos b, factura1 c, factura2 d, articulos e, convmedi f
where a.almacen = c.almacen and b.tipo = c.tipo and c.almacen = d.almacen and c.tipo = d.tipo 
and c.num_documento = d.num_documento and d.articulo = e.articulo 
and e.servicio = 'N'
and e.unidad_medida = f.old_unidad and f.new_unidad = '100LBS' 
and (b.factura = 'S' or b.devolucion = 'S') and c.status > 'A';

