
update factura1
set fecha_factura = '2015-06-30'
where factura1.fecha_factura between '2007-03-27' and '2007-03-27'
and not exists
    (select * from rela_factura1_cglposteo
        where rela_factura1_cglposteo.almacen = factura1.almacen
        and rela_factura1_cglposteo.tipo = factura1.tipo
        and rela_factura1_cglposteo.caja = factura1.caja
        and rela_factura1_cglposteo.num_documento = factura1.num_documento)





--select current_timestamp;
/*

select factura1.fecha_factura, factura1.num_documento, factura1.fecha_factura
from almacen, factura1, factmotivos
where almacen.almacen = factura1.almacen
and factura1.tipo = factmotivos.tipo
and factmotivos.cotizacion = 'N' and factmotivos.donacion = 'N'
and almacen.compania = '03'
and factura1.status <> 'A'
and factura1.fecha_factura between '2007-03-27' and '2007-03-27'
and not exists
    (select * from rela_factura1_cglposteo
        where rela_factura1_cglposteo.almacen = factura1.almacen
        and rela_factura1_cglposteo.tipo = factura1.tipo
        and rela_factura1_cglposteo.caja = factura1.caja
        and rela_factura1_cglposteo.num_documento = factura1.num_documento)
order by factura1.fecha_factura;


select factura1.fecha_factura, factura1.num_documento, current_timestamp,
    f_factura1_cglposteo(factura1.almacen, factura1.tipo, factura1.num_documento, factura1.caja)
from almacen, factura1, factmotivos
where almacen.almacen = factura1.almacen
and factura1.tipo = factmotivos.tipo
and factmotivos.cotizacion = 'N' and factmotivos.donacion = 'N'
and almacen.compania = '01'
and factura1.status <> 'A'
and factura1.fecha_factura between '2011-10-28' and '2011-10-31'
and not exists
    (select * from rela_factura1_cglposteo
        where rela_factura1_cglposteo.almacen = factura1.almacen
        and rela_factura1_cglposteo.tipo = factura1.tipo
        and rela_factura1_cglposteo.caja = factura1.caja
        and rela_factura1_cglposteo.num_documento = factura1.num_documento)
order by factura1.fecha_factura;



select f_factura1_cglposteo(factura1.almacen, factura1.tipo, 
factura1.num_documento, factura1.caja),
factura1.num_documento, current_timestamp 
from almacen, factura1, factmotivos
where almacen.almacen = factura1.almacen
and factura1.tipo = factmotivos.tipo
and factmotivos.cotizacion = 'N' and factmotivos.donacion = 'N'
and almacen.compania = '02'
and factura1.status <> 'A'
and factura1.fecha_factura between '2013-06-01' and '2013-06-30'
*/

--select current_timestamp;
   
/*    
and not exists
    (select * from rela_factura1_cglposteo
        where rela_factura1_cglposteo.almacen = factura1.almacen
        and rela_factura1_cglposteo.tipo = factura1.tipo
        and rela_factura1_cglposteo.caja = factura1.caja
        and rela_factura1_cglposteo.num_documento = factura1.num_documento)
order by factura1.fecha_factura;


and factura1.num_documento = 14676

select f_factura1_cglposteo(almacen, tipo, num_documento, caja) 
from factura1
where fecha_factura between '2013-01-01' and '2013-01-02'
and not exists
(select * from rela_factura1_cglposteo
where rela_factura1_cglposteo.almacen = factura1.almacen

and rela_factura1_cglposteo.tipo = factura1.tipo
and rela_factura1_cglposteo.num_documento = factura1.num_documento);
*/    
