drop view f_conytram_resumen;
create view f_conytram_resumen as
select tipo, almacen, no_documento as num_documento, trim(cast(no_documento as char(10))) as documento, 
clientes.cliente, fecha_factura, monto_manejo as manejo, 
monto_documentacion as confeccion, (otros_ingresos1+otros_ingresos2+otros_ingresos3+otros_ingresos4+valor_x_linea) as otros_ingresos, 
(monto_cod1+monto_cod2+monto_cod3) as cod, 
monto_aduana as aduana, monto_acarreo as acarreo, itbms,
(monto_manejo+monto_documentacion+otros_ingresos1+otros_ingresos2+otros_ingresos3+otros_ingresos4+monto_cod1+monto_cod2+monto_cod3+monto_aduana+monto_acarreo+valor_x_linea+itbms) as total,
clientes.nomb_cliente as nombre_cliente
from f_conytram, clientes where f_conytram.cliente = clientes.cliente and tipo in (select tipo from factmotivos where cotizacion = 'N' and donacion = 'N');

