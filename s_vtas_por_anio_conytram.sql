select almacen.compania, Anio(factura1.fecha_factura), clientes.nomb_cliente,
factura1.cliente, 
sum(factura2.precio*factmotivos.signo) as monto
from almacen, factura1, factura2, clientes, factmotivos
where almacen.almacen = factura1.almacen
and factura1.almacen = factura2.almacen
and factura1.tipo = factura2.tipo
and factura1.num_documento = factura2.num_documento
and factura1.cliente = clientes.cliente
and factura1.tipo = factmotivos.tipo
and (factmotivos.factura = 'S' or factmotivos.nota_credito = 'S')
and factura2.articulo not in ('ITBMS')
and almacen.compania = '01'
group by 1, 2, 3, 4
order by 1, 2, 4