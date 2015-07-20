select almacen, tipo, num_documento,
from factmotivos a, factura1 b,
factura4 c
where a.tipo = b.tipo
and b.almacen = c.almacen
and b.tipo = c.tipo
and b.num_documento = 