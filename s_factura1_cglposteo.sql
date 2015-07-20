
--select current_timestamp;
rollback work;
begin work;
select f_factura1_cglposteo(factura1.almacen, factura1.tipo, 
factura1.num_documento, factura1.caja),
factura1.num_documento, current_timestamp 
from almacen, factura1, factmotivos
where almacen.almacen = factura1.almacen
and factura1.tipo = factmotivos.tipo
and factmotivos.cotizacion = 'N' and factmotivos.donacion = 'N'
and factura1.status <> 'A'
and factura1.fecha_factura between '2014-01-01' and '2014-01-31';
commit work;

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
