insert into factura2
select almacen, tipo, num_documento, 1,
'FLETE', 1, acarreo, 0, 0
from f_conytram_resumen
where acarreo > 0 
and not exists
(select * from factura2
where factura2.almacen = f_conytram_resumen.almacen
and factura2.tipo = f_conytram_resumen.tipo
and factura2.num_documento = f_conytram_resumen.num_documento
and factura2.linea = 1);

insert into factura2
select almacen, tipo, num_documento, 2,
'OTROS INGRESOS', 1, otros_ingresos, 0, 0
from f_conytram_resumen
where otros_ingresos > 0 
and not exists
(select * from factura2
where factura2.almacen = f_conytram_resumen.almacen
and factura2.tipo = f_conytram_resumen.tipo
and factura2.num_documento = f_conytram_resumen.num_documento
and factura2.linea = 2);


insert into factura2
select almacen, tipo, num_documento, 3,
'CONFECCION', 1, confeccion, 0, 0
from f_conytram_resumen
where confeccion > 0 
and not exists
(select * from factura2
where factura2.almacen = f_conytram_resumen.almacen
and factura2.tipo = f_conytram_resumen.tipo
and factura2.num_documento = f_conytram_resumen.num_documento
and factura2.linea = 3);

insert into factura2
select almacen, tipo, num_documento, 4,
'MANEJO', 1, manejo, 0, 0
from f_conytram_resumen
where manejo > 0 
and not exists
(select * from factura2
where factura2.almacen = f_conytram_resumen.almacen
and factura2.tipo = f_conytram_resumen.tipo
and factura2.num_documento = f_conytram_resumen.num_documento
and factura2.linea = 4);


insert into factura2
select almacen, tipo, num_documento, 5,
'COD', 1, cod, 0, 0
from f_conytram_resumen
where cod > 0 
and not exists
(select * from factura2
where factura2.almacen = f_conytram_resumen.almacen
and factura2.tipo = f_conytram_resumen.tipo
and factura2.num_documento = f_conytram_resumen.num_documento
and factura2.linea = 5);

insert into factura2
select almacen, tipo, num_documento, 6,
'ADUANA', 1, aduana, 0, 0
from f_conytram_resumen
where aduana > 0 
and not exists
(select * from factura2
where factura2.almacen = f_conytram_resumen.almacen
and factura2.tipo = f_conytram_resumen.tipo
and factura2.num_documento = f_conytram_resumen.num_documento
and factura2.linea = 6);
