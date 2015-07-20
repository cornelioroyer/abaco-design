



rollback work;

begin work;
    delete from cxcdocm
    where almacen in (select almacen from almacen where compania = '03')
    and (documento <> docmto_aplicar or motivo_cxc <> motivo_ref)
    and fecha_posteo >= '2015-01-01';
commit work;


begin work;
    delete from cxcdocm
    where almacen in (select almacen from almacen where compania = '03')
    and fecha_posteo >= '2015-01-01';
commit work;


begin work;
    delete from cglposteo
    where compania = '03'
    and fecha_comprobante between '2015-01-11' and '2015-01-20'
    and aplicacion_origen in ('FAC','TAL','CXC');
commit work;




begin work;
    select f_postea_fac('03');
commit work;

begin work;
    select f_postea_cxc('03');
commit work;


