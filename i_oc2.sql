insert into oc2 (compania, numero_oc,
linea_oc, articulo, cantidad, costo, descuento)
select '01', 293, linea,
articulo, cantidad, (precio*cantidad), 0
from factura2
where num_documento = 1656;