update factura2
set precio = Round(precio, 2)
where almacen = '03'
and num_documento in (7,1644,200512);