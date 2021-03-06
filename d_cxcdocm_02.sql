

rollback work;


begin work;
    update gralparaxcia
    set valor = 'N'
    where parametro = 'validar_fecha'
    and aplicacion = 'CXC';
commit work;


begin work;
    delete from cglposteo
    where compania = '02'
    and fecha_comprobante >= '2015-01-01'
    and aplicacion_origen in ('CXC','FAC');
commit work;


begin work;
    delete from cxcdocm
    where almacen in (select almacen from almacen where compania = '02')
    and (documento <> docmto_aplicar or motivo_cxc <> motivo_ref)
    and fecha_posteo >= '2015-01-01';
commit work;


begin work;
    delete from cxcdocm
    where almacen in (select almacen from almacen where compania = '02')
    and fecha_posteo >= '2015-01-01';
commit work;


delete from rela_cxc_recibo1_cglposteo
where almacen = '02' 
and exists
(select * from cxc_recibo1
where cxc_recibo1.almacen = rela_cxc_recibo1_cglposteo.almacen
and cxc_recibo1.caja = rela_cxc_recibo1_cglposteo.caja
and cxc_recibo1.consecutivo = rela_cxc_recibo1_cglposteo.consecutivo
and cxc_recibo1.fecha >= '2015-01-01');


/*
begin work;
    select f_update_cxcdocm_fac('02');
commit work;


begin work;
    select f_update_cxcdocm_cxc('02');
commit work;


begin work;
    select f_postea_fac('02');
commit work;


begin work;
    select f_postea_cxc('02');
commit work;
*/

update gralparaxcia
set valor = 'S'
where parametro = 'validar_fecha'
and aplicacion = 'CXC';

