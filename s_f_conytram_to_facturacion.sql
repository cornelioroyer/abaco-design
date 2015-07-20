rollback work;

begin work;
delete from cxcdocm
where almacen in (select almacen from almacen where compania = '01')
and fecha_posteo >= '2007-05-01'
and documento <> docmto_aplicar;
commit work;

begin work;
delete from cxcdocm
where almacen in (select almacen from almacen where compania = '01')
and fecha_posteo >= '2007-05-01';
commit work;



begin work;
select f_f_conytram_to_facturacion(f_conytram.almacen, f_conytram.tipo, f_conytram.no_documento)
from f_conytram, almacen, factmotivos
where f_conytram.almacen = almacen.almacen
and f_conytram.tipo = factmotivos.tipo
and almacen.compania = '01'
and fecha_factura >= '2007-05-01'
and (factmotivos.factura = 'S' or factmotivos.nota_credito = 'S')
and f_conytram.status <> 'A';
commit work;

begin work;
select f_update_cxcdocm_fac('01');
commit work;

begin work;
select f_update_cxcdocm_cxc('01');
commit work;

begin work;
select f_postea_fac('01');
commit work;

begin work;
select f_postea_cxc('01');
commit work;