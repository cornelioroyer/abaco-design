drop view v_cos_traspasos;
create view v_cos_traspasos as
select almacen.compania, Anio(eys1.fecha), Mes(eys1.fecha),
gral_valor_grupos.desc_valor_grupo, invmotivos.desc_motivo, invmotivos.motivo,
sum(eys2.cantidad * invmotivos.signo) as cantidad,
sum(eys2.costo * invmotivos.signo) as costo
from almacen, eys1, eys2, invmotivos, articulos_agrupados, gral_valor_grupos, 
cos_consumo_eys2, cos_consumo
where cos_consumo_eys2.secuencia = cos_consumo.secuencia
and cos_consumo_eys2.compania = cos_consumo.compania
and cos_consumo_eys2.linea = cos_consumo.linea
and cos_consumo.para_producir is not null
and cos_consumo_eys2.articulo = eys2.articulo
and cos_consumo_eys2.almacen = eys2.almacen
and cos_consumo_eys2.no_transaccion = eys2.no_transaccion
and cos_consumo_eys2.eys2_linea = eys2.linea
and almacen.almacen = eys1.almacen
and eys1.almacen = eys2.almacen
and eys1.no_transaccion = eys2.no_transaccion
and eys1.motivo = invmotivos.motivo
and eys2.articulo = articulos_agrupados.articulo
and articulos_agrupados.codigo_valor_grupo = gral_valor_grupos.codigo_valor_grupo
and gral_valor_grupos.grupo = 'SDI'
group by 1, 2, 3, 4, 5, 6