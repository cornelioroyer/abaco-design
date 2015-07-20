
/*
delete from eys1
where aplicacion_origen = 'FAC'
and fecha >= '2005-05-01';

select f_factura_inventario(almacen, tipo, num_documento) from factura1
where fecha_despacho >= '2005-05-01' and fecha_despacho is not null and despachar = 'S';



delete from cxcdocm
where fecha_posteo >= '2005-05-01';

select f_factura_cxcdocm(almacen, tipo, num_documento) from factura1
where fecha_factura >= '2005-05-01';
*/

select f_cxctrx1_cxcdocm(almacen, sec_ajuste_cxc), sec_ajuste_cxc from cxctrx1
where fecha_posteo_ajuste_cxc >= '2005-05-01';

