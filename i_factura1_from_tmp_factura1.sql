insert into factura1(almacen, tipo, num_documento, cliente, forma_pago,
codigo_vendedor, nombre_cliente, descto_porcentaje, descto_monto, usuario_captura, usuario_postea,
fecha_vencimiento, fecha_captura, fecha_postea, fecha_factura, status,
num_cotizacion, num_factura,despachar, documento, ciudad_origen,
ciudad_destino, agente, bultos, peso, facturar)
select almacen, tipo, num_documento, cliente, forma_pago,
codigo_vendedor, nombre_cliente, descto_porcentaje, descto_monto, usuario_captura, 
usuario_postea,
fecha_vencimiento, fecha_captura, fecha_postea, fecha_factura, status,
num_cotizacion, num_factura,despachar, documento, '00',
'00', cliente, 0, 0, 'S'
from tmp_factura1