

select articulos_por_almacen.cuenta, sum(venta)
from v_factura1_factura2, articulos_por_almacen
where fecha_factura between '2014-01-01' and '2014-09-30'
and articulos_por_almacen.almacen = v_factura1_factura2.almacen
and articulos_por_almacen.articulo = v_factura1_factura2.articulo
and v_factura1_factura2.tipo <> 'DA'
group by 1
order by 1


/*
select sum(venta)
from v_factura1_factura2, articulos_por_almacen
where fecha_factura between '2014-01-01' and '2014-09-30'
and articulos_por_almacen.almacen = v_factura1_factura2.almacen
and articulos_por_almacen.articulo = v_factura1_factura2.articulo
and v_factura1_factura2.tipo <> 'DA'
*/


