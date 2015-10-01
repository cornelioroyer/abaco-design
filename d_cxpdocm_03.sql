

rollback work;

begin work;
    delete from cglposteo
    where compania = '03'
    and fecha_comprobante >= '2015-04-01'
    and aplicacion_origen in ('BCO','CXP');
commit work;


begin work;
    delete from cxpdocm
    where compania = '03'
    and fecha_posteo >= '2015-04-01'
    and (documento <> docmto_aplicar or motivo_cxp <> motivo_cxp_ref);
commit work;


begin work;
    delete from cxpdocm
    where compania = '03'
    and fecha_posteo >= '2015-04-01';
commit work;


begin work;
    select f_update_cxpdocm('03');
commit work;


begin work;
    select f_postea_cxp('03');
commit work;


begin work;
    select f_postea_bco('03');
commit work;
