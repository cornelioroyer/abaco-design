select a.*  from descuentos a, descuentos_por_grupo b
where
a.secuencia = b.secuencia and cast(2.00 as decimal)
 between a.cantidad_desde and a.cantidad_hasta and '2001-04-20'
 between a.fecha_desde and a.fecha_hasta and a.status = 'A'  and b.codigo_valor_grupo = '003' 
