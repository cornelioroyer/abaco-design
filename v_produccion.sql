drop view v_ventas_x_mes;
create view v_ventas_x_mes as
select Anio(factura1.fecha_factura) as anio,
Mes(factura1.fecha_factura) as mes, gral_valor_grupos.desc_valor_grupo as descripcion,
factura2.articulo,
sum(factura2.cantidad) as cantidad,
sum((factura2.precio*factura2.cantidad) - factura2.descuento_linea - factura2.descuento_global) as venta
from factura1, factura2, factmotivos, articulos_agrupados, gral_valor_grupos
where factura2.articulo = articulos_agrupados.articulo
and articulos_agrupados.codigo_valor_grupo = gral_valor_grupos.codigo_valor_grupo
and gral_valor_grupos.grupo = 'CLA'
and gral_valor_grupos.aplicacion = 'INV'
and factmotivos.tipo = factura1.tipo
and factmotivos.factura = 'S'
and factura1.almacen = factura2.almacen
and factura1.tipo = factura2.tipo
and factura1.num_documento = factura2.num_documento
and factura1.status <> 'A'
group by 1, 2, 3, 4
order by 1, 2, 3;


drop view v_produccion;
create view v_produccion as
select Anio(eys1.fecha), Mes(eys1.fecha), gral_valor_grupos.desc_valor_grupo as descripcion,
eys2.articulo, articulos.desc_articulo, articulos.orden_impresion,
sum(eys2.cantidad*invmotivos.signo)
from eys1, eys2, invmotivos, articulos, articulos_agrupados,
gral_valor_grupos
where articulos.articulo = articulos_agrupados.articulo
and articulos_agrupados.codigo_valor_grupo = gral_valor_grupos.codigo_valor_grupo
and gral_valor_grupos.grupo = 'CLA'
and gral_valor_grupos.aplicacion = 'INV'
and eys2.articulo = articulos.articulo
and eys1.almacen = eys2.almacen
and eys1.no_transaccion = eys2.no_transaccion
and eys1.motivo = invmotivos.motivo
and eys1.motivo in ('01','12')
group by 1, 2, 3, 4, 5, 6
order by 1, 2, 3;

drop view v_consumo_trigo;
create view v_consumo_trigo as
select Anio(eys1.fecha), Mes(eys1.fecha), eys2.articulo, articulos.desc_articulo,
-sum(eys2.cantidad*invmotivos.signo) as cantidad, (sum(eys2.costo)/sum(eys2.cantidad)) as cu
from eys1, eys2, invmotivos, articulos
where eys2.articulo = articulos.articulo
and eys1.almacen = eys2.almacen
and eys1.no_transaccion = eys2.no_transaccion
and eys1.motivo = invmotivos.motivo
and eys1.aplicacion_origen in ('COS')
and eys2.articulo like 'TRIGO%'
group by 1, 2, 3, 4
order by 1, 2, 3;

drop view v_dividendos_e_intereses;
create view v_dividendos_e_intereses as
select Anio(cglposteo.fecha_comprobante) as anio, Mes(cglposteo.fecha_comprobante) as mes,
cgl_financiero.d_fila as cuenta, -sum(debito-credito) as monto
from cglposteo, cgl_financiero
where cglposteo.cuenta = cgl_financiero.cuenta
and cgl_financiero.no_informe = 8
and compania = '03'
and cglposteo.periodo <> 13
group by 1, 2, 3


