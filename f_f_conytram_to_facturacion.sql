


begin work;
delete from cxcdocm
where almacen in (select almacen from almacen where compania = '01')
and documento <> docmto_aplicar
and fecha_posteo >= '2012-03-28';
commit work;

select f_f_conytram_to_facturacion(almacen, tipo, no_documento)
from f_conytram 
where fecha_factura between '2012-03-28' and '2012-04-30';

select f_update_factura4(almacen, tipo, no_documento)
from f_conytram 
where fecha_factura between '2012-03-28' and '2012-04-30' and tipo = '7';


begin work;
select f_update_cxcdocm_fac('01');
commit work;

begin work;
select f_update_cxcdocm_cxc('01');
commit work;
