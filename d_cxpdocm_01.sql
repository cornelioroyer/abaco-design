rollback work;
begin work;
    delete from cxpdocm
    where compania = '01'
    and fecha_posteo >= '2004-01-01'
    and (documento <> docmto_aplicar or motivo_cxp <> motivo_cxp_ref);
commit work;


begin work;
    delete from cxpdocm
    where compania = '01'
    and fecha_posteo >= '2004-01-01';
commit work;


begin work;
    select f_update_cxpdocm('01');
commit work;
