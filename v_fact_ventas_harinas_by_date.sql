drop view v_fact_ventas_harinas_by_date;

/*==============================================================*/
/* View: fact_ventas_harinas                                    */
/*==============================================================*/
create view v_fact_ventas_harinas_by_date as
select a.compania, a.almacen, c.fecha_factura, d.articulo, 
sum(((((d.precio*d.cantidad)-d.descuento_linea-d.descuento_global))*b.signo)) as venta, 
sum((d.cantidad*f.factor*b.signo)) as cantidad 
from almacen a, factmotivos b, factura1 c, factura2 d, articulos e, convmedi f
where a.almacen = c.almacen and b.tipo = c.tipo and c.almacen = d.almacen and c.tipo = d.tipo 
and c.num_documento = d.num_documento and d.articulo = e.articulo 
and e.servicio = 'N'
and e.unidad_medida = f.old_unidad and f.new_unidad = '100LBS' 
and (b.factura = 'S' or b.devolucion = 'S') and c.status > 'A'
group by 1, 2, 3, 4
