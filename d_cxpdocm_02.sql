

rollback work;

/*
begin work;
    delete from cglposteo
    where compania = '02'
    and fecha_comprobante >= '2010-11-01'
    and aplicacion_origen in ('BCO','CXP','COM');
commit work;
*/



begin work;
    delete from cxpdocm
    where compania = '02'
    and fecha_posteo >= '2014-11-01'
    and (documento <> docmto_aplicar or motivo_cxp <> motivo_cxp_ref);
commit work;


begin work;
    delete from cxpdocm
    where compania = '02'
    and fecha_posteo >= '2010-11-01';
commit work;


/*
begin work;
    select f_update_cxpdocm('02');
commit work;


begin work;
    select f_postea_cxp('02');
commit work;


begin work;
    select f_postea_bco('02');
commit work;
*/
