

rollback work;

/*
begin work;
    delete from cxpdocm
    where compania = '03'
    and fecha_posteo >= '2014-12-01'
    and (documento <> docmto_aplicar or motivo_cxp <> motivo_cxp_ref);
commit work;


begin work;
    delete from cxpdocm
    where compania = '03'
    and fecha_posteo >= '2014-12-01';
commit work;
*/


begin work;
    delete from cglposteo
    where compania = '03'
    and fecha_comprobante >= '2014-12-01'
    and aplicacion_origen in ('CXP','BCO','PLA');
commit work;


begin work;
    select f_postea_cxp('03');
commit work;

begin work;
    select f_postea_bco('03');
commit work;
