update precios_por_cliente_1
set fecha_hasta = '2007-12-31'
where precios_por_cliente_1.secuencia = precios_por_cliente_2.secuencia
and fecha_hasta >= current_date
and precios_por_cliente_2.articulo in ('02','22','12','03','13','01','21','11','04','05')
