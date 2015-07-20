rollback work;

begin work;
    update gralparaxcia
    set valor = 'N'
    where parametro = 'validar_fecha'
    and aplicacion = 'CXP';
commit work;

begin work;
    delete from cxpdocm
    where compania = '03'
    and fecha_posteo >= '2009-10-01'
    and (documento <> docmto_aplicar or motivo_cxp <> motivo_cxp_ref);
commit work;



begin work;
    delete from cxpdocm
    where compania = '03'
    and fecha_posteo >= '2009-10-01';
commit work;


/*
begin work;
    select f_update_cxpdocm('03');
commit work;
*/



begin work;
    update gralparaxcia
    set valor = 'S'
    where parametro = 'validar_fecha'
    and aplicacion = 'CXP';
commit work;