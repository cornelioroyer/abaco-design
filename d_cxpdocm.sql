rollback work;
begin work;
    delete from cxpdocm
    where compania = '01'
    and fecha_posteo >= '2009-08-01'
    and documento <> docmto_aplicar;
commit work;


begin work;
    delete from cxpdocm
    where compania = '01'
    and fecha_posteo >= '2009-08-01';
commit work;


/*

begin work;
    select f_update_cxpdocm('01');
commit work;
*/
