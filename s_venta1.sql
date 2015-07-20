select sum(venta+devoluciones) from v_fac_resumen_z
where sec_z = 47;

select sum(factura2.cantidad*factura2.precio*factmotivos.signo)
from factura1, factura2, factmotivos
where factmotivos.tipo = factura1.tipo
and factura1.almacen = factura2.almacen
and factura1.tipo = factura2.tipo
and factura1.num_documento = factura2.num_documento
and factura1.sec_z = 47;
